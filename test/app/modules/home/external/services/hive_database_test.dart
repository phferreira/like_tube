import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/hive_database.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const String kTemporaryPath = 'temporaryPath';
const String kApplicationSupportPath = '/home/paulo/Documents/';
const String kDownloadsPath = 'downloadsPath';
const String kLibraryPath = 'libraryPath';
const String kApplicationDocumentsPath = 'applicationDocumentsPath';
const String kExternalCachePath = 'externalCachePath';
const String kExternalStoragePath = 'externalStoragePath';

class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return kTemporaryPath;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return kApplicationSupportPath;
  }

  @override
  Future<String?> getLibraryPath() async {
    return kLibraryPath;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return kApplicationDocumentsPath;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return kExternalStoragePath;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return <String>[kExternalCachePath];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>[kExternalStoragePath];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return kDownloadsPath;
  }
}

void main() async {
  const String table = 'tb_favoritevideos';

  final hiveDatabase = HiveDatabase();

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
    PathProviderPlatform.instance = FakePathProviderPlatform();
    await hiveDatabase.start();
  });

  setUp(() async {
    await hiveDatabase.delete(table, {});

    for (int id = 0; id < 10; id++) {
      await hiveDatabase.insert(table, getColumn(id));
    }
  });

  test('Deve inserir registro', () async {
    final result = await hiveDatabase.insert(table, getColumn(9999));
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    final List<Map<String, dynamic>> resultConfirm = result.fold((l) => [], (r) => r);

    expect(resultConfirm[0]['cd_id'].toString(), '9999');
  });

  test('Deve retornar uma lista somente para os codigos do where e somente para as columns selecionadas cd_id ', () async {
    final ColumnsSelectType columns = [
      'cd_id',
      'bl_favorite',
    ];

    final WhereType where = {
      'cd_id': ['3', '8'],
    };
    final result = await hiveDatabase.select(table, columns, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 2);
  });

  test('Deve retornar uma lista somente para os codigos do where e somente para as columns selecionadas bl_favorite ', () async {
    final WhereType where = {
      'bl_favorite': ['false'],
    };
    final result = await hiveDatabase.select(table, [], where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 5);
  });

  test('Deve retornar uma lista somente para os codigos do where que existem e somente para as columns selecionadas cd_id ', () async {
    final ColumnsSelectType columns = [
      'cd_id',
      'bl_favorite',
    ];

    final WhereType where = {
      'cd_id': ['3', '12'],
    };
    final result = await hiveDatabase.select(table, columns, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 1);
  });

  test('Deve retornar uma lista vazia caso nao encontre registros', () async {
    final ColumnsSelectType columns = [
      'cd_id',
      'bl_favorite',
    ];

    final WhereType where = {
      'cd_id': ['123', '124'],
    };
    final result = await hiveDatabase.select(table, columns, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    final list = result.fold((l) => l, (r) => r);
    expect(list, List.of([]));
  });

  test('Deve remover os registros informados pelo where cd_id', () async {
    final WhereType where = {
      'cd_id': ['2', '6'],
    };
    final result = await hiveDatabase.delete(table, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 2);

    final resultConfirm = await hiveDatabase.select(table, [], where);
    expect(resultConfirm, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(resultConfirm.getRight().getOrElse(() => []).length, 0);
  });

  test('Deve remover os registros informados pelo where bl_favorite', () async {
    final WhereType where = {
      'bl_favorite': ['false'],
    };
    final result = await hiveDatabase.delete(table, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 5);

    final resultConfirm = await hiveDatabase.select(table, [], where);
    expect(resultConfirm, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(resultConfirm.getRight().getOrElse(() => []).length, 0);
  });

  test('Deve remover todos os registros', () async {
    final result = await hiveDatabase.delete(table, {});
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 10);

    final resultConfirm = await hiveDatabase.select(table, [], {});
    expect(resultConfirm, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(resultConfirm.getRight().getOrElse(() => []).length, 0);
  });

  test('Deve Atualizar os registros informados pelo where bl_favorite', () async {
    final WhereType where = {
      'bl_favorite': ['false'],
    };

    final ColumnType columns = {
      'tx_title': 'update',
    };

    final result = await hiveDatabase.update(table, columns, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 5);

    final List<Map<String, dynamic>> resultConfirm = (await hiveDatabase.select(table, [], where)).fold((l) => [], (r) => r);

    expect(resultConfirm.length, 5);
    expect(resultConfirm[0]['tx_title'].toString(), 'update');
  });

  test('Deve Atualizar os registros informados pelo where tx_title = title 1 e title 2', () async {
    final WhereType where = {
      'tx_title': ['titulo 1', 'titulo 2'],
    };

    final ColumnType columns = {
      'bl_favorite': 'true',
    };

    final result = await hiveDatabase.update(table, columns, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 2);

    final List<Map<String, dynamic>> resultConfirm = (await hiveDatabase.select(table, [], where)).fold((l) => [], (r) => r);

    expect(resultConfirm.length, 2);
    expect(resultConfirm[0]['bl_favorite'].toString(), 'true');
    expect(resultConfirm[1]['bl_favorite'].toString(), 'true');
  });

  test('Deve Atualizar os registros informados pelo where bl_favotire = true cd_id = 1,2,3 ', () async {
    final WhereType where = {
      'bl_favorite': ['true'],
      'cd_id': ['1', '2', '3'],
    };

    final ColumnType columns = {
      'tx_title': 'update',
    };

    final result = await hiveDatabase.update(table, columns, where);
    expect(result, isA<Right<IFailure, List<Map<String, dynamic>>>>());
    expect(result.getRight().getOrElse(() => []).length, 1);

    final List<Map<String, dynamic>> resultConfirm = (await hiveDatabase.select(table, [], where)).fold((l) => [], (r) => r);

    expect(resultConfirm.length, 1);
    expect(resultConfirm[0]['tx_title'].toString(), 'update');
  });

  test('Deve Ifailure caso nao tenha sido aberto box', () async {
    hiveDatabase.close();

    final result = await hiveDatabase.select(table, [], {});
    expect(result, isA<Left<IFailure, List<Map<String, dynamic>>>>());
  });
}
