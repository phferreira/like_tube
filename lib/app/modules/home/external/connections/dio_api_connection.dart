import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/constants/key.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video_model.dart';
import 'package:like_tube/app/modules/home/external/connections/custom_dio.dart';
import 'package:like_tube/app/modules/home/external/connections/errors/failure.dart';
import '../../../../core/connections/i_connection_usecase.dart';

class DioApiConnection extends IConnection {
  CustomDio dio = CustomDio();

  @override
  Future<Either<IFailure, List<VideoModel>>> call(String description) async {
    Response response;

    try {
      response = await dio.get(
        '/search',
        queryParameters: {
          'key': API_KEY,
          'part': 'snippet,id',
          'order': 'date',
          'maxResults': 15,
          'q': description,
        },
      );

      if (response.statusCode! != 200) {
        return Left(response.statusCode!.getFailure(response.statusMessage!));
      }
    } on DioError catch (e) {
      return Left(e.response!.statusCode!.getFailure(e.message));
    }

    final result = (response.data['items'] as List).map((element) => VideoModel.fromJson(element)).toList();
    return Right(result);
  }
}
