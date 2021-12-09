import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/modules/home/domain/entities/video_model.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_video_by_description_usecase.dart';

class HomeStore extends NotifierStore<Exception, List<VideoModel>> {
  HomeStore() : super([]);
  final IGetVideoByDescriptionUsecase _usecase = Modular.get();
  final pesquisarController = TextEditingController();

  void getVideoByDescription(String param) async {
    update((await _usecase(pesquisarController.text)).getRight().getOrElse(() => []));
  }
}
