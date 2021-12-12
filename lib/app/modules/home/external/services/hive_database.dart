import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase extends IDataBase {
  Future start() async {
    Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
  }

  Future close() async {
    Hive.close();
  }

  @override
  Future<Either<IFailure, List>> delete(String table, WhereType where) async {
    try {
      Box box = await Hive.openBox(table);

      List<dynamic> _removed = [];

      (await select(table, [], where)).fold((l) => throw l, (r) => _removed.addAll(r));

      for (dynamic _element in _removed) {
        Map<String, dynamic> _delete = jsonDecode(_element.toString());
        String _deleteKey = _delete.values.first.toString();
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
      Box box = await Hive.openBox(table);

      WhereType _where = {};
      for (var _key in columns.keys) {
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
    List<dynamic> _finalList = [];
    try {
      Box box = await Hive.openBox(table);

      List<dynamic> _listBox = [];
      _listBox = box.values.toList();

      where.forEach((_keyWhere, _valueWhere) {
        _listBox.removeWhere((_element) {
          Map<String, dynamic> _result = jsonDecode(_element.toString());
          return (_result.containsKey(_keyWhere)) && !(_valueWhere.contains(_result[_keyWhere].toString()));
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
    try {
      Box box = await Hive.openBox(table);
      _finalList = (await select(table, [], where)).fold((l) => [], (r) => r);

      where.forEach((_keyWhere, _valueWhere) {
        _finalList.removeWhere((_element) {
          Map<String, dynamic> _result = jsonDecode(_element.toString());
          return (_result.containsKey(_keyWhere)) && !(_valueWhere.contains(_result[_keyWhere].toString()));
        });
      });

      for (var _element in _finalList) {
        Map<String, dynamic> _result = jsonDecode(_element.toString());

        columns.forEach((_keyUpdate, _valueUpdate) {
          _result[_keyUpdate] = _valueUpdate;
        });

        box.put(_result.values.first, jsonEncode(_result));
        _element = _result;
      }
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }

    return Right(_finalList);
  }
}
