import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app/modules/home/external/services/dio_api_connection.dart';
import '../home/home_store.dart';
import 'domain/usecases/implementation/get_video_by_description_usecase.dart';
import 'external/datasources/get_video_by_description_datasource.dart';
import 'external/services/custom_dio.dart';
import 'infrastructure/repositories/get_video_by_description_repository.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    //Store
    Bind.lazySingleton((i) => HomeStore()),
    //
    Bind.lazySingleton((i) => CustomDio()),
    Bind.lazySingleton((i) => DioApiConnection(dio: i())),
    Bind.lazySingleton((i) => GetVideoByDescriptionDataSource(connection: i())),
    Bind.lazySingleton((i) => GetVideoByDescriptionRepository(datasource: i())),
    Bind.lazySingleton((i) => GetVideoByDescriptionUsecase(repository: i())),
    //
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const HomePage()),
  ];
}
