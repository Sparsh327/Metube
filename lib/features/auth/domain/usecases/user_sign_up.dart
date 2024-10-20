import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';
import 'package:metube/core/usecase/usecase.dart';
import 'package:metube/core/common/entities/user.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<AppUser, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, AppUser>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  UserSignUpParams(
      {required this.name, required this.email, required this.password});
  final String email;
  final String password;
  final String name;
}
