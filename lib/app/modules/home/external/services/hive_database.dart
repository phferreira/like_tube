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

      final List<dynamic> removed = [];

      (await select(table, [], where)).fold((l) => throw l, (r) => removed.addAll(r));

      for (final dynamic element in removed) {
        final Map<String, dynamic> delete = jsonDecode(element.toString());
        final String deleteKey = delete.values.first.toString();
        box.delete(deleteKey);
      }

      return Right(removed);
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

      final WhereType where = {};
      for (final key in columns.keys) {
        // final List<String> _element = (jsonDecode(columns[_key].toString()));
        where.addAll({
          key: [columns[key].toString()]
        });
      }

      await box.put(columns.values.first, jsonEncode(columns));
      final result = (await select(table, [], where)).fold((l) => [], (r) => r);
      return Right(result);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List>> select(String table, ColumnsSelectType columns, WhereType where) async {
    final List<dynamic> finalList = [];
    try {
      final Box box = await openBox(table);

      List<dynamic> listBox = [];
      listBox = box.values.toList();

      where.forEach((keyWhere, valueWhere) {
        listBox.removeWhere((element) {
          final Map<String, dynamic> result = jsonDecode(element.toString());
          return (result.containsKey(keyWhere)) && !valueWhere.contains(result[keyWhere].toString());
        });
      });
      finalList.addAll(listBox);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }

    return Right(finalList);
  }

  @override
  Future<Either<IFailure, List>> update(String table, ColumnType columns, WhereType where) async {
    List<dynamic> finalList = [];
    final List<dynamic> resultList = [];
    try {
      final Box box = await openBox(table);
      finalList = (await select(table, [], where)).fold((l) => [], (r) => r);

      where.forEach((keyWhere, valueWhere) {
        finalList.removeWhere((element) {
          final Map<String, dynamic> result = jsonDecode(element.toString());
          return (result.containsKey(keyWhere)) && !valueWhere.contains(result[keyWhere].toString());
        });
      });

      if (finalList.isNotEmpty) {
        for (final element in finalList) {
          final Map<String, dynamic> result = jsonDecode(element.toString());

          columns.forEach((keyUpdate, valueUpdate) {
            result[keyUpdate] = valueUpdate;
          });

          box.put(result.values.first, jsonEncode(result));
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
