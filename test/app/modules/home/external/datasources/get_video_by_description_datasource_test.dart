import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_connection_usecase.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video_model.dart';
import 'package:like_tube/app/modules/home/external/connections/errors/failure.dart';
import 'package:mocktail/mocktail.dart';

class ConnectionMock extends Mock implements IConnection {}

void main() {
  IConnection connection = ConnectionMock();

  test('Deve retornar um Right(List<VideoModel>)', () async {
    when(() => connection(any())).thenAnswer((_) async => const Right([]));
    final response = await connection('');
    expect(response, isA<Right<IFailure, List<VideoModel>>>());
    verify(() => connection(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection(any())).thenAnswer((_) async => Left(ApiConnectionError()));
    final response = await connection('');
    expect(response, isA<Left<IFailure, List<VideoModel>>>());
    verify(() => connection(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection(any())).thenAnswer((_) async => Left(NotFoundError()));
    final response = await connection('');
    expect(response, isA<Left<IFailure, List<VideoModel>>>());
    verify(() => connection(any()));
  });

  test('Deve retornar um Left(IFailure)', () async {
    when(() => connection(any())).thenAnswer((_) async => Left(TimeOutError()));
    final response = await connection('');
    expect(response, isA<Left<IFailure, List<VideoModel>>>());
    verify(() => connection(any()));
  });
}
