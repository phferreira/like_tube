import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/get_all_favorite_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_all_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_all_favorite_video_datasource.dart';

class GetAllFavoriteVideoRepository extends IGetAllFavoriteVideoRepository {
  final IGetAllFavoriteVideoDatasource datasource;

  GetAllFavoriteVideoRepository({required this.datasource});

  @override
  Future<Either<IFailure, ListVideo>> call() async {
    try {
      final result = await datasource();
      return result;
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GetAllFavoriteVideoRepositoryError());
    }
  }
}
