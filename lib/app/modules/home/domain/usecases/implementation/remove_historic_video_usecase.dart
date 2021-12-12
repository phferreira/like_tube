import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_remove_historic_video_repository.dart';
import '../i_remove_historic_video_usecase.dart';

class RemoveHistoricVideoUsecase extends IRemoveHistoricVideoUsecase {
  final IRemoveHistoricVideoRepository repository;

  RemoveHistoricVideoUsecase({required this.repository});

  @override
  Future<Either<IFailure, Video>> call(Video param) {
    return repository(param);
  }
}
