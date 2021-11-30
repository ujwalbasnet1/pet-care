import 'dart:convert';
import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_create/components/custom_dialog.dart';
import 'package:pets/screens/schedule_create/components/multi_select.dart';
import 'package:pets/screens/schedule_create/components/my_multiselect.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class UpdateSchedule extends StatefulWidget {
  final String taskId;
  const UpdateSchedule({Key key, this.taskId}) : super(key: key);
  @override
  UpdateScheduleState createState() => UpdateScheduleState();
}

class UpdateScheduleState extends State<UpdateSchedule> {
  final style = TextStyle(
    fontSize: 18,
    color: Colors.blue,
  );
  Map<String, dynamic> data = {};
  bool isSelected = true;
  ScrollController scrollController = ScrollController();
  var currentTime = DateTime.now();
  String selectedTime;
  String repeatController = "Everyday";
  DateTime selectedDate;
  bool switchValue = true;
  List<String> sendReminderTo = [];
  TextEditingController commentController = TextEditingController();
  int pointer = 0;
  LoadingProgressDialog loadingIndicator = new LoadingProgressDialog();
  String taskName = "Task Name will be here";

  String taskType = "Task Type will be here";
  String localTime = "1:00 AM";
  bool isLoaded = false, isFailed = true;
  var members = [];
  @override
  void initState() {
    super.initState();
    updateData();
  }

  updateData() async {
    // var data = widget.taskId;
    var res = await RestRouteApi(
            context, ApiPaths.getTasksbyTaskID + "?task=${widget.taskId}")
        .get();
    if (res != null) {
      var data = res['data'];
      print(data);
      members = res['data']['pet']['group']['members'];
      taskName = data['taskname'];
      taskType = data['taskType'];
      localTime = data['localTime'];
      localTime = data['localTime'];
      sendReminderTo = data['sendReminderTo'].split(",");
      selectedDate = toDatefromInvalidDate(data['dateSelected']);
      repeatController = getRepeatTypeFromData(data['repeatType']);
      switchValue = data['isActive'];
      commentController.text = data['comment'];
      isLoaded = true;
      isFailed = false;
      if (mounted) setState(() {});
    }
  }

  String _getDay(int number) {
    String result = "Su";
    switch (number) {
      case 1:
        result = "Mo";
        break;
      case 2:
        result = "Tu";
        break;
      case 3:
        result = "We";
        break;
      case 4:
        result = "Th";
        break;
      case 5:
        result = "Fr";
        break;
      case 6:
        result = "Sa";
        break;
      case 7:
        result = "Su";
        break;

      default:
        break;
    }
    return result;
  }

  String _getSuffix(int number) {
    String result = "th";
    if (number == 1) {
      result = "st";
    } else if (number == 2) {
      result = "nd";
    } else if (number == 3) {
      result = "rd";
    }
    return result;
  }

