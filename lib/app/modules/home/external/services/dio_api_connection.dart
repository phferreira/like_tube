import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_http.dart';
import 'package:like_tube/app/core/constants/key.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/services/failures/http_failure.dart';

class DioApiConnection extends IHttp {
  final Dio dio;

  DioApiConnection({required this.dio});

  @override
  Future<Either<IFailure, List<Video>>> get(String description) async {
    Response response;

    try {
      response = await dio.get(
        '/search',
        queryParameters: {
          'key': apiKey,
          'part': 'snippet,id',
          'order': 'date',
          'maxResults': 100,
          'q': description,
        },
      );

      if (response.statusCode! != 200) {
        return Left(response.statusCode!.getFailure(response.statusMessage!));
      }
    } on DioError catch (e) {
      return Left(e.response!.statusCode!.getFailure(e.message));
    }

    final result = (response.data['items'] as List).map((element) => Video.fromJsonHttp(element)).toList();
    return Right(result);
  }
}
