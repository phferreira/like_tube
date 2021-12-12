import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/services/errors/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_favorite_video_datasource.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/set_favorite_video_repository.dart';
import 'package:mocktail/mocktail.dart';

class SetFavoriteVideoDatasourceMock extends Mock implements ISetFavoriteVideoDatasource {}

class VideoFake extends Fake implements Video {}

void main() {
  setUpAll(() {
    registerFallbackValue(VideoFake());
  });

  final datasource = SetFavoriteVideoDatasourceMock();
  final repository = SetFavoriteVideoRepository(datasource: datasource);
  final video = Video.noProperties();

  test('Deve retornar Right(True) ', () async {
    when(() => datasource(any())).thenAnswer((_) async => []);
    final result = await repository(video);
    expect(result.isRight(), true);
    verify(() => datasource(any()));
  });

  test('Deve retornar um Left(SetFavoriteVideoDatasourceError) ', () async {
    when(() => datasource(any())).thenThrow(DataBaseError());
    final result = await repository(video);
    expect(result.isLeft(), true);
    expect(result, isA<Left<IFailure, bool>>());
    expect(result.fold(id, id), isA<IFailure>());
    verify(() => datasource(any()));
  });
}
