import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/hive_database.dart';

void main() {
  final hiveDatabase = HiveDatabase();
  const String _table = 'tb_favoritevideos';

  ColumnType getColumn(int id) {
    return {
      'cd_id': '$id',
      'tx_title': 'titulo $id',
      'tx_url': 'http://teste.com/$id',
      'bl_favorite': id.isOdd ? 'false' : 'true',
    };
  }

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await hiveDatabase.start();
  });

  setUp(() async {
    await hiveDatabase.delete(_table, {});

    for (int id = 0; id < 10; id++) {
      await hiveDatabase.insert(_table, getColumn(id));
    }
  });

  test('Deve inserir registro', () async {
    final _result = await hiveDatabase.insert(_table, getColumn(9999));
    expect(_result, isA<Right<IFailure, List>>());
    final List<dynamic> _resultConfirm = _result.fold((l) => [], (r) => r);
    expect(jsonDecode(_resultConfirm[0])['cd_id'].toString(), '9999');
  });

  test('Deve retornar uma lista somente para os codigos do where e somente para as columns selecionadas cd_id ', () async {
    final ColumnsSelectType _columns = [
      'cd_id',
      'bl_favorite',
    ];

    final WhereType _where = {
      'cd_id': ['3', '8'],
    };
    final result = await hiveDatabase.select(_table, _columns, _where);
    expect(result, isA<Right<IFailure, List>>());
    expect(result.getRight().getOrElse(() => []).length, 2);
  });

  test('Deve retornar uma lista somente para os codigos do where e somente para as columns selecionadas bl_favorite ', () async {
    final WhereType _where = {
      'bl_favorite': ['false'],
    };
    final result = await hiveDatabase.select(_table, [], _where);
    expect(result, isA<Right<IFailure, List>>());
    expect(result.getRight().getOrElse(() => []).length, 5);
  });

  test('Deve retornar uma lista somente para os codigos do where que existem e somente para as columns selecionadas cd_id ', () async {
    final ColumnsSelectType _columns = [
      'cd_id',
      'bl_favorite',
    ];

    final WhereType _where = {
      'cd_id': ['3', '12'],
    };
    final result = await hiveDatabase.select(_table, _columns, _where);
    expect(result, isA<Right<IFailure, List>>());
    expect(result.getRight().getOrElse(() => []).length, 1);
  });

  test('Deve retornar uma lista vazia caso nao encontre registros', () async {
    final ColumnsSelectType _columns = [
      'cd_id',
      'bl_favorite',
    ];

    final WhereType _where = {
      'cd_id': ['123', '124'],
    };
    final _result = await hiveDatabase.select(_table, _columns, _where);
    expect(_result, isA<Right<IFailure, List>>());
    final _list = _result.fold((l) => l, (r) => r);
    expect(_list, []);
  });

  test('Deve remover os registros informados pelo where cd_id', () async {
    final WhereType _where = {
      'cd_id': ['2', '6'],
    };
    final _result = await hiveDatabase.delete(_table, _where);
    expect(_result, isA<Right<IFailure, List>>());
    expect(_result.getRight().getOrElse(() => []).length, 2);

    final _resultConfirm = await hiveDatabase.select(_table, [], _where);
    expect(_resultConfirm, isA<Right<IFailure, List>>());
    expect(_resultConfirm.getRight().getOrElse(() => []).length, 0);
  });

  test('Deve remover os registros informados pelo where bl_favorite', () async {
    final WhereType _where = {
      'bl_favorite': ['false'],
    };
    final _result = await hiveDatabase.delete(_table, _where);
    expect(_result, isA<Right<IFailure, List>>());
    expect(_result.getRight().getOrElse(() => []).length, 5);

    final _resultConfirm = await hiveDatabase.select(_table, [], _where);
    expect(_resultConfirm, isA<Right<IFailure, List>>());
    expect(_resultConfirm.getRight().getOrElse(() => []).length, 0);
  });

  test('Deve remover todos os registros', () async {
    final _result = await hiveDatabase.delete(_table, {});
    expect(_result, isA<Right<IFailure, List>>());
    expect(_result.getRight().getOrElse(() => []).length, 10);

    final _resultConfirm = await hiveDatabase.select(_table, [], {});
    expect(_resultConfirm, isA<Right<IFailure, List>>());
    expect(_resultConfirm.getRight().getOrElse(() => []).length, 0);
  });

  test('Deve Atualizar os registros informados pelo where bl_favorite', () async {
    final WhereType _where = {
      'bl_favorite': ['false'],
    };

    final ColumnType _columns = {
      'tx_title': 'update',
    };

    final _result = await hiveDatabase.update(_table, _columns, _where);
    expect(_result, isA<Right<IFailure, List>>());
    expect(_result.getRight().getOrElse(() => []).length, 5);

    final List<dynamic> _resultConfirm = (await hiveDatabase.select(_table, [], _where)).fold((l) => [], (r) => r);

    expect(_resultConfirm.length, 5);
    expect(jsonDecode(_resultConfirm[0])['tx_title'].toString(), 'update');
  });

  test('Deve Atualizar os registros informados pelo where tx_title = title 1 e title 2', () async {
    final WhereType _where = {
      'tx_title': ['titulo 1', 'titulo 2'],
    };

    final ColumnType _columns = {
      'bl_favorite': 'true',
    };

    final _result = await hiveDatabase.update(_table, _columns, _where);
    expect(_result, isA<Right<IFailure, List>>());
    expect(_result.getRight().getOrElse(() => []).length, 2);

    final List<dynamic> _resultConfirm = (await hiveDatabase.select(_table, [], _where)).fold((l) => [], (r) => r);

    expect(_resultConfirm.length, 2);
    expect(jsonDecode(_resultConfirm[0])['bl_favorite'].toString(), 'true');
    expect(jsonDecode(_resultConfirm[1])['bl_favorite'].toString(), 'true');
  });

  test('Deve Atualizar os registros informados pelo where bl_favotire = true cd_id = 1,2,3 ', () async {
    final WhereType _where = {
      'bl_favorite': ['true'],
      'cd_id': ['1', '2', '3'],
    };

    final ColumnType _columns = {
      'tx_title': 'update',
    };

    final _result = await hiveDatabase.update(_table, _columns, _where);
    expect(_result, isA<Right<IFailure, List>>());
    expect(_result.getRight().getOrElse(() => []).length, 1);

    final List<dynamic> _resultConfirm = (await hiveDatabase.select(_table, [], _where)).fold((l) => [], (r) => r);

    expect(_resultConfirm.length, 1);
    expect(jsonDecode(_resultConfirm[0])['tx_title'].toString(), 'update');
  });

  test('Deve Ifailure caso nao tenha sido aberto box', () async {
    hiveDatabase.close();

    final _result = await hiveDatabase.select(_table, [], {});
    expect(_result, isA<Left<IFailure, List>>());
  });
}
