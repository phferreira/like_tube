import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/presenter/stores/favorite_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/history_video_store.dart';

class BottomNavigationStore extends NotifierStore<IFailure, int> {
  BottomNavigationStore() : super(0);

  FavoriteVideoStore get favoriteVideoStore => Modular.get<FavoriteVideoStore>();
  HistoryVideoStore get historyVideoStore => Modular.get<HistoryVideoStore>();

  void selectedIndex(int index) {
    setLoading(true);
    update(index);

    switch (index) {
      case 1:
        favoriteVideoStore.getAllFavoriteVideos();
        break;
      case 2:
        historyVideoStore.getHistoryVideos();
        break;
      default:
    }
    setLoading(false);
  }

  int getSelectedIndex() {
    return state;
  }
}
