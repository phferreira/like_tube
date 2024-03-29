import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app/core/routes/routes.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_all_favorite_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/get_video_by_description_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/remove_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/set_favorite_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/set_historic_video_usecase.dart';
import 'package:like_tube/app/modules/home/external/datasources/get_all_favorite_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/datasources/get_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/datasources/get_video_by_description_datasource.dart';
import 'package:like_tube/app/modules/home/external/datasources/remove_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/datasources/set_favorite_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/datasources/set_historic_video_datasource.dart';
import 'package:like_tube/app/modules/home/external/services/custom_dio.dart';
import 'package:like_tube/app/modules/home/external/services/dio_api_connection.dart';
import 'package:like_tube/app/modules/home/external/services/shared_preferences_database.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/get_all_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/get_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/get_video_by_description_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/remove_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/set_favorite_video_repository.dart';
import 'package:like_tube/app/modules/home/infrastructure/repositories/set_historic_video_repository.dart';
import 'package:like_tube/app/modules/home/presenter/stores/bottom_navigation_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/favorite_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/history_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/home_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/video_item_store.dart';
import 'package:like_tube/app/modules/home/presenter/widgets/home_page.dart';
import 'package:like_tube/app/modules/video/video_module.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    // Store
    Bind<HomeStore>((i) => HomeStore()),
    Bind((i) => VideoItemStore()),
    Bind((i) => BottomNavigationStore()),
    Bind((i) => FavoriteVideoStore()),
    Bind((i) => HistoryVideoStore()),
    // Services
    Bind.lazySingleton((i) => CustomDio()),
    Bind.lazySingleton((i) => DioApiConnection(dio: i())),
    Bind.lazySingleton((i) => SharedPreferencesDatabase()),
    // DataSources
    Bind.lazySingleton((i) => GetVideoByDescriptionDataSource(connection: i())),
    Bind.lazySingleton((i) => SetFavoriteVideoDatasource(database: i())),
    Bind.lazySingleton((i) => GetHistoricVideoDatasource(database: i())),
    Bind.lazySingleton((i) => SetHistoricVideoDatasource(database: i())),
    Bind.lazySingleton((i) => RemoveHistoricVideoDatasource(database: i())),
    Bind.lazySingleton((i) => GetAllFavoriteVideoDatasource(database: i())),
    // Repositories
    Bind.lazySingleton((i) => GetVideoByDescriptionRepository(datasource: i())),
    Bind.lazySingleton((i) => SetFavoriteVideoRepository(datasource: i())),
    Bind.lazySingleton((i) => GetHistoricVideoRepository(datasource: i())),
    Bind.lazySingleton((i) => SetHistoricVideoRepository(datasource: i())),
    Bind.lazySingleton((i) => RemoveHistoricVideoRepository(datasource: i())),
    Bind.lazySingleton((i) => GetAllFavoriteVideoRepository(datasource: i())),
    // Usecases
    Bind.lazySingleton((i) => GetVideoByDescriptionUsecase(repository: i())),
    Bind.lazySingleton((i) => SetFavoriteVideoUsecase(repository: i())),
    Bind.lazySingleton((i) => GetHistoricVideoUsecase(repository: i())),
    Bind.lazySingleton((i) => SetHistoricVideoUsecase(repository: i())),
    Bind.lazySingleton((i) => RemoveHistoricVideoUsecase(repository: i())),
    Bind.lazySingleton((i) => GetAllFavoriteVideoUsecase(repository: i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute<void>(Modular.initialRoute, child: (context, args) => const HomePage()),
    ModuleRoute<void>(Routes.video, module: VideoModule()),
  ];
}
