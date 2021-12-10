import 'package:like_tube/app/modules/home/domain/entities/video.dart';

abstract class ISetFavoriteVideoDatasource {
  Future<bool> call(Video video);
}