  Widget field(String title, {Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: EdgeInsets.only(left: 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            child ?? Container(),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget daysListCustom(List list) {
    return Container(
      child: Column(
        children: List.generate(list.length, (index) {
          return ListTile(
            title: Text(list[index]),
            onTap: () {
              setState(() {
                repeatController = list[index];
              });
              Navigator.of(context).pop();
              if (repeatController == "Custom") {
                showModal(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      onCancel: () {
                        setState(() {
                          repeatController = "Everyday";
                        });
                      },
                      onSaved: (weekly, value) {
                        var list = value.toList();
                        if (list.isNotEmpty) {
                          repeatController = "$weekly on ";
                          for (int i = 0; i < list.length; i++) {
                            setState(() {
                              repeatController +=
                                  list[i] + (i != list.length - 1 ? ", " : "");
                            });
                          }
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }
            },
          );
        }),
      ),
    );
  }

  _selectDate() async {
    DateTime tempPickedDate = selectedDate;
    await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text('Done'),
                        onPressed: () {
                          setState(() {
                            selectedDate = tempPickedDate;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                Container(
                  height: 195,
                  child: CupertinoDatePicker(
                    // minimumDate: DateTime.now().subtract(Duration(days: 1)),
                    initialDateTime: selectedDate ?? DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (time) {
                      setState(() {
                        tempPickedDate = time;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 18,
        );
    return GradientBg(
      child: Scaffold(
        appBar: appBarWidget(
          name: "Update Schedule",
          centerTitle: false,
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(Icons.edit),
            // ),
            IconButton(
              onPressed: () {
                final myContext = context;
                showModal(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        "Are you sure want to delete the schedule?",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "CANCEL",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            var body = {
                              "id": widget.taskId,
                            };
                            LoadingProgressDialog()
                                .show(myContext, message: "Deleting");
                            var res = await RestRouteApi(
                                    myContext, ApiPaths.deleteTask)
                                .post(jsonEncode(body));

                            if (res != null) if (res.status
                                    .toString()
                                    .toLowerCase() ==
                                "success") {
                              await myContext
                                  .read<UserProvider>()
                                  .onScheduleChange(myContext);
                              // members.removeAt(index);
                            }
                            LoadingProgressDialog().hide(myContext);
                            Navigator.pop(myContext);
                          },
                          child: Text("DELETE"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: !isLoaded
            ? LoadingIndicator()
            : isFailed
                ? LoadingIndicator(
                    imageUrl: "assets/gif/sad_dog.gif",
                    message: "Data Not Found",
                    textColor: Colors.black,
                  )
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Task Name",
                                    style: style,
                                  ),
                                  field(taskName),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Task Type",
                                    style: style,
                                  ),
                                  field(taskType),
                                ],
                              ),
                            ),
                            PickerComponent(
                              intialTime: localTime,
                              title: "Time",
                              returnTime: (time) {
                                selectedTime = time;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  List<String> list = [
                                    "Everyday",
                                    "Weekday",
                                    "Weekends",
                                    "Weekly" +
                                        " on " +
                                        "${_getDay(DateTime.now().weekday)}",
                                    "Monthly" +
                                        " on " +
                                        (selectedDate != null
                                            ? "${selectedDate.day}${_getSuffix(selectedDate.day)}"
                                            : "${DateTime.now().day}${_getSuffix(DateTime.now().day)}"),
                                    "Do Not Repeat",
                                    "Custom",
                                  ];
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Repeat",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            daysListCustom(list),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    // right: 10,
                                    top: 10,
                                    bottom: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Repeat",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(fontSize: 16),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          repeatController,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: 16,
                                                  color: Color(0xff1A81FE)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            repeatController == "Do Not Repeat"
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      // vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        _selectDate();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            // right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Select Date",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              selectedDate != null
                                                  ? "${selectedDate.toString().substring(0, 10)}"
                                                  : "${DateTime.now().toString().substring(0, 10)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: Color(0xff1A81FE)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Send Reminder To",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Consumer(
                              builder: (BuildContext context, UserProvider uPro,
                                  Widget child) {
                                var userInfo = [
                                  {"id": 'ALL', "name": 'ALL'}
                                ];
                                if (members != null) {
                                  members.forEach((e) {
                                    userInfo.add({
                                      "id": e['person']['_id'],
                                      "name": e['person']['userInfo']['fname'],
                                      "image": e['person']['userInfo']['avatar']
                                    });
                                  });
                                }

                                return MyMultiSelect(
                                  isInitiallySelected: true,
                                  selectedItems: sendReminderTo,
                                  list: userInfo,
                                  onSelected: (List<String> items) {
                                    sendReminderTo = items;
                                  },
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SwitchListTile(
                                value: switchValue,
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = value;
                                  });
                                },
                                title: Text(
                                  "Is Active",
                                  style: style,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add Comments",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: commentController,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: "Add Comments",
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blueAccent)),
                                ),
                                maxLines: null,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RoundRectangleButton(
                          title: "Update Task",
                          onPressed: () async {
                            try {
                              selectedTime = selectedTime ?? "1:00 AM";
                              data["taskname"] = taskName;
                              data["taskType"] = taskType;
                              data["timeArray"] = [
                                getTimeMinuteFromAmPm(selectedTime),
                              ];
                              data["localTimeArray"] = [selectedTime];
                              data["send_reminder_to"] =
                                  sendReminderTo.join(",");
                              data["comment"] = commentController.text;
                              data["isActive"] = switchValue;

                              var utc = DateTime.now();
                              var utcMinute = utc.timeZoneOffset.inMinutes;
                              var repeatType = repeatController;
                              if (repeatType.contains('Weekly')) {
                                const list = [
                                  "Su",
                                  "Mo",
                                  "Tu",
                                  "We",
                                  "Th",
                                  "Fr",
                                  "Sa",
                                ];
                                var days = repeatType.split("on")[1];
                                var mappedNum = days
                                    .split(", ")
                                    .map((e) => list.indexOf(e.trim()))
                                    .toList();
                                repeatType = 'Weekly/${mappedNum.join(",")}';
                              } else if (repeatType.contains('Monthly')) {
                                var days = repeatType.split(" on ")[1];
                                var mappedNum = days.split(", ");
                                repeatType = 'Monthly/${mappedNum.join(",")}';
                              }

                              var postAbleData = {
                                "comment": commentController.text,
                                "isActive": switchValue,
                                "id": widget.taskId,
                                "taskname": data["taskname"],
                                "taskType": data["taskType"],
                                "timeArray": pointer == 6
                                    ? [
                                        getEpoch(selectedDate,
                                            data["localTimeArray"][0])
                                      ]
                                    : data["timeArray"]
                                        .map((e) {
                                          return ((e - utcMinute) < 0
                                                  ? (e - utcMinute) + 1440
                                                  : (e - utcMinute))
                                              .abs();
                                        })
                                        .toList()
                                        .toSet()
                                        .toList(),
                                "localTimeArray":
                                    (data["localTimeArray"] as List)
                                        .toSet()
                                        .toList(),
                                "repeatType": repeatType == 'Do Not Repeat'
                                    ? 'NONE'
                                    : repeatType.toUpperCase(),
                                // "pet": widget.data['pet'],
                                "sendReminderTo": data['send_reminder_to'],
                                "localDate":
                                    DateTime.now().toString().split(" ")[0],
                                "localTime":
                                    DateTime.now().toString().split(" ")[1],
                                "timezone": await FlutterNativeTimezone
                                    .getLocalTimezone(),
                                "dateSelected":
                                    selectedDate.toString().split(" ")[0]
                              };
                              print(postAbleData);
                              loadingIndicator.show(context);
                              var res =
                                  await RestRouteApi(context, ApiPaths.editTask)
                                      .post(jsonEncode(postAbleData));
                              await context
                                  .read<UserProvider>()
                                  .onScheduleChange(context);
                              loadingIndicator.hide(context);
                              if (res != null) {
                                showToast(res.message, context);
                                Future.delayed(Duration(microseconds: 200))
                                    .then((value) => Navigator.pop(context));
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  getRepeatType(repeatType) {
    if (repeatType.contains('Weekly')) {
      const list = [
        "Su",
        "Mo",
        "Tu",
        "We",
        "Th",
        "Fr",
        "Sa",
      ];
      var days = repeatType.split("on")[1];
      var mappedNum =
          days.split(", ").map((e) => list.indexOf(e.trim())).toList();
      repeatType = 'Weekly/${mappedNum.join(",")}';
    } else if (repeatType.contains('Monthly')) {
      var days = repeatType.split(" on ")[1];
      var mappedNum = days.split(", ");
      repeatType = 'Monthly/${mappedNum.join(",")}';
    }
    return repeatType;
  }

  getRepeatTypeFromData(repeatType) {
    if (repeatType.contains('Weekly')) {
      const list = [
        "Su",
        "Mo",
        "Tu",
        "We",
        "Th",
        "Fr",
        "Sa",
      ];
      var days = repeatType.split("/")[1];
      var mappedNum = days.split(",").map((e) => list[int.parse(e)]).toList();
      repeatType = 'Weekly on ${mappedNum.join(", ")}';
    } else if (repeatType.contains('Monthly')) {
      var days = repeatType.split(" on ")[1];
      var mappedNum = days.split(", ");
      repeatType = 'Monthly/${mappedNum.join(",")}';
    }
    return repeatType == 'NONE' ? 'Do Not Repeat' : repeatType;
  }
}
