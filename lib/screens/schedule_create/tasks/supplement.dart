import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';

class Supplement extends StatefulWidget {
  List<Widget> list;
  void Function(String time) getTime;
  void Function(String time) getTitle;
  Supplement({
    this.list,
    this.getTime,
    this.getTitle,
  });
  @override
  _SupplementState createState() => _SupplementState();
}

class _SupplementState extends State<Supplement> {
  @override
  Widget build(BuildContext context) {
    List<Widget> supplementList = [];
    supplementList.add(
      PickerComponent(title: "Supplement Schedule"),
    );
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: widget.list,
        children: [
          Others(
            taskTitle: "Supplement",
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
