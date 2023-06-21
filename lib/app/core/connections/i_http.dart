import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';

abstract class IHttp {
  Future<Either<IFailure, ListVideo>> get(String description);
}
