import 'package:like_tube/app/core/errors/i_failure.dart';

class SetFavoriteVideoRepositoryError implements IFailure {
  @override
  final String message;

  SetFavoriteVideoRepositoryError([this.message = ""]);
}
