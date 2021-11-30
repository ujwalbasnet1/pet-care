import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';

class Grooming extends StatefulWidget {
  final Function(String name) getTaskName;
  final Function(String name) getTaskTime;
  Grooming({
    this.getTaskName,
    this.getTaskTime,
  });
  @override
  _GroomingState createState() => _GroomingState();
}

class _GroomingState extends State<Grooming> {
  List<String> grooming = [
    "Bathing",
    "Combing",
    "Trimming",
    "Nail Trimming",
    "Teeth Cleaning",
    "Ear Cleaning",
    "Others",
  ];
  var padding = const EdgeInsets.symmetric(
    vertical: 5,
    horizontal: 20,
  );
  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
        );
    String _title = "Select Time";
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
          list: grooming,
          // initiallySelected: true,
          onPressed: (title, index) {
            setState(() {
              _title = title;
            });
            widget.getTaskName(title);
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
