import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase extends IDataBase {
  Future start() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
  }

  Future close() async {
    Hive.close();
  }

  Future<Box> openBox(String table) async {
    try {
      return await Hive.openBox(table);
    } catch (e) {
      await start();
      return Hive.openBox(table);
    }
  }

  List<Map<String, dynamic>> result(List<dynamic> value) {
    return jsonDecode(jsonEncode(value));
  }

  @override
  Future<Either<IFailure, List>> delete(String table, WhereType where) async {
    try {
      final Box box = await openBox(table);

      final List<dynamic> _removed = [];

      (await select(table, [], where)).fold((l) => throw l, (r) => _removed.addAll(r));

      for (final dynamic _element in _removed) {
        final Map<String, dynamic> _delete = jsonDecode(_element.toString());
        final String _deleteKey = _delete.values.first.toString();
        box.delete(_deleteKey);
      }

      return Right(_removed);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DataBaseError());
    }
  }

  @override
  Future<Either<IFailure, List>> insert(String table, ColumnType columns) async {
    try {
      final Box box = await openBox(table);

      final WhereType _where = {};
      for (final _key in columns.keys) {
        // final List<String> _element = (jsonDecode(columns[_key].toString()));
        _where.addAll({
          _key: [columns[_key].toString()]
        });
      }

      await box.put(columns.values.first, jsonEncode(columns));
      final _result = (await select(table, [], _where)).fold((l) => [], (r) => r);
      return Right(_result);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List>> select(String table, ColumnsSelectType columns, WhereType where) async {
    final List<dynamic> _finalList = [];
    try {
      final Box box = await openBox(table);

      List<dynamic> _listBox = [];
      _listBox = box.values.toList();

      where.forEach((_keyWhere, _valueWhere) {
        _listBox.removeWhere((_element) {
          final Map<String, dynamic> _result = jsonDecode(_element.toString());
          return (_result.containsKey(_keyWhere)) && !_valueWhere.contains(_result[_keyWhere].toString());
        });
      });
      _finalList.addAll(_listBox);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }

    return Right(_finalList);
  }

  @override
  Future<Either<IFailure, List>> update(String table, ColumnType columns, WhereType where) async {
    List<dynamic> _finalList = [];
    final List<dynamic> _resultList = [];
    try {
      final Box box = await openBox(table);
      _finalList = (await select(table, [], where)).fold((l) => [], (r) => r);

      where.forEach((_keyWhere, _valueWhere) {
        _finalList.removeWhere((_element) {
          final Map<String, dynamic> _result = jsonDecode(_element.toString());
          return (_result.containsKey(_keyWhere)) && !_valueWhere.contains(_result[_keyWhere].toString());
        });
      });

      if (_finalList.isNotEmpty) {
        for (final _element in _finalList) {
          final Map<String, dynamic> _result = jsonDecode(_element.toString());

          columns.forEach((_keyUpdate, _valueUpdate) {
            _result[_keyUpdate] = _valueUpdate;
          });

          box.put(_result.values.first, jsonEncode(_result));
        }
        _resultList.addAll((await select(table, [], where)).fold((l) => [], (r) => r));
        return Right(_resultList);
      } else {
        return Left(DataBaseNotUpdateError());
      }
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }
  }
}
