import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/screens/schedule_create/subtasks/cleaning.dart';
import 'package:pets/screens/schedule_create/subtasks/grooming.dart';
import 'package:pets/screens/schedule_create/subtasks/measurements.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';
import 'package:pets/screens/schedule_create/subtasks/shopping.dart';
import 'package:pets/screens/schedule_create/subtasks/traning.dart';
import 'package:pets/screens/schedule_create/subtasks/veterinary.dart';

class CreateTask extends StatefulWidget {
  List<Widget> list;
  Function(String time) getTime;
  Function(String name) getTaskName;
  Function(String type) getTaskType;
  CreateTask({
    this.list,
    this.getTaskName,
    this.getTaskType,
    this.getTime,
  });
  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  List<String> taskList = [
    "Veterinary",
    "Grooming",
    "Cleaning",
    "Shopping",
    "Training",
    "Measurements",
    "Others"
  ];
  List<String> subtaskList = [
    "Doctor Visit",
    "Bathing",
    "Clean Tray",
    "Food",
    "Training",
    "Weight Growth",
    "Others"
  ];

  var padding = const EdgeInsets.symmetric(
    vertical: 5,
    horizontal: 20,
  );

  int pointer = 0;

  @override
  void initState() {
    init();
    super.initState();
  }

  List<Widget> _child = [];
  void init() {
    widget.getTaskName(subtaskList[pointer]);
    _child = [
      Veterinary(
        getTaskName: (name) {
          widget.getTaskName(name ?? "Doctor Visit");
        },
        getTaskTime: (time) {
          widget.getTime(time);
        },
      ),
      Grooming(
        getTaskName: (name) {
          widget.getTaskName(name ?? "Bathing");
        },
        getTaskTime: (time) {
          widget.getTime(time);
        },
      ),
      Cleaning(
        getTaskName: (name) {
          widget.getTaskName(name);
        },
        getTaskTime: (time) {
          widget.getTime(time);
        },
      ),
      Shopping(
        getTaskName: (name) {
          widget.getTaskName(name);
        },
        getTaskTime: (time) {
          widget.getTime(time);
        },
      ),
      Traning(
        getTaskName: (name) {
          widget.getTaskName(name);
        },
        getTaskTime: (time) {
          widget.getTime(time);
        },
      ),
      Measurements(
        getTaskName: (name) {
          widget.getTaskName(name);
        },
        getTaskTime: (time) {
          widget.getTime(time);
        },
      ),
      Others(
        getTime: (time) {
          widget.getTime(time);
        },
        getTitle: (title) {
          widget.getTaskName(title);
          widget.getTaskType("others");
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
          color: Colors.black,
        );

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding,
            child: Text(
              "Task Type",
              style: style,
            ),
          ),
          CustomPicker(
            list: taskList,
            initiallySelected: true,
            imageUrls: [
              "assets/images/veterinary.png",
              "assets/images/grooming.png",
              "assets/images/cleaning.png",
              "assets/images/shopping.png",
              "assets/images/training.png",
              "assets/images/measurement.png",
              "assets/images/others.png",
            ],
            onPressed: (title, index) {
              setState(() {
                pointer = index;
              });
              init();
              widget.getTaskType(taskList[pointer]);
            },
          ),
          PageTransitionSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return SharedAxisTransition(
                transitionType: SharedAxisTransitionType.horizontal,
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
                fillColor: Colors.transparent,
              );
            },
            child: _child[pointer],
          )
        ],
      ),
    );
  }
}
