import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
