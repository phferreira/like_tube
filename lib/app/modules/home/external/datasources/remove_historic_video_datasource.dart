import 'package:fpdart/fpdart.dart';

import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/failures/remove_historic_video_datasource_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_remove_historic_video_datasource.dart';

class RemoveHistoricVideoDatasource extends IRemoveHistoricVideoDatasource {
  final IDataBase database;

  RemoveHistoricVideoDatasource({required this.database});

  @override
  Future<Either<IFailure, Video>> call(Video videoParam) async {
    const String table = 'tb_historicvideos';

    final WhereType where = {
      'cd_id': [videoParam.id],
    };

    try {
      final ListVideo databaseResult = <Video>[];

      (await database.delete(table, where)).fold((l) => throw l, (r) {
        return r.toList().forEach((element) {
          databaseResult.add(Video.fromMap(element));
        });
      });
      return Right(databaseResult.last);
    } on IFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(RemoveHistoricVideoDatasourceError());
    }
  }
}
