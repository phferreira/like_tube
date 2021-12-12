import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_video_by_description_usecase.dart';

class HomeStore extends NotifierStore<IFailure, List<Video>> {
  HomeStore() : super([]);
  final IGetVideoByDescriptionUsecase _usecase = Modular.get();
  final pesquisarController = TextEditingController();

  void getVideoByDescription(String param) async {
    update((await _usecase(pesquisarController.text)).getRight().getOrElse(() => []));
  }

  void changePage(int index) {
    setLoading(true);
    update(state);
    setLoading(false);
  }
}
