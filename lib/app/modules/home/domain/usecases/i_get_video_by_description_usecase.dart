import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/usecase/i_usecase.dart';
import 'package:like_tube/app/modules/home/domain/entities/video_model.dart';

abstract class IGetVideoByDescriptionUsecase extends IUseCase<List<VideoModel>, String> {
  @override
  Future<Either<IFailure, List<VideoModel>>> call(String param);
}
