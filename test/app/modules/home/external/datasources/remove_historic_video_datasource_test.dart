import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/datasources/remove_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_remove_historic_video_datasource.dart';
import 'package:mocktail/mocktail.dart';

class DataBaseMock extends Mock implements IDataBase {}

void main() {
  final IDataBase database = DataBaseMock();
  final IRemoveHistoricVideoDatasource datasource = RemoveHistoricVideoDatasource(database: database);
  final List<dynamic> _listResult = [];
  final Video video = Video(id: '986', title: 'Titulo 986', url: 'http://teste.com');

  setUpAll(() {
    _listResult.add(video.toJson());
  });

  test('Deve retornar o Video que foi removido', () async {
    when(() => database.delete(any(), any())).thenAnswer((_) async => Right(_listResult));
    final _result = await datasource(video);

    expect(_result, isA<Right<IFailure, Video>>());
    verify(() => database.delete(any(), any()));
  });

  test('Deve retornar um Left(IFailure) quando vier DatabaseError da consulta', () async {
    when(() => database.delete(any(), any())).thenAnswer((_) async => Left(DataBaseError()));
    final _result = await datasource(video);

    expect(_result, isA<Left<IFailure, Video>>());
    verify(() => database.delete(any(), any()));
  });
}
