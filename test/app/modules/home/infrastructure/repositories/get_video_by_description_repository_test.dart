import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/failures/http_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_video_by_description_datasource.dart';
import 'package:mocktail/mocktail.dart';

class GetVideoByDescriptionDataSourceMock extends Mock implements IGetVideoByDescriptionDataSource {}

void main() {
  final IGetVideoByDescriptionDataSource datasourceMock = GetVideoByDescriptionDataSourceMock();

  test('Deve retornar um Right(ListVideo)', () async {
    when(() => datasourceMock(any())).thenAnswer((_) async => const Right([]));
    final result = await datasourceMock('');
    expect(result.isRight(), true);
    expect(result, isA<Right<IFailure, ListVideo>>());
    verify(() => datasourceMock(any()));
  });

  test('Deve retornar um Left(ApiConnectionError())', () async {
    when(() => datasourceMock(any())).thenAnswer((_) async => Left(ApiConnectionError()));
    final result = await datasourceMock('');
    expect(result, isA<Left<IFailure, ListVideo>>());
    verify(() => datasourceMock(any()));
  });

  test('Deve retornar um Left(TimeOutError())', () async {
    when(() => datasourceMock(any())).thenAnswer((_) async => Left(TimeOutError()));
    final result = await datasourceMock('');
    expect(result, isA<Left<IFailure, ListVideo>>());
    verify(() => datasourceMock(any()));
  });

  test('Deve retornar um Left(NotFoundError())', () async {
    when(() => datasourceMock(any())).thenAnswer((_) async => Left(NotFoundError()));
    final result = await datasourceMock('');
    expect(result, isA<Left<IFailure, ListVideo>>());
    verify(() => datasourceMock(any()));
  });
}
