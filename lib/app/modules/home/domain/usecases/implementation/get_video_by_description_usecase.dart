import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_video_by_description_usecase.dart';

class GetVideoByDescriptionUsecase extends IGetVideoByDescriptionUsecase {
  final IGetVideoByDescriptionRepository repository;

  GetVideoByDescriptionUsecase({
    required this.repository,
  });

  @override
  Future<Either<IFailure, ListVideo>> call(String param) async {
    return repository(param);
  }
}
