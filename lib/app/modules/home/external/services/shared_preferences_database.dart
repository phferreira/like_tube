import 'dart:async';
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDatabase extends IDataBase {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<SharedPreferences> initSharedPreferences(String table) async {
    try {
      return await _prefs;
    } catch (e) {
      return SharedPreferences.getInstance();
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> delete(String table, WhereType where) async {
    try {
      final box = await initSharedPreferences(table);

      final List<JsonType> removed = [];

      (await select(table, [], where)).fold((l) => throw l, (r) => removed.addAll(r));

      for (final dynamic element in removed) {
        final String deleteKey = element.values.first.toString();
        box.remove(deleteKey);
      }

      return Right(removed);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DataBaseError());
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> insert(String table, ColumnType columns) async {
    try {
      final box = await initSharedPreferences(table);

      final WhereType where = {};
      for (final key in columns.keys) {
        where.addAll({
          key: [columns[key].toString()]
        });
      }

      await box.setString(columns.values.first, jsonEncode(columns));
      final List<JsonType> result = (await select(table, [], where)).fold((l) => [], (r) => r);
      return Right(result);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> select(String table, ColumnsSelectType columns, WhereType where) async {
    final List<JsonType> listBox = [];
    try {
      final box = await initSharedPreferences(table);
      final listBoxAux = box.getKeys();

      for (final element in listBoxAux) {
        final String map = box.getString(element) ?? '';
        final json = jsonDecode(map) as JsonType;

        where.forEach((keyWhere, valueWhere) {
          if ((json.containsKey(keyWhere)) && (valueWhere.contains(json[keyWhere].toString()))) {
            listBox.add(json);
          }
        });
      }
      return Right(listBox);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> update(String table, ColumnType columns, WhereType where) async {
    List<JsonType> finalList = [];
    final List<JsonType> resultList = [];
    try {
      final box = await initSharedPreferences(table);
      finalList = (await select(table, [], where)).fold((l) => [], (r) => r);

      where.forEach((keyWhere, valueWhere) {
        finalList.removeWhere((element) {
          return (element.containsKey(keyWhere)) && !valueWhere.contains(element[keyWhere].toString());
        });
      });

      if (finalList.isNotEmpty) {
        for (final element in finalList) {
          columns.forEach((keyUpdate, valueUpdate) {
            element[keyUpdate] = valueUpdate;
          });

          box.setString(columns.values.first, jsonEncode(element));
        }
        resultList.addAll((await select(table, [], where)).fold((l) => [], (r) => r));
        return Right(resultList);
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
