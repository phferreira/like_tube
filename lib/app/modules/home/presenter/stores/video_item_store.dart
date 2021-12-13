import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/domain/usecases/i_set_favorite_video_usecase.dart';
import 'package:like_tube/app/modules/home/domain/usecases/implementation/set_favorite_video_usecase.dart';
import 'package:like_tube/app/modules/home/presenter/stores/favorite_video_store.dart';

class VideoItemStore extends NotifierStore<IFailure, Video> {
  VideoItemStore() : super(Video.noProperties());

  ISetFavoriteVideoUsecase get _usecase => Modular.get<SetFavoriteVideoUsecase>();
  FavoriteVideoStore get _favoriteVideoStore => Modular.get<FavoriteVideoStore>();

  Future saveFavorite(Video video) async {
    setLoading(true);
    await _usecase(video);
    update(video);
    await _favoriteVideoStore.getAllFavoriteVideos();
    setLoading(false);
  }
}
