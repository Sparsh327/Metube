import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';
import 'package:metube/core/common/entities/user.dart';
import 'package:metube/core/usecase/usecase.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<AppUser, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, AppUser>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParams {
  UserLoginParams({required this.email, required this.password});

  final String email;
  final String password;
}
