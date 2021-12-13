import 'package:like_tube/app/core/errors/i_failure.dart';

class GetHistoricVideoDatasourceError implements IFailure {
  @override
  final String message;

  GetHistoricVideoDatasourceError([this.message = '']);
}
