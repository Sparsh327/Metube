import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/exceptions.dart';
import 'package:metube/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:metube/features/auth/domain/entities/user.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/faliures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Faliure, AppUser>> loginWithEmailAndPassword(
      {required String email, required String password}) {
    return _getUser(() async => await authRemoteDataSource
        .loginWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<Either<Faliure, AppUser>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailAndPassword(
          email: email, password: password, name: name),
    );
  }

  Future<Either<Faliure, AppUser>> _getUser(
    Future<AppUser> Function() fn,
  ) async {
    try {
      final userModel = await fn();
      return right(userModel);
    } on ServerException catch (e) {
      return left(Faliure(e.message));
    }
  }
}
