import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/failures/set_favorite_video_repository_failure.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_set_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/set_favorite_video_usecase.dart';
import 'package:mocktail/mocktail.dart';

class SetFavoriteVideoRepositoryMock extends Mock implements ISetFavoriteVideoRepository {}

void main() {
  final video = Video.noProperties();
  final repository = SetFavoriteVideoRepositoryMock();
  final usecase = SetFavoriteVideoUsecase(repository: repository);

  test('Deve retornar um Right(true) quando passar com favorite false', () async {
    when(() => repository(video)).thenAnswer((_) async => const Right(true));
    final result = await usecase(video);
    expect(result.getRight().getOrElse(() => false), true);
    verify(() => repository(video));
  });

  test('Deve retornar um Right(false) quando passar com favorite false', () async {
    when(() => repository(video)).thenAnswer((_) async => const Right(false));
    final result = await usecase(video);
    expect(result.isRight(), true);
    expect(result.getRight().getOrElse(() => true), false);
    verify(() => repository(video));
  });

  test('Deve retornar um left(ifailure)', () async {
    when(() => repository(video)).thenAnswer((_) async => Left(SetFavoriteVideoRepositoryError()));
    final result = await usecase(video);
    expect(result.isLeft(), true);
    expect(result, isA<Left<IFailure, bool>>());
    verify(() => repository(video));
  });
}
