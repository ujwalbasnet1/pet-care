import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';

class Walk extends StatefulWidget {
  final List<Widget> list;
  final Function(String) getStartTime;
  final Function(String) getEndTime;
  final Function(String) getRepeats;
  Walk({
    this.list,
    this.getEndTime,
    this.getStartTime,
    this.getRepeats,
  });
  @override
  _WalkState createState() => _WalkState();
}

class _WalkState extends State<Walk> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: widget.list,
        children: [
          PickerComponent(
            title: "Start Time - Morning",
            intialTime: "7:00 AM",
            returnTime: (time) {
              widget.getStartTime(time);
            },
          ),
          PickerComponent(
            intialTime: "7:00 PM",
            title: "End Time - Evening",
            returnTime: (time) {
              widget.getEndTime(time);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              "Repeat Every",
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
            ),
          ),
          CustomPicker(
            list: ["2 hrs", "4 hrs", "6 hrs", "8 hrs"],
            initiallySelected: true,
            selectedPointer: 1,
            onPressed: (title, index) {
              widget.getRepeats(title);
            },
          ),
        ],
      ),
    );
  }
}
