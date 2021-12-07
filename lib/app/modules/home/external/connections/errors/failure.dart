import 'package:like_tube/app/core/errors/i_failure.dart';

class ApiConnectionError implements IFailure {
  @override
  final String message;

  ApiConnectionError([this.message = ""]);
}
