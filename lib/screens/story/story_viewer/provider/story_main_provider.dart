import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class StoryMainProvider extends ChangeNotifier {
  final name = 'Provider';
  double _progress = 0;
  int _currentTab = 0, _storyMainCurrentTab = 0;
  bool _isPaused = false;

  double _totalTime = 10, _currentTime = 0;
  Timer _timer2;
  PageController _storyViewController, _storyMainController;
  int _storyViewLenth, _storyMainLenth = 0;
  BuildContext _storyMainContext;

  initStoryView(int storyViewLenth, PageController controller) {
    log('initStoryMain', name: name, zone: Zone.current);

    _storyViewController = controller;
    _storyViewLenth = storyViewLenth;
    _currentTime = 0;
    _currentTab = 0;
    _progress = 0;
    // notifyListeners();
    timerCancelAndMakeNull();
    startTimer(false);
  }

  initStoryMain(
      int storyViewLenth, PageController controller, BuildContext context) {
    log('initStoryMain', name: name);

    _storyMainContext = context;
    _storyMainController = controller;
    _storyMainLenth = storyViewLenth;
    _storyMainCurrentTab = 0;
  }

  bool onNext() {
    log("onNext", name: name);
    if (_currentTab < _storyViewLenth - 1) {
      // startTimer();
      //Resuable
      _progress = 0;

      notifyListeners();
      _currentTab++;
      _storyViewController.nextPage(
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);

      startTimer(false);
    } else {
      onNextUserStory();
      return true;
    }
    return false;
  }

  bool onPrevious() {
    log("Prvious", name: name);
    if (_currentTab > 0) {
      //Resuable
      _progress = 0;

      notifyListeners();
      _currentTab--;
      _storyViewController.previousPage(
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      startTimer(false);
    } else {
      onPreviousUserStory();
      // _timer2.cancel();
      return true;
    }
    return false;
  }

  onNextUserStory() {
    log('onNextUserStory', name: name);
    if (_storyMainCurrentTab < _storyMainLenth - 1) {
      resetTab();
      _storyMainController.nextPage(
          duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
      _storyMainCurrentTab++;
    } else {
      timerCancelAndMakeNull();
      Navigator.pop(_storyMainContext);
    }
    // if (_currentTab < _storyViewLenth - 1) {
    //   startTimer();
    //   _currentTab++;
    //   _storyViewController.nextPage(
    //       duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    // } else {
    //   // widget.onNext();
    //   _timer2.cancel();
    // }
  }

  onPreviousUserStory() {
    log('onPreviousUserStory', name: name);

    log(_storyMainCurrentTab.toString());
    log((_storyMainLenth - 1).toString());
    if (_storyMainCurrentTab > 0) {
      _storyMainController.previousPage(
          duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
      _storyMainCurrentTab--;
      resetTab();
    }
    // if (_currentTab > 0) {
    //   _currentTab--;
    //   _storyViewController.previousPage(
    //       duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    //   startTimer();
    // } else {
    //   // widget.onPrevious();
    //   _timer2.cancel();
    // }
  }

  setProgress(double progress) {
    log('setProgress', name: name);
    _progress = progress ?? 0;

    timerCancelAndMakeNull(bool: false);
    notifyListeners();
  }

  timerCancelAndMakeNull({bool bool = true}) {
    if (bool) log('timerCancelAndMakeNull', name: name);

    if (_timer2 != null) {
      _timer2.cancel();
      _timer2 = null;
      _currentTime = 0;
      log('Timer Stopped', name: name);
    }
  }

  void startTimer(bool bool) {
    log('Start Timer', name: name);
    log('_currentTab $_currentTab', name: name);
    log('_progress $_progress', name: name);
    log('_storyMainCurrentTab $_storyMainCurrentTab', name: name);

    timerCancelAndMakeNull();
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
      (Timer timer) {
        _timer2 = timer;
        if (!_isPaused) {
          _currentTime++;
          print(_currentTime);
          _progress = _currentTime / _totalTime;
          if (_currentTime >= _totalTime) {
            timerCancelAndMakeNull();
            // _progress = 0;
            onNext();
          }
          notifyListeners();
        }
        // if (bool) {
        //   notifyListeners();
        // } else {
        //   bool = true;
        // }
      },
    );
  }

  setCurrentTab() {
    log('setCurrentTab', name: name);

    startTimer(false);
    notifyListeners();
  }

  resetTab() {
    log('resetTab', name: name);
    _currentTab = 0;
    _progress = 0;
    timerCancelAndMakeNull();
    // notifyListeners();
  }

  double get getProgress => _progress;
  int get getCurrentTab => _currentTab;
  bool get isPaused => _isPaused;

  void setPause(bool bool) {
    _isPaused = bool;
    notifyListeners();
  }
}
