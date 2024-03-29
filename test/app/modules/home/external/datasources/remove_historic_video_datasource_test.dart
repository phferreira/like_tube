import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/datasources/remove_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_remove_historic_video_datasource.dart';
import 'package:mocktail/mocktail.dart';

class DataBaseMock extends Mock implements IDataBase {}

void main() {
  final IDataBase database = DataBaseMock();
  final IRemoveHistoricVideoDatasource datasource = RemoveHistoricVideoDatasource(database: database);
  final List<JsonType> listResult = [];
  final Video video = Video(
    id: '986',
    title: 'Titulo 986',
    url: 'http://teste.com',
  );

  setUpAll(() {
    listResult.add(video.toMap());
  });

  test('Deve retornar o Video que foi removido', () async {
    when(() => database.update(any(), any(), any())).thenAnswer((_) async => Right(listResult));
    final result = await datasource(video);

    expect(result, isA<Right<IFailure, Video>>());
    verify(() => database.update(any(), any(), any()));
  });

  test('Deve retornar um Left(IFailure) quando vier DatabaseError da consulta', () async {
    when(() => database.update(any(), any(), any())).thenAnswer((_) async => Left(DataBaseError()));
    final result = await datasource(video);

    expect(result, isA<Left<IFailure, Video>>());
    verify(() => database.update(any(), any(), any()));
  });
}
