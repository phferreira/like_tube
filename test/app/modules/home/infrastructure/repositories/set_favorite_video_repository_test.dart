import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/failures/set_favorite_video_datasource_failure.dart';
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

  test('Deve retornar um Right(true) e favorite == true quando video.favrite == true', () async {
    when(() => datasource(any())).thenAnswer((_) async => true);
    video.favorite = false;
    final result = await repository(video);
    expect(result.isRight(), true);
    expect(result.getRight().getOrElse(() => false), true);
    expect(video.favorite, true);
    verify(() => datasource(any()));
  });

  test('Deve retornar um Right(false) e favorite == false quando video.favorite == true', () async {
    when(() => datasource(any())).thenAnswer((_) async => false);
    video.favorite = true;
    final result = await repository(video);
    expect(result.isRight(), true);
    expect(result.getRight().getOrElse(() => true), false);
    expect(video.favorite, false);
    verify(() => datasource(any()));
  });

  test('Deve retornar um Left(SetFavoriteVideoDatasourceError) passando com favorite == true e não atualiza o favorite ', () async {
    when(() => datasource(any())).thenThrow((_) async => SetFavoriteVideoDatasourceError());
    video.favorite = true;
    final result = await repository(video);
    expect(result.isLeft(), true);
    expect(result, isA<Left<IFailure, bool>>());
    expect(result.fold(id, id), isA<IFailure>());
    expect(video.favorite, true);
    verify(() => datasource(any()));
  });

  test('Deve retornar um Left(SetFavoriteVideoDatasourceError) passando com favorite == false e não atualiza o favorite ', () async {
    when(() => datasource(any())).thenThrow((_) async => SetFavoriteVideoDatasourceError());
    video.favorite = false;
    final result = await repository(video);
    expect(result.isLeft(), true);
    expect(result, isA<Left<IFailure, bool>>());
    expect(result.fold(id, id), isA<IFailure>());
    expect(video.favorite, false);
    verify(() => datasource(any()));
  });
}
