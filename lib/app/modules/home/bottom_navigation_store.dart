import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';

class BottomNavigationStore extends NotifierStore<IFailure, int> {
  BottomNavigationStore() : super(0);

  void selectedIndex(int index) {
    setLoading(true);
    update(index);
    setLoading(false);
  }

  int getSelectedIndex() {
    return state;
  }
}
