import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_all_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_all_favorite_video_usecase.dart';

class GetAllFavoriteVideoUsecase extends IGetAllFavoriteVideoUsecase {
  final IGetAllFavoriteVideoRepository repository;

  GetAllFavoriteVideoUsecase({required this.repository});

  @override
  Future<Either<IFailure, ListVideo>> call([void param]) {
    return repository();
  }
}
