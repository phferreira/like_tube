import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/usecase/i_usecase.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';

abstract class ISetFavoriteVideoUsecase extends IUseCase<bool, Video> {
  @override
  Future<Either<IFailure, bool>> call(Video param);
}
