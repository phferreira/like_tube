import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/remove_historic_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_remove_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_remove_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/remove_historic_video_usecase.dart';
import 'package:mocktail/mocktail.dart';

class RemoveHistoricVideoRepositoryMock extends Mock implements IRemoveHistoricVideoRepository {}

void main() {
  final IRemoveHistoricVideoRepository repository = RemoveHistoricVideoRepositoryMock();
  final IRemoveHistoricVideoUsecase usecase = RemoveHistoricVideoUsecase(repository: repository);
  Video video = Video.noProperties();

  setUpAll(() {
    video = Video(id: '299', title: 'Titulo 299', url: 'http://teste.com');
  });

  test('Deve retornar Video se removeu video', () async {
    when(() => repository(video)).thenAnswer((_) async => Right(video));
    final result = await usecase(video);

    expect(result, isA<Right<IFailure, Video>>());
    verify(() => repository(video));
  });

  test('Deve retornar um Left(IFailure) ', () async {
    when(() => repository(video)).thenAnswer((_) async => Left(RemoveHistoricVideoRepositoryError()));
    final result = await usecase(video);

    expect(result, isA<Left<IFailure, Video>>());
    verify(() => repository(video));
  });
}
