import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/set_historic_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_set_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_set_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/set_historic_video_usecase.dart';
import 'package:mocktail/mocktail.dart';

class SetHistoricVideoRepositoryMock extends Mock implements ISetHistoricVideoRepository {}

void main() {
  final ISetHistoricVideoRepository repository = SetHistoricVideoRepositoryMock();
  final ISetHistoricVideoUsecase usecase = SetHistoricVideoUsecase(repository: repository);
  Video video = Video.noProperties();

  setUpAll(() {
    video = Video(id: '199', title: 'Titulo 199', url: 'http://teste.com');
  });

  test('Deve retornar Video se adicionou video', () async {
    when(() => repository(video)).thenAnswer((_) async => Right(video));
    final _result = await usecase(video);

    expect(_result, isA<Right<IFailure, Video>>());
    verify(() => repository(video));
  });

  test('Deve retornar um IFailure ', () async {
    when(() => repository(video)).thenAnswer((_) async => Left(SetHistoricVideoRepositoryError()));
    final _result = await usecase(video);

    expect(_result, isA<Left<IFailure, Video>>());
    verify(() => repository(video));
  });
}
