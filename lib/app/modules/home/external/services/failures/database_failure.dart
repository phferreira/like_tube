import 'package:like_tube/app/core/errors/i_failure.dart';

class DataBaseError implements IFailure {
  @override
  final String message;

  DataBaseError([this.message = ""]);
}

class DataBaseUpdateError implements IFailure {
  @override
  final String message;

  DataBaseUpdateError([this.message = ""]);
}

class DataBaseNotUpdateError implements IFailure {
  @override
  final String message;

  DataBaseNotUpdateError([this.message = ""]);
}

class DataBaseInsertError implements IFailure {
  @override
  final String message;

  DataBaseInsertError([this.message = ""]);
}
