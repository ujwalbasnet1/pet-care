import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GestureController extends StatelessWidget {
  final Widget child;
  final Function() onNext;
  final Function() onPrevious;
  final Function() onDoubleTap;
  final Function() onLongPressStart;
  final Function() onLongPressEnd;
  const GestureController(
      {Key key,
      this.child,
      @required this.onNext,
      @required this.onPrevious,
      @required this.onDoubleTap,
      @required this.onLongPressStart,
      @required this.onLongPressEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      child: Container(height: height, width: double.infinity, child: child),
      onDoubleTap: () {
        onDoubleTap();
        log("Liked ", name: "Gesture Controller");
      },
      onLongPressStart: (d) {
        log("Pause Start ", name: "Gesture Controller");
        onLongPressStart();
      },
      onLongPressEnd: (d) {
        log("Pause End ", name: "Gesture Controller");
        onLongPressEnd();
      },
      onTapUp: (d) {
        if (width / 2 > d.globalPosition.dx) {
          log("Previous ", name: "Gesture Controller");
          onPrevious();
        } else {
          log("Next ", name: "Gesture Controller");
          onNext();
        }
      },
    );
  }
}
