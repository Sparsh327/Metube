import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';
import 'package:metube/core/useecase/usecase.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements Usecase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Faliure, String>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  UserSignUpParams({required this.email, required this.password});
  final String email;
  final String password;
}
