import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/remove_historic_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_remove_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_remove_historic_video_datasource.dart';

class RemoveHistoricVideoRepository extends IRemoveHistoricVideoRepository {
  final IRemoveHistoricVideoDatasource datasource;

  RemoveHistoricVideoRepository({required this.datasource});

  @override
  Future<Either<IFailure, Video>> call(Video videoParam) async {
    try {
      final _result = await datasource(videoParam);
      return _result;
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(RemoveHistoricVideoRepositoryError());
    }
  }
}
