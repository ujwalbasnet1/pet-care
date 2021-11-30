import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';

import 'animated_gradient_border.dart';

class CameraButton extends StatelessWidget {
  final bool isCameraMode;
  final bool isRecording;

  const CameraButton({Key key, this.isCameraMode, this.isRecording})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isCameraMode
        ? AnimatedGradientBorder(
            isAnimated: isRecording,
            child: Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.videocam,
                size: 40,
                color: blueClassicColor,
              ),
            ),
            strokeWidth: 7,
            radius: 200,
            gradient: LinearGradient(colors: [Colors.blue, Colors.redAccent]),
          )
        : Container(
            height: 95.0,
            width: 95.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 7.0,
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(5),
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera,
                size: 40,
                color: blueClassicColor,
              ),
            ),
          );
  }
}
