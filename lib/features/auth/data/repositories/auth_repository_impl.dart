import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/exceptions.dart';
import 'package:metube/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/faliures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Faliure, String>> loginWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Faliure, String>> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userId = await authRemoteDataSource.signUpWithEmailAndPassword(
          email: email, password: password);
      return right(userId);
    } on ServerException catch (e) {
      return left(Faliure(e.message));
    }
  }
}
