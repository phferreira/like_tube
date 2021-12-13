import 'package:like_tube/app/core/errors/i_failure.dart';

class GetAllFavoriteVideoRepositoryError implements IFailure {
  @override
  final String message;

  GetAllFavoriteVideoRepositoryError([this.message = '']);
}
