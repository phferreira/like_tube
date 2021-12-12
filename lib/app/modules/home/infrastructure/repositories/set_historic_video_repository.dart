import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/set_historic_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_set_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_historic_video_datasource.dart';

class SetHistoricVideoRepository extends ISetHistoricVideoRepository {
  final ISetHistoricVideoDatasource datasource;

  SetHistoricVideoRepository({required this.datasource});

  @override
  Future<Either<IFailure, Video>> call(Video videoParam) async {
    try {
      final _result = await datasource(videoParam);
      return _result;
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(SetHistoricVideoRepositoryError());
    }
  }
}
