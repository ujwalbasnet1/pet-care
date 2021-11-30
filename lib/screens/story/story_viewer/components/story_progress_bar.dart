import 'dart:developer';

import 'package:flutter/material.dart';

class StoryProgressBar extends StatelessWidget {
  final int length;
  final int currentTab;
  final double progress;
  const StoryProgressBar(
      {Key key, this.length = 1, this.currentTab, this.progress = 0})
      : super(key: key);
  final double height = 3;
  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width) - 20 - 4 * length;

    return Container(
      alignment: Alignment.topCenter,
      child: Row(
        children: List.generate(length, (index) {
          double barWidth = width / length;
          double currentProgress = index < currentTab
              ? barWidth * 1
              : index > currentTab
                  ? 0
                  : barWidth * progress;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            height: height,
            width: barWidth,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withAlpha(100)),
            child: AnimatedContainer(
              width: currentProgress,
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastOutSlowIn,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
            ),
          );
        }).toList(),
      ),
    );
  }
}
