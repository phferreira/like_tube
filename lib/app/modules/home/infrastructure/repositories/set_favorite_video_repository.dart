import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/set_favorite_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_set_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_favorite_video_datasource.dart';

class SetFavoriteVideoRepository extends ISetFavoriteVideoRepository {
  final ISetFavoriteVideoDatasource datasource;

  SetFavoriteVideoRepository({required this.datasource});

  @override
  Future<Either<IFailure, bool>> call(Video video) async {
    try {
      await datasource(video);
      return const Right(true);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(SetFavoriteVideoRepositoryError());
    }
  }
}
