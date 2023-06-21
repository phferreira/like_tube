import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/datasources/set_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_historic_video_datasource.dart';
import 'package:mocktail/mocktail.dart';

class DataBaseMock extends Mock implements IDataBase {}

void main() {
  final IDataBase database = DataBaseMock();
  final ISetHistoricVideoDatasource datasource = SetHistoricVideoDatasource(database: database);
  final List<Map<String, dynamic>> listResult = [];
  final Video video = Video(id: '987', title: 'Titulo 987', url: 'http://teste.com');

  setUpAll(() {
    listResult.add(video.toMap());
  });

  test('Deve retornar uma ListVideo', () async {
    when(() => database.insert(any(), any())).thenAnswer((_) async => Right(listResult));
    final result = await datasource(video);

    expect(result, isA<Right<IFailure, Video>>());
    verify(() => database.insert(any(), any()));
  });

  test('Deve retornar um Left(IFailure) quando vier DatabaseError da consulta', () async {
    when(() => database.insert(any(), any())).thenAnswer((_) async => Left(DataBaseError()));
    final result = await datasource(video);

    expect(result, isA<Left<IFailure, Video>>());
    verify(() => database.insert(any(), any()));
  });
}
