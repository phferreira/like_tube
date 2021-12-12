import 'package:like_tube/app/core/errors/i_failure.dart';

class SetHistoricVideoDatasourceError implements IFailure {
  @override
  final String message;

  SetHistoricVideoDatasourceError([this.message = ""]);
}
