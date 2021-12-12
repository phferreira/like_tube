import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/get_all_favorite_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_all_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_all_favorite_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_all_favorite_video_usecase.dart';
import 'package:mocktail/mocktail.dart';

class GetAllFavoriteVideoRepositoryMock extends Mock implements IGetAllFavoriteVideoRepository {}

void main() {
  final IGetAllFavoriteVideoRepository repository = GetAllFavoriteVideoRepositoryMock();
  final IGetAllFavoriteVideoUsecase usecase = GetAllFavoriteVideoUsecase(repository: repository);

  test('Deve retornar uma lista de Video', () async {
    when(() => repository()).thenAnswer((_) async => const Right(<Video>[]));
    final _result = await usecase();

    expect(_result, isA<Right<IFailure, List<Video>>>());
    verify(() => repository());
  });

  test('Deve retornar um IFailure', () async {
    when(() => repository()).thenAnswer((_) async => Left(GetAllFavoriteVideoRepositoryError()));
    final _result = await usecase();

    expect(_result, isA<Left<IFailure, List<Video>>>());
    verify(() => repository());
  });
}
