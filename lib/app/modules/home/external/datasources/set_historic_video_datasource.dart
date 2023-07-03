import 'package:fpdart/fpdart.dart';

import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/failures/set_historic_video_datasource_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_historic_video_datasource.dart';

class SetHistoricVideoDatasource extends ISetHistoricVideoDatasource {
  final IDataBase database;

  SetHistoricVideoDatasource({required this.database});

  @override
  Future<Either<IFailure, Video>> call(Video videoParam) async {
    const String table = 'tb_historicvideos';

    final ColumnType columns = {
      'cd_id': videoParam.id,
      'tx_title': videoParam.title,
      'tx_url': videoParam.url,
      'bl_favorite': videoParam.favorite.toString(),
      'bl_historic': 'true',
    };

    try {
      final ListVideo databaseResult = <Video>[];

      (await database.insert(table, columns)).fold((l) => throw l, (r) {
        for (final JsonType element in r) {
          databaseResult.add(Video.fromMap(element));
        }
      });
      return Right(databaseResult.last);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(SetHistoricVideoDatasourceError());
    }
  }
}
