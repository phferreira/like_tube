import 'dart:convert';
import 'dart:developer';
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
    log('Hive start');
    final Directory dir = await getApplicationDocumentsDirectory();
    log('Hive start 2');
    await Hive.initFlutter(dir.path);
    log('Hive start 3');
  }

  Future<void> close() async {
    Hive.close();
  }

  Future<Box<String>> openBox(String table) async {
    try {
      return await Hive.openBox(table);
    } catch (e) {
      await start();
      return Hive.openBox(table);
    }
  }

  List<Map<String, dynamic>> result(List<dynamic> value) {
    return jsonDecode(jsonEncode(value.toString())) as List<Map<String, dynamic>>;
  }

  @override
  Future<Either<IFailure, List<Map<String, dynamic>>>> delete(String table, WhereType where) async {
    try {
      final Box<String> box = await openBox(table);

      final List<Map<String, dynamic>> removed = [];

      (await select(table, [], where)).fold((l) => throw l, (r) => removed.addAll(r));

      for (final dynamic element in removed) {
        final Map<String, dynamic> delete = jsonDecode(element.toString()) as Map<String, dynamic>;
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
  Future<Either<IFailure, List<Map<String, dynamic>>>> insert(String table, ColumnType columns) async {
    try {
      final Box<String> box = await openBox(table);

      final WhereType where = {};
      for (final key in columns.keys) {
        // final List<String> _element = (jsonDecode(columns[_key].toString()));
        where.addAll({
          key: [columns[key].toString()]
        });
      }

      await box.put(columns.values.first, jsonEncode(columns));
      final List<Map<String, dynamic>> result = (await select(table, [], where)).fold((l) => [], (r) => r);
      return Right(result);
    } catch (e) {
      return Left(DataBaseError(e.toString()));
    }
  }

  @override
  Future<Either<IFailure, List<Map<String, dynamic>>>> select(String table, ColumnsSelectType columns, WhereType where) async {
    final List<Map<String, dynamic>> finalList = [];
    try {
      final Box<String> box = await openBox(table);

      List<Map<String, dynamic>> listBox = [];
      listBox = box.values.toList() as List<Map<String, dynamic>>;

      where.forEach((keyWhere, valueWhere) {
        listBox.removeWhere((element) {
          final Map<String, dynamic> result = jsonDecode(element.toString()) as Map<String, dynamic>;
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
  Future<Either<IFailure, List<Map<String, dynamic>>>> update(String table, ColumnType columns, WhereType where) async {
    List<Map<String, dynamic>> finalList = [];
    final List<Map<String, dynamic>> resultList = [];
    try {
      final Box<String> box = await openBox(table);
      finalList = (await select(table, [], where)).fold((l) => [], (r) => r);

      where.forEach((keyWhere, valueWhere) {
        finalList.removeWhere((element) {
          final Map<String, dynamic> result = jsonDecode(element.toString()) as Map<String, dynamic>;
          return (result.containsKey(keyWhere)) && !valueWhere.contains(result[keyWhere].toString());
        });
      });

      if (finalList.isNotEmpty) {
        for (final element in finalList) {
          final Map<String, dynamic> result = jsonDecode(element.toString()) as Map<String, dynamic>;

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
