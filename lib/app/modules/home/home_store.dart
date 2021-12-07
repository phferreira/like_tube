import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_get_video_by_description_usecase.dart';

class HomeStore extends NotifierStore<Exception, int> {
  HomeStore() : super(0);

  final IGetVideoByDescriptionUsecase usecase = Modular.get();

  void getVideoByDescription(String param) {
    usecase(param);
  }
}
