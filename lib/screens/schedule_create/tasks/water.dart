import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';

class Water extends StatefulWidget {
  List<Widget> list;
  void Function(String time) getTime;
  void Function(String time) getTitle;
  Water({
    this.list,
    this.getTime,
    this.getTitle,
  });
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
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
            taskTitle: "Water",
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
