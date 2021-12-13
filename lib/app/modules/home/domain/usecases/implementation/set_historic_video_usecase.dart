import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_set_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_set_historic_video_usecase.dart';

class SetHistoricVideoUsecase extends ISetHistoricVideoUsecase {
  final ISetHistoricVideoRepository repository;

  SetHistoricVideoUsecase({required this.repository});

  @override
  Future<Either<IFailure, Video>> call(Video param) {
    return repository(param);
  }
}
