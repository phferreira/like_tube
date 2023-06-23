import 'package:like_tube/app/core/errors/i_failure.dart';

class DataBaseError implements IFailure {
  @override
  final String message;

  DataBaseError([this.message = '']);
}

class DataBaseDeleteError implements IFailure {
  @override
  final String message;

  DataBaseDeleteError([this.message = '']);
}

class DataBaseUpdateError implements IFailure {
  @override
  final String message;

  DataBaseUpdateError([this.message = '']);
}

class DataBaseSelectError implements IFailure {
  @override
  final String message;

  DataBaseSelectError([this.message = '']);
}

class DataBaseInsertError implements IFailure {
  @override
  final String message;

  DataBaseInsertError([this.message = '']);
}
