import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';
import 'package:metube/core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AppUser>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<Failure, AppUser>> currentUser();
}
