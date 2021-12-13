import 'package:like_tube/app/core/errors/i_failure.dart';

class RemoveHistoricVideoDatasourceError implements IFailure {
  @override
  final String message;

  RemoveHistoricVideoDatasourceError([this.message = '']);
}
