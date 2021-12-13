import 'package:like_tube/app/core/errors/i_failure.dart';

class RemoveHistoricVideoRepositoryError implements IFailure {
  @override
  final String message;

  RemoveHistoricVideoRepositoryError([this.message = '']);
}
