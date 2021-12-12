import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/favorite_video_store.dart';

class BottomNavigationStore extends NotifierStore<IFailure, int> {
  BottomNavigationStore() : super(0);

  FavoriteVideoStore get favoriteVideoStore => Modular.get<FavoriteVideoStore>();

  void selectedIndex(int index) {
    setLoading(true);
    update(index);
    if (index == 1) {
      favoriteVideoStore.getAllFavoriteVideos();
    }
    setLoading(false);
  }

  int getSelectedIndex() {
    return state;
  }
}
