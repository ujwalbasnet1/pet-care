import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/multi_select.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';

class CustomDialog extends StatefulWidget {
  final Function onCancel;
  final Function(String, Set<String>) onSaved;
  CustomDialog({this.onCancel, this.onSaved});
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  Set<String> output = {};
  List<String> getList() {
    List<String> _list = [];
    for (int i = 1; i <= 31; i++) {
      _list.add("$i");
    }
    return _list;
  }

  int listPointer = 0;
  var monthly;
  var weekly;
  @override
  void initState() {
    monthly = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("Montly On"),
          ),
          new MultiSelect(
            list: getList(),
            onPressed: (title, index) {
              output.add(title);
            },
            getSelectedItem: (newItems) {},
            padding: EdgeInsets.all(0),
          ),
        ],
      ),
    );
    weekly = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("Weekly on"),
          ),
          new MultiSelect(
            list: [
              "Su",
              "Mo",
              "Tu",
              "We",
              "Th",
              "Fr",
              "Sa",
            ],
            padding: EdgeInsets.all(0),
            getSelectedItem: (items) {},
            onPressed: (title, index) {
              print(title);
              output.add(title);
            },
          ),
        ],
      ),
    );
    super.initState();
  }

  bool isWeekly = true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Repeats Every"),
          CustomPicker(
            list: ["Weekly", "Monthly"],
            onPressed: (title, index) {
              output.clear();
              if (title == "Monthly") {
                setState(() {
                  isWeekly = false;
                });
              } else {
                setState(() {
                  isWeekly = true;
                });
              }
            },
            initiallySelected: true,
            padding: EdgeInsets.zero,
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
            child: isWeekly ? weekly : monthly,
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (widget.onCancel != null) {
              widget.onCancel();
            }
          },
          child: Text("CANCEL"),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            onPressed: () {
              String value = isWeekly ? "Weekly" : "Monthly";
              if (widget.onSaved != null) {
                widget.onSaved(value, output);
              }
            },
            child: Text("OK"),
          ),
        ),
      ],
    );
  }
}
