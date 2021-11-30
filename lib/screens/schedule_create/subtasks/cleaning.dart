import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';

class Cleaning extends StatefulWidget {
  final Function(String name) getTaskName;
  final Function(String name) getTaskTime;
  Cleaning({
    this.getTaskName,
    this.getTaskTime,
  });
  @override
  _CleaningState createState() => _CleaningState();
}

class _CleaningState extends State<Cleaning> {
  List<String> cleaning = [
    "Clean Tray",
    "Clean House",
    "Clean Trash",
  ];
  var padding = const EdgeInsets.symmetric(
    vertical: 5,
    horizontal: 20,
  );
  String _title = "Select Time";
  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: Text(
            "Task Name",
            style: style,
          ),
        ),
        CustomPicker(
          list: cleaning,
          // initiallySelected: true,
          onPressed: (title, index) {
            setState(() {
              _title = title;
            });
            widget.getTaskName(title ?? "Clean Tray");
          },
        ),
        _title.toLowerCase() != "others"
            ? PickerComponent(
                returnTime: (time) {
                  widget.getTaskTime(time);
                },
                title: _title,
              )
            : Others(
                getTime: (time) {
                  widget.getTaskTime(time);
                },
                getTitle: (title) {
                  widget.getTaskName(title);
                },
              ),
      ],
    );
  }
}
