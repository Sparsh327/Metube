import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';

import 'package:metube/core/usecase/usecase.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

class UserLogout implements UseCase<void, NoParams> {
  final AuthRepository authRepository;
  UserLogout(this.authRepository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.userLogout();
  }
}
