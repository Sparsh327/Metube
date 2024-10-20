import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';
import 'package:metube/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Faliure, AppUser>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});

  Future<Either<Faliure, AppUser>> loginWithEmailAndPassword(
      {required String email, required String password});
}
