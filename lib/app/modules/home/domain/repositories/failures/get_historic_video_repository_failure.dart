import 'package:like_tube/app/core/errors/i_failure.dart';

class GetHistoricVideoRepositoryError implements IFailure {
  @override
  final String message;

  GetHistoricVideoRepositoryError([this.message = '']);
}
