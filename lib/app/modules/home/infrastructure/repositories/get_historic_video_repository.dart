import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/get_historic_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_historic_video_datasource.dart';

class GetHistoricVideoRepository extends IGetHistoricVideoRepository {
  final IGetHistoricVideoDatasource datasource;

  GetHistoricVideoRepository({required this.datasource});

  @override
  Future<Either<IFailure, List<Video>>> call() async {
    try {
      final _result = await datasource();
      return Right(_result);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GetHistoricVideoRepositoryError());
    }
  }
}
