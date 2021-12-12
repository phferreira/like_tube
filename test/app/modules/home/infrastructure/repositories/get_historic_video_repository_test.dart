import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/failures/get_historic_video_datasource_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/get_historic_video_repository.dart';
import 'package:mocktail/mocktail.dart';

class GetHistoricVideoDatasourceMock extends Mock implements IGetHistoricVideoDatasource {}

void main() {
  final IGetHistoricVideoDatasource datasource = GetHistoricVideoDatasourceMock();
  final IGetHistoricVideoRepository repository = GetHistoricVideoRepository(datasource: datasource);

  test('Deve retornar uma Right(List<Video>)', () async {
    when(() => datasource()).thenAnswer((_) async => const <Video>[]);

    final _result = await repository();

    expect(_result, isA<Right<IFailure, List<Video>>>());
    verify(() => datasource());
  });

  test('Deve retornar Left(Ifailure) se ocorrer uma exception', () async {
    when(() => datasource()).thenThrow((_) async => Exception());

    final _result = await repository();

    expect(_result, isA<Left<IFailure, List<Video>>>());
    verify(() => datasource());
  });

  test('Deve retornar Left(Ifailure) se vier ifailure do datasource ', () async {
    when(() => datasource()).thenThrow(GetHistoricVideoDatasourceError());

    final _result = await repository();

    expect(_result, isA<Left<IFailure, List<Video>>>());
    verify(() => datasource());
  });
}
