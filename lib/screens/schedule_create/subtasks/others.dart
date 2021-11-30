import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';

class Others extends StatefulWidget {
  final String taskTitle;
  final void Function(String time) getTime;
  final void Function(String title) getTitle;
  Others({
    this.getTime,
    this.getTitle,
    this.taskTitle,
  });
  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  List<String> others = [];
  var padding = const EdgeInsets.symmetric(
    vertical: 5,
    horizontal: 20,
  );

  String name;
  TextEditingController nameController;
  @override
  void initState() {
    nameController = TextEditingController(text: "${widget.taskTitle ?? ""}");
    super.initState();
  }

  _showDialog() async {
    return await showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          title: Text("Enter Title"),
          actions: [
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if (nameController.text != "") {
                  setState(() {
                    name = nameController.text;
                  });
                  widget.getTitle(nameController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }

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
          child: Row(
            children: [
              Text(
                name ?? widget.taskTitle ?? "Task Title: ",
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
              widget.taskTitle == null
                  ? TextButton(
                      onPressed: () async {
                        await _showDialog();
                        // widget.getTaskName(title ?? "Weight Growth");
                      },
                      child: Text(
                        name ?? "Edit Title",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                      ),
                    )
                  : Container()
              //Don't remove this commented code
              // IconButton(
              //     icon: Icon(
              //       Icons.edit,
              //       color: Colors.blue,
              //     ),
              //     onPressed: () {
              //       _showDialog();
              //     },
              //   ),
            ],
          ),
        ),
        //Datepicker
        PickerComponent(
          index: 0,
          title: "Time",
          returnTime: (time) {
            widget.getTime(time);
          },
        ),
      ],
    );
  }
}
