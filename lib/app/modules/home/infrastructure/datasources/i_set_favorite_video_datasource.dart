import 'package:like_tube/app/core/enum/database_result_enum.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';

abstract class ISetFavoriteVideoDatasource {
  Future<List<DatabaseResultEnum>> call(Video video);
}
