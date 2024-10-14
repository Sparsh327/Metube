import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';

abstract interface class AuthRepository {
  Future<Either<Faliure, String>> signUpWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Faliure, String>> loginWithEmailAndPassword(
      {required String email, required String password});
}
