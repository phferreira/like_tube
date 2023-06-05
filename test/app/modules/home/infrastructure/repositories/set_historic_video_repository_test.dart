import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_set_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/failures/set_historic_video_datasource_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/set_historic_video_repository.dart';
import 'package:mocktail/mocktail.dart';

class SetHistoricVideoDatasourceMock extends Mock implements ISetHistoricVideoDatasource {}

void main() {
  final ISetHistoricVideoDatasource datasource = SetHistoricVideoDatasourceMock();
  final ISetHistoricVideoRepository repository = SetHistoricVideoRepository(datasource: datasource);
  final Video video = Video.noProperties();

  test('Deve retornar uma Right(Video)', () async {
    when(() => datasource(video)).thenAnswer((_) async => Right(video));

    final result = await repository(video);

    expect(result, isA<Right<IFailure, Video>>());
    verify(() => datasource(video));
  });

  test('Deve retornar Left(Ifailure) se ocorrer uma exception', () async {
    when(() => datasource(video)).thenThrow((_) async => Exception());

    final result = await repository(video);

    expect(result, isA<Left<IFailure, Video>>());
    verify(() => datasource(video));
  });

  test('Deve retornar Left(Ifailure) se vier ifailure do datasource ', () async {
    when(() => datasource(video)).thenThrow(SetHistoricVideoDatasourceError());

    final result = await repository(video);

    expect(result, isA<Left<IFailure, Video>>());
    verify(() => datasource(video));
  });
}
