import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/get_all_favorite_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_all_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_all_favorite_video_datasource.dart';

class GetAllFavoriteVideoRepository extends IGetAllFavoriteVideoRepository {
  final IGetAllFavoriteVideoDatasource datasource;

  GetAllFavoriteVideoRepository({required this.datasource});

  @override
  Future<Either<IFailure, List<Video>>> call() async {
    try {
      final _result = await datasource();
      return _result;
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GetAllFavoriteVideoRepositoryError());
    }
  }
}
