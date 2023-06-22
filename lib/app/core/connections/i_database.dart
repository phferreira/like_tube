import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';

abstract class IDataBase {
  Future<Either<IFailure, List<JsonType>>> select(String table, ColumnsSelectType columns, WhereType where);
  Future<Either<IFailure, List<JsonType>>> insert(String table, ColumnType columns);
  Future<Either<IFailure, List<JsonType>>> update(String table, ColumnType columns, WhereType where);
  Future<Either<IFailure, List<JsonType>>> delete(String table, WhereType where);
}
