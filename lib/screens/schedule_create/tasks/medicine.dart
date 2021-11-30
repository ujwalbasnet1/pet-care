import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/subtasks/others.dart';

class Medicine extends StatefulWidget {
  List<Widget> list;
  void Function(String time) getTime;
  void Function(String time) getTitle;
  Medicine({
    this.list,
    this.getTime,
    this.getTitle,
  });

  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  String name;
  TextEditingController nameController = TextEditingController();

  var padding = const EdgeInsets.symmetric(
    vertical: 5,
    horizontal: 20,
  );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Others(
            taskTitle: "Medicine",
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
