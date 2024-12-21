import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/exceptions.dart';
import 'package:metube/core/network/connection_checker.dart';
import 'package:metube/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:metube/core/common/entities/user.dart';
import 'package:metube/features/auth/data/models/app_user_model.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/faliures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(
      {required this.connectionChecker, required this.authRemoteDataSource});
  @override
  Future<Either<Failure, AppUser>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = authRemoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        return right(
          AppUserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(
      {required String email, required String password}) {
    return _getUser(() async => await authRemoteDataSource
        .loginWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailAndPassword(
          email: email, password: password, name: name),
    );
  }

  Future<Either<Failure, AppUser>> _getUser(
    Future<AppUser> Function() fn,
  ) async {
    try {
      final userModel = await fn();
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> userLogout() async {
    try {
      final val = await authRemoteDataSource.userLogout();
      return right(val);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
