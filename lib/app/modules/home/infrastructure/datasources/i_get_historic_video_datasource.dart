import 'package:like_tube/app/modules/home/domain/entities/video.dart';

abstract class IGetHistoricVideoDatasource {
  // Future<Either<IFailure, List<Video>>> call();
  Future<List<Video>> call();
}
