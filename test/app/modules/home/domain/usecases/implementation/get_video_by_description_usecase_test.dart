import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/repositories/i_get_video_repository.dart';
import 'package:like_tube/app/modules/home/external/services/errors/http_failure.dart';
import 'package:mocktail/mocktail.dart';

class GetVideoByDescriptionRepositoryMock extends Mock implements IGetVideoByDescriptionRepository {}

void main() {
  IGetVideoByDescriptionRepository repositoryMock = GetVideoByDescriptionRepositoryMock();

  test('Deve retornar um Right()', () async {
    when(() => repositoryMock(any())).thenAnswer((_) async => const Right([]));
    final result = await repositoryMock('teste');

    expect(result.isRight(), true);
    verify(() => repositoryMock(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => repositoryMock(any())).thenAnswer((_) async => Left(ApiConnectionError()));
    final result = await repositoryMock('teste');

    expect(result.isLeft(), true);
    expect(result, isA<Left<IFailure, List<Video>>>());
    verify(() => repositoryMock(any()));
  });
}
