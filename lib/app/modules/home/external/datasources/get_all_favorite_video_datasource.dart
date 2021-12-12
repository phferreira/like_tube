import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_all_favorite_video_datasource.dart';

class GetAllFavoriteVideoDatasource extends IGetAllFavoriteVideoDatasource {
  final IDataBase database;

  GetAllFavoriteVideoDatasource({required this.database});

  @override
  Future<Either<IFailure, List<Video>>> call() async {
    const String _table = 'tb_historicvideos';

    WhereType _where = {
      'bl_favorite': ['true'],
    };

    try {
      List<Video> _databaseResult = <Video>[];

      (await database.select(_table, [], _where)).fold((l) => throw l, (r) {
        return r.toList().forEach((element) {
          _databaseResult.add(Video.fromJson(element.toString()));
        });
      });
      return Right(_databaseResult);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(DataBaseError());
    }
  }
}
