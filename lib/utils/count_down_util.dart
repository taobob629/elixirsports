import 'dart:async';

import 'toast_utils.dart';

class CountDownUtil {
  late Timer _timer;
  int _seconds = 60 * 15;

  bool isShow = true;

  late Function(int countTime) callback;
  late Function completeCallback;

  CountDownUtil(this.callback, this.completeCallback, {int seconds = 60 * 15}) {
    _seconds = seconds;
  }

  void updateSeconds(int seconds) {
    _seconds = seconds;
  }

  void startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (v) {
      if (_seconds > 0) {
        _seconds--;
        callback(_seconds);
      } else {
        _timer.cancel();
        completeCallback();
      }
    });
  }

  void stopCountDown() {
    isShow = false;
    _timer.cancel();
    dismissLoading();
  }
}
