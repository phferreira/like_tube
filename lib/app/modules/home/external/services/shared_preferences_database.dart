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

  Future<SharedPreferences> initSharedPreferences() async {
    try {
      return await _prefs;
    } catch (e) {
      return SharedPreferences.getInstance();
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> delete(String table, WhereType where) async {
    try {
      final prefs = await initSharedPreferences();

      final List<JsonType> removed = [];

      (await select(table, [], where)).fold((l) => throw l, (r) => removed.addAll(r));

      for (final dynamic element in removed) {
        final String deleteKey = element.values.first.toString();
        prefs.remove(deleteKey);
      }

      return Right(removed);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DataBaseDeleteError());
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> insert(String table, ColumnType columns) async {
    try {
      final prefs = await initSharedPreferences();

      final WhereType where = {};
      for (final key in columns.keys) {
        where.addAll({
          key: [columns[key].toString()]
        });
      }

      await prefs.setString(columns.values.first, jsonEncode(columns));
      final List<JsonType> result = (await select(table, [], where)).fold((l) => [], (r) => r);
      return Right(result);
    } catch (e) {
      return Left(DataBaseInsertError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> select(String table, ColumnsSelectType columns, WhereType where) async {
    final List<JsonType> listBox = [];
    try {
      final prefs = await initSharedPreferences();
      final listBoxAux = prefs.getKeys();

      for (final element in listBoxAux) {
        final String map = prefs.getString(element) ?? '';
        final json = jsonDecode(map) as JsonType;

        where.forEach((keyWhere, valueWhere) {
          if ((json.containsKey(keyWhere)) && (valueWhere.contains(json[keyWhere].toString()))) {
            listBox.add(json);
          }
        });
      }
      return Right(listBox);
    } catch (e) {
      return Left(DataBaseSelectError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List<JsonType>>> update(String table, ColumnType columns, WhereType where) async {
    List<JsonType> finalList = [];
    final List<JsonType> resultList = [];
    try {
      final prefs = await initSharedPreferences();
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

          prefs.setString(columns.values.first, jsonEncode(element));
        }
        resultList.addAll((await select(table, [], where)).fold((l) => [], (r) => r));
        return Right(resultList);
      } else {
        return Left(DataBaseSelectError('Não encontrou dados'));
      }
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DataBaseUpdateError(e.toString()));
    }
  }
}
