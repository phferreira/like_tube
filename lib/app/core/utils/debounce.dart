import 'dart:async';
import 'dart:ui';

class Debounce {
  Timer? timer;

  void call(VoidCallback run) {
    timer?.cancel();

    timer = Timer(const Duration(seconds: 1), run);
  }
}
