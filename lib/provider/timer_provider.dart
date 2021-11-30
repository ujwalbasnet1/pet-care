import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  int _remainTime = 60;
  Timer _timer2;
  void startTimer(time) {
    _remainTime = time;
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
      (Timer timer) {
        _timer2 = timer;
        _remainTime--;
        if (_remainTime <= 0) {
          _timer2.cancel();
        }
        notifyListeners();
      },
    );
  }

  void stopTimer() {
    _timer2.cancel();
  }

  get getRemainTime => _remainTime;
}
