import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app//modules/video/video_store.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/video/video_page.dart';

class VideoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => VideoStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => VideoPage(video: Video.noProperties())),
  ];
}
