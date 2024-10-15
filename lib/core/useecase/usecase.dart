import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Faliure, SuccessType>> call(Params params);
}
