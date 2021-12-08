import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_connection_usecase.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video_model.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_video_by_description_datasource.dart';

class GetVideoByDescriptionDataSource extends IGetVideoByDescriptionDataSource {
  final IConnection connection;

  GetVideoByDescriptionDataSource({
    required this.connection,
  });

  @override
  Future<Either<IFailure, List<VideoModel>>> call(String param) async {
    return await connection(param);
  }
}
