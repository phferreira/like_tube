import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/enum/database_result_enum.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/datasources/set_favorite_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:mocktail/mocktail.dart';

class DatabaseMock extends Mock implements IDataBase {}

void main() {
  final database = DatabaseMock();
  final datasource = SetFavoriteVideoDatasource(database: database);
  final video = Video(id: '789', title: 'Titulo 798', url: 'http://teste.com');
  final List<JsonType> list = [];

  setUp(() {
    video.favorite = false;
    list.add(Video(id: '789', title: 'Titulo 789', url: 'http://teste.com', favorite: true).toMap());
  });

  test('Deve retornar !favorite em update', () async {
    when(() => database.update(any(), any(), any())).thenAnswer((_) async => Right(list));
    when(() => database.insert(any(), any())).thenAnswer((_) async => Left(DataBaseInsertError()));
    final result = await datasource(video);
    expect(video.favorite, true);
    expect(result.contains(DatabaseResultEnum.updated), true);
    verify(() => database.update(any(), any(), any()));
  });

  test('Deve retornar !favorite em insert', () async {
    when(() => database.update(any(), any(), any())).thenAnswer((_) async => Left(DataBaseUpdateError()));
    when(() => database.insert(any(), any())).thenAnswer((_) async => Right(list));
    final result = await datasource(video);
    expect(video.favorite, true);
    expect(result.contains(DatabaseResultEnum.inserted), true);
    verify(() => database.update(any(), any(), any()));
  });

  test('Deve retornar notUpdated e notInserted e não atualiza favorite', () async {
    when(() => database.update(any(), any(), any())).thenAnswer((_) async => Left(DataBaseUpdateError()));
    when(() => database.insert(any(), any())).thenAnswer((_) async => Left(DataBaseInsertError()));
    final result = await datasource(video);
    expect(video.favorite, false);
    expect(result.contains(DatabaseResultEnum.notUpdated), true);
    expect(result.contains(DatabaseResultEnum.notInserted), true);
    verify(() => database.update(any(), any(), any()));
  });
}
