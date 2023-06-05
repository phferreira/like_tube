import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/get_historic_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_historic_video_usecase.dart';
import 'package:mocktail/mocktail.dart';

class GetHistoricVideoRepositoryMock extends Mock implements IGetHistoricVideoRepository {}

void main() {
  final IGetHistoricVideoRepository repository = GetHistoricVideoRepositoryMock();
  final IGetHistoricVideoUsecase usecase = GetHistoricVideoUsecase(repository: repository);

  test('Deve retornar uma lista de Video', () async {
    when(() => repository()).thenAnswer((_) async => const Right(<Video>[]));
    final result = await usecase();

    expect(result, isA<Right<IFailure, List<Video>>>());
    verify(() => repository());
  });

  test('Deve retornar um IFailure', () async {
    when(() => repository()).thenAnswer((_) async => Left(GetHistoricVideoRepositoryError()));
    final result = await usecase();

    expect(result, isA<Left<IFailure, List<Video>>>());
    verify(() => repository());
  });
}
