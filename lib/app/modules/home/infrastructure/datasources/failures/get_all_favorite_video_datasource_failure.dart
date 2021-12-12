import 'package:like_tube/app/core/errors/i_failure.dart';

class GetAllFavoriteVideoDatasourceError implements IFailure {
  @override
  final String message;

  GetAllFavoriteVideoDatasourceError([this.message = ""]);
}
