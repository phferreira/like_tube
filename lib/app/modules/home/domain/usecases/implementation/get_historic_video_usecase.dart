import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_historic_video_usecase.dart';

class GetHistoricVideoUsecase extends IGetHistoricVideoUsecase {
  final IGetHistoricVideoRepository repository;

  GetHistoricVideoUsecase({required this.repository});

  @override
  Future<Either<IFailure, List<Video>>> call([void param]) {
    return repository();
  }
}
