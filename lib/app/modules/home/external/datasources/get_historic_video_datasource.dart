import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/failures/get_historic_video_datasource_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_get_historic_video_datasource.dart';

class GetHistoricVideoDatasource extends IGetHistoricVideoDatasource {
  final IDataBase database;

  GetHistoricVideoDatasource({required this.database});

  @override
  Future<Either<IFailure, ListVideo>> call() async {
    const String table = 'tb_historicvideos';

    final WhereType where = {
      'bl_historic': ['true'],
    };

    try {
      final ListVideo databaseResult = <Video>[];

      (await database.select(table, [], where)).fold((l) => throw l, (r) {
        for (final JsonType element in r) {
          databaseResult.add(Video.fromMap(element));
        }
      });
      return Right(databaseResult);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GetHistoricVideoDatasourceError());
    }
  }
}
