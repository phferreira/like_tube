import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_http.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/failures/http_failure.dart';
import 'package:mocktail/mocktail.dart';

class ConnectionMock extends Mock implements IHttp {}

void main() {
  final IHttp connection = ConnectionMock();

  test('Deve retornar um Right(ListVideo)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => const Right([]));
    final response = await connection.get('');
    expect(response, isA<Right<IFailure, ListVideo>>());
    verify(() => connection.get(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => Left(ApiConnectionError()));
    final response = await connection.get('');
    expect(response, isA<Left<IFailure, ListVideo>>());
    verify(() => connection.get(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => Left(NotFoundError()));
    final response = await connection.get('');
    expect(response, isA<Left<IFailure, ListVideo>>());
    verify(() => connection.get(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection.get(any())).thenAnswer((_) async => Left(TimeOutError()));
    final response = await connection.get('');
    expect(response, isA<Left<IFailure, ListVideo>>());
    verify(() => connection.get(any()));
  });
}
