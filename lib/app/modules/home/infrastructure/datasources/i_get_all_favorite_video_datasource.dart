import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';

abstract class IGetAllFavoriteVideoDatasource {
  Future<Either<IFailure, List<Video>>> call();
}
