import 'package:like_tube/app/core/connections/i_database.dart';
import 'package:like_tube/app/core/enum/database_result_enum.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/external/services/failures/database_failure.dart';
import 'package:like_tube/app/modules/home/infrastructure/datasources/i_set_favorite_video_datasource.dart';

class SetFavoriteVideoDatasource extends ISetFavoriteVideoDatasource {
  final IDataBase database;

  SetFavoriteVideoDatasource({required this.database});

  @override
  Future<List<DatabaseResultEnum>> call(Video video) async {
    const String table = 'tb_favoritevideos';
    final ColumnType columns = {
      'cd_id': video.id,
      'tx_title': video.title,
      'tx_url': video.url,
      'bl_favorite': (!video.favorite).toString(),
      'bl_historic': video.historic.toString(),
    };

    final WhereType where = {
      'cd_id': [video.id],
    };

    try {
      final List<DatabaseResultEnum> result = [];
      final ListVideo databaseResult = [];

      result.add(
        (await database.update(table, columns, where)).fold((l) => DatabaseResultEnum.notUpdated, (r) {
          for (final JsonType element in r) {
            databaseResult.add(Video.fromMap(element));
          }
          return DatabaseResultEnum.updated;
        }),
      );
      if (result.last == DatabaseResultEnum.notUpdated) {
        result.add(
          (await database.insert(table, columns)).fold((l) => DatabaseResultEnum.notInserted, (r) {
            for (final JsonType element in r) {
              databaseResult.add(Video.fromMap(element));
            }
            return DatabaseResultEnum.inserted;
          }),
        );
      }
      if (databaseResult.isNotEmpty) {
        video.favorite = databaseResult.last.favorite;
      }
      return result;
    } on IFailure {
      rethrow;
    } catch (e) {
      throw DataBaseError();
    }
  }
}
