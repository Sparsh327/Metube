import 'package:fpdart/fpdart.dart';
import 'package:metube/core/common/entities/user.dart';
import 'package:metube/core/usecase/usecase.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';

import 'package:metube/core/error/faliures.dart';

class CurrentUser implements UseCase<AppUser, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, AppUser>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
