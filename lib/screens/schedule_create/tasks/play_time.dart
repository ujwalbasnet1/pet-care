import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';

class PlayTime extends StatefulWidget {
  List<Widget> list;
  void Function(String time) getTime;
  void Function(String time) getTitle;
  PlayTime({
    this.list,
    this.getTime,
    this.getTitle,
  });
  @override
  _PlayTimeState createState() => _PlayTimeState();
}

class _PlayTimeState extends State<PlayTime> {
  @override
  Widget build(BuildContext context) {
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: widget.list,
        children: [
          Others(
            taskTitle: "Play Time",
            getTime: (time) {
              widget.getTime(time);
            },
            getTitle: (title) {
              widget.getTitle(title);
            },
          ),
        ],
      ),
    );
  }
}
