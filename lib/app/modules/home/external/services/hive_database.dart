import 'dart:async';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase extends IDataBase {
  Future<void> start() async {
    final Directory dir = await getApplicationSupportDirectory();
    Hive.initFlutter(dir.path);
  }

  Future<void> close() async {
    Hive.close();
  }

  Future<Box<Map<String, dynamic>>> openBox(String table) async {
    try {
      return await Hive.openBox(table);
    } catch (e) {
      await start();
      return Hive.openBox(table);
    }
  }

  @override
  Future<Either<IFailure, List<Map<String, dynamic>>>> delete(String table, WhereType where) async {
    try {
      final Box<Map<String, dynamic>> box = await openBox(table);

      final List<Map<String, dynamic>> removed = [];

      (await select(table, [], where)).fold((l) => throw l, (r) => removed.addAll(r));

      for (final dynamic element in removed) {
        final String deleteKey = element.values.first.toString();
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
  Future<Either<IFailure, List<Map<String, dynamic>>>> insert(String table, ColumnType columns) async {
    try {
      final Box<Map<String, dynamic>> box = await openBox(table);

      final WhereType where = {};
      for (final key in columns.keys) {
        where.addAll({
          key: [columns[key].toString()]
        });
      }

      await box.put(columns.values.first, columns);
      final List<Map<String, dynamic>> result = (await select(table, [], where)).fold((l) => [], (r) => r);
      return Right(result);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List<Map<String, dynamic>>>> select(String table, ColumnsSelectType columns, WhereType where) async {
    List<Map<String, dynamic>> listBox = [];
    try {
      final Box<Map<String, dynamic>> box = await openBox(table);

      listBox = box.values.toList();

      where.forEach((keyWhere, valueWhere) {
        listBox.removeWhere((element) {
          return (element.containsKey(keyWhere)) && !valueWhere.contains(element[keyWhere].toString());
        });
      });
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }

    return Right(listBox);
  }

  @override
  Future<Either<IFailure, List<Map<String, dynamic>>>> update(String table, ColumnType columns, WhereType where) async {
    List<Map<String, dynamic>> finalList = [];
    final List<Map<String, dynamic>> resultList = [];
    try {
      final Box<Map<String, dynamic>> box = await openBox(table);
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

          box.put(element.values.first, element);
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
