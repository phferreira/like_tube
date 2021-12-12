import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/external/datasources/set_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_historic_video_datasource.dart';
import 'package:mocktail/mocktail.dart';

import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';

class DataBaseMock extends Mock implements IDataBase {}

void main() {
  final IDataBase database = DataBaseMock();
  final ISetHistoricVideoDatasource datasource = SetHistoricVideoDatasource(database: database);
  List<dynamic> _listResult = [];
  Video video = Video(id: '987', title: 'Titulo 987', url: 'http://teste.com');

  setUpAll(() {
    _listResult.add(video.toJson());
  });

  test('Deve retornar uma List<Video>', () async {
    when(() => database.insert(any(), any())).thenAnswer((_) async => Right(_listResult));
    final _result = await datasource(video);

    expect(_result, isA<Right<IFailure, Video>>());
    verify(() => database.insert(any(), any()));
  });

  test('Deve retornar um Left(IFailure) quando vier DatabaseError da consulta', () async {
    when(() => database.insert(any(), any())).thenAnswer((_) async => Left(DataBaseError()));
    final _result = await datasource(video);

    expect(_result, isA<Left<IFailure, Video>>());
    verify(() => database.insert(any(), any()));
  });
}
