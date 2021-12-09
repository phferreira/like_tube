import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_http.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/services/errors/http_failure.dart';
import 'package:mocktail/mocktail.dart';

class ConnectionMock extends Mock implements IHttp {}

void main() {
  IHttp connection = ConnectionMock();

  test('Deve retornar um Right(List<Video>)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => const Right([]));
    final response = await connection.get('');
    expect(response, isA<Right<IFailure, List<Video>>>());
    verify(() => connection.get(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => Left(ApiConnectionError()));
    final response = await connection.get('');
    expect(response, isA<Left<IFailure, List<Video>>>());
    verify(() => connection.get(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => Left(NotFoundError()));
    final response = await connection.get('');
    expect(response, isA<Left<IFailure, List<Video>>>());
    verify(() => connection.get(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => Left(TimeOutError()));
    final response = await connection.get('');
    expect(response, isA<Left<IFailure, List<Video>>>());
    verify(() => connection.get(any()));
  });
}
