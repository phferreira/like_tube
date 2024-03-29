import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_video_by_description_usecase.dart';

class HomeStore extends NotifierStore<IFailure, ListVideo> {
  HomeStore() : super([]);
  final IGetVideoByDescriptionUsecase _usecase = Modular.get();

  Future<void> getVideoByDescription(String param) async {
    update((await _usecase(param)).getRight().getOrElse(() => []));
  }

  void changePage(int index) {
    setLoading(true);
    update(state);
    setLoading(false);
  }
}
