import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/core/usecase/i_usecase.dart';

abstract class IGetHistoricVideoUsecase extends IUseCase<ListVideo, void> {
  @override
  Future<Either<IFailure, ListVideo>> call([void param]);
}
