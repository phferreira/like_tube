import 'package:flutter_modular/flutter_modular.dart';
import '../home/home_store.dart';
import 'domain/usecases/implementation/get_video_by_description_usecase.dart';
import 'external/connections/dio_api_connection.dart';
import 'external/datasources/get_video_by_description_datasource.dart';
import 'infrastructure/repositories/get_video_by_description_repository.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
    Bind.lazySingleton((i) => DioApiConnection()),
    Bind.lazySingleton((i) => GetVideoByDescriptionDataSource(connection: i())),
    Bind.lazySingleton((i) => GetVideoByDescriptionRepository(datasource: i())),
    Bind.lazySingleton((i) => GetVideoByDescriptionUsecase(repository: i()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const HomePage()),
  ];
}
