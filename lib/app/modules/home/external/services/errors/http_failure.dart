import 'package:like_tube/app/core/errors/i_failure.dart';

class ApiConnectionError implements IFailure {
  @override
  final String message;

  ApiConnectionError([this.message = ""]);
}

class TimeOutError implements IFailure {
  @override
  final String message;

  TimeOutError([this.message = ""]);
}

class NotFoundError implements IFailure {
  @override
  final String message;

  NotFoundError([this.message = ""]);
}

class BadRequestError implements IFailure {
  @override
  final String message;

  BadRequestError([this.message = ""]);
}
