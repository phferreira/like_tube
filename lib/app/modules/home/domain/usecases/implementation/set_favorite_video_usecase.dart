import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_set_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_set_favorite_video_usecase.dart';

class SetFavoriteVideoUsecase extends ISetFavoriteVideoUsecase {
  final ISetFavoriteVideoRepository repository;

  SetFavoriteVideoUsecase({required this.repository});

  @override
  Future<Either<IFailure, bool>> call(Video param) {
    return repository(param);
  }
}
