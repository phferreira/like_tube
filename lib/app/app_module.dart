import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app/modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute<void>(
      Modular.initialRoute,
      module: HomeModule(),
    ),
  ];
}
