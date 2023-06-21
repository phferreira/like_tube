import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_video_by_description_datasource.dart';

class GetVideoByDescriptionRepository extends IGetVideoByDescriptionRepository {
  final IGetVideoByDescriptionDataSource datasource;

  GetVideoByDescriptionRepository({
    required this.datasource,
  });

  @override
  Future<Either<IFailure, ListVideo>> call(String param) {
    return datasource(param);
  }
}
