import 'package:like_tube/app/core/errors/i_failure.dart';

class SetHistoricVideoRepositoryError implements IFailure {
  @override
  final String message;

  SetHistoricVideoRepositoryError([this.message = '']);
}
