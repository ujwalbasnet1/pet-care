import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pets/utils/app_utils.dart';
import '../video_editor/video_editor_main.dart';

class CameraProvider extends ChangeNotifier {
  int _remainTime = 15;
  bool _isRecording = false;
  Timer _timer2;
  CameraController _controller;
  BuildContext _context;
  String _savedVideoPath;
  int _currentMode = 0;
  bool _isCameraMode = true;
  bool isForcedClose = false;

  get getCurrentMode => _currentMode;
  get isCameraMode => _currentMode == 0;

  set setCurrentMode(int currentMode) {
    _currentMode = currentMode;
    notifyListeners();
  }

  void startTimer(CameraController controller, BuildContext context) {
    _controller = controller;
    _context = context;
    if (_isRecording) return;
    startRecordering();
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
      (Timer timer) {
        _timer2 = timer;
        _remainTime--;
        if (_remainTime <= 0) {
          _timer2.cancel();
          stopRecordering();
        }
        notifyListeners();
      },
    );
  }

  startRecordering() async {
    isForcedClose = false;
    _isRecording = true;

    if (!_controller.value.isInitialized) {
      return null;
    }

    try {
      await _controller.startVideoRecording();
    } on CameraException catch (e) {
      // _showCameraException(e);
      print(e);
      return null;
    }

    notifyListeners();
  }

  stopRecordering({isReset = false}) async {
    _timer2.cancel();
    _isRecording = false;
    _remainTime = 15;
    log("message $isForcedClose");
    if (!isReset) {
      final String filePath = await getPath('Movies', '.mp4');
      XFile xFile = await _controller.stopVideoRecording();
      xFile.saveTo(filePath);
      pushReplacement(_context, VideoEditorMain(filePath));
      notifyListeners();
    }
    isForcedClose = false;
  }

  void stopTimer() {
    _timer2.cancel();
  }

  int get getRemainTime => _remainTime;
  bool get isRecording => _isRecording;

  void reset() {
    log("resteetetet ============");
    stopRecordering(isReset: true);
    isForcedClose = true;
    _timer2.cancel();
    _controller = null;
    _context = null;
    _savedVideoPath = null;
    _currentMode = 0;
    _isCameraMode = true;
  }
}

Future<String> getPath(String folderName, String extention) async {
  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  final Directory extDir = Platform.isAndroid
      ? await getExternalStorageDirectory() //FOR ANDROID
      : await getApplicationSupportDirectory();
  final String dirPath = '${extDir.path}/$folderName';
  await Directory(dirPath).create(recursive: true);
  return '$dirPath/${_timestamp()}$extention';
}
