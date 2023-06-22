import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/datasources/get_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_historic_video_datasource.dart';
import 'package:mocktail/mocktail.dart';

class DataBaseMock extends Mock implements IDataBase {}

void main() {
  final IDataBase database = DataBaseMock();
  final IGetHistoricVideoDatasource datasource = GetHistoricVideoDatasource(database: database);
  final List<JsonType> listResult = [];

  setUpAll(() {
    final Video video = Video(id: '100', title: 'Titulo 01', url: 'http://teste.com');
    listResult.add(video.toMap());
  });

  test('Deve retornar uma ListVideo', () async {
    when(() => database.select(any(), any(), any())).thenAnswer((_) async => Right(listResult));
    final result = await datasource();

    expect(result, isA<Right<IFailure, ListVideo>>());
    verify(() => database.select(any(), any(), any()));
  });

  test('Deve retornar uma quando database', () async {
    when(() => database.select(any(), any(), any())).thenThrow(DataBaseError());
    final result = await datasource();

    expect(result, isA<Left<IFailure, ListVideo>>());
    verify(() => database.select(any(), any(), any()));
  });
}
