import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_remove_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/failures/remove_historic_video_datasource_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_remove_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/remove_historic_video_repository.dart';
import 'package:mocktail/mocktail.dart';

class RemoveHistoricVideoDatasourceMock extends Mock implements IRemoveHistoricVideoDatasource {}

void main() {
  final IRemoveHistoricVideoDatasource datasource = RemoveHistoricVideoDatasourceMock();
  final IRemoveHistoricVideoRepository repository = RemoveHistoricVideoRepository(datasource: datasource);
  final Video video = Video.noProperties();

  test('Deve retornar um Right(Video) se removeu', () async {
    when(() => datasource(video)).thenAnswer((_) async => Right(video));

    final _result = await repository(video);

    expect(_result, isA<Right<IFailure, Video>>());
    verify(() => datasource(video));
  });

  test('Deve retornar Left(Ifailure) se ocorrer uma exception', () async {
    when(() => datasource(video)).thenThrow((_) async => Exception());

    final _result = await repository(video);

    expect(_result, isA<Left<IFailure, Video>>());
    verify(() => datasource(video));
  });

  test('Deve retornar Left(Ifailure) se vier ifailure do datasource ', () async {
    when(() => datasource(video)).thenThrow(RemoveHistoricVideoDatasourceError());

    final _result = await repository(video);

    expect(_result, isA<Left<IFailure, Video>>());
    verify(() => datasource(video));
  });
}
