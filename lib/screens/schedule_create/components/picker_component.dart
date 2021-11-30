import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';

class PickerComponent extends StatefulWidget {
  final String title;
  final int index;
  final String intialTime;
  final Function(int index) onCancelButtonPressed;
  final void Function(String time) returnTime;
  final bool canEdit;

  PickerComponent({
    this.title,
    this.index,
    this.onCancelButtonPressed,
    this.returnTime,
    this.intialTime,
    this.canEdit = false,
  });

  @override
  _PickerComponentState createState() => _PickerComponentState();
}

class _PickerComponentState extends State<PickerComponent> {
  String text;
  String aMpM = "AM";
  String time = "";
  List<String> timeList = [];
  TextEditingController controller;
  @override
  void initState() {
    update();
    super.initState();
  }

  update() {
    controller = TextEditingController(text: "${widget.title}");
    for (var i = 1; i < 13; i++) {
      timeList.add("$i:00");
      timeList.add("$i:30");
    }
    if (widget.intialTime != null) {
      var initTime = widget.intialTime;
      widget.returnTime(initTime);
      aMpM = initTime.split(" ")[1];
      time = initTime.split(" ")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      text ?? widget.title,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ),
                  // widget.canEdit

                  //     ? IconButton(
                  //         onPressed: () {
                  //           showModal(
                  //             context: context,
                  //             builder: (context) {
                  //               return AlertDialog(
                  //                 content: TextField(
                  //                   controller: controller,
                  //                   decoration: InputDecoration(
                  //                     labelText: "Title",
                  //                     border: OutlineInputBorder(),
                  //                   ),
                  //                 ),
                  //                 title: Text("Enter Title"),
                  //                 actions: [
                  //                   TextButton(
                  //                     child: Text("CANCEL"),
                  //                     onPressed: () {
                  //                       Navigator.pop(context);
                  //                     },
                  //                   ),
                  //                   TextButton(
                  //                     child: Text("OK"),
                  //                     onPressed: () {
                  //                       Navigator.pop(context);
                  //                       if (controller.text != "") {
                  //                         setState(() {
                  //                           text = controller.text;
                  //                         });
                  //                       }
                  //                     },
                  //                   ),
                  //                 ],
                  //               );
                  //             },
                  //           );
                  //         },
                  //         icon: Icon(
                  //           Icons.edit,
                  //           color: Colors.blue,
                  //         ),
                  //       )
                  //     : Container(),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: widget.onCancelButtonPressed != null
                        ? const EdgeInsets.only(
                            right: 10,
                            top: 7,
                          )
                        : EdgeInsets.zero,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CustomPicker(
                        padding: EdgeInsets.zero,
                        selectedPointer: ["AM", "PM"].indexOf(aMpM),
                        list: ["AM", "PM"],
                        shouldSmall: true,
                        initiallySelected: true,
                        onPressed: (value, index) {
                          aMpM = value;
                          try {
                            widget.returnTime("$time $aMpM");
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                  widget.onCancelButtonPressed != null
                      ? InkWell(
                          onTap: () {
                            if (widget.onCancelButtonPressed != null) {
                              widget.onCancelButtonPressed(widget.index);
                            }
                          },
                          child: Icon(Icons.cancel_outlined),
                        )
                      : Container(),
                ],
              ),
              // IconButton(
              //   icon: Icon(Icons.cancel_outlined),
              //   onPressed: () {
              //     widget.onCancelButtonPressed();
              //   },
              // ),
            ],
          ),
        ),
        CustomPicker(
          list: timeList,
          selectedPointer: time == "" ? 0 : timeList.indexOf(time),
          // selectedPointer: timeList.indexOf(time),
          onPressed: (value, index) {
            time = value;
            try {
              widget.returnTime("$time $aMpM");
            } catch (e) {
              print(e);
            }
          },
          initiallySelected: true,
        ),
      ],
    );
  }
}
