import 'package:like_tube/app/core/errors/i_failure.dart';

extension ErrorsInt on int {
  IFailure getFailure([String message = '']) {
    switch (this) {
      case 400:
        return BadRequestError(message);
      case 404:
        return NotFoundError(message);
      case 408:
        return TimeOutError(message);
      default:
        return ApiConnectionError(message);
    }
  }
}

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
