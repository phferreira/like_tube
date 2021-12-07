import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';

abstract class IUseCase<Output, Input> {
  Future<Either<IFailure, Output>> call(Input param);
}
