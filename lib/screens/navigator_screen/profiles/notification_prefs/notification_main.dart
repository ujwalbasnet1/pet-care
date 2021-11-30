import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_create/components/multi_select.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/service/network.dart';
import 'package:pets/service/rest_route_api.dart';
import 'package:pets/theming/common_size.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

// enum NotificationType { both, textMessage, pushNotification }

class NotificationMain extends StatefulWidget {
  @override
  _NotificationMainState createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain> {
  Map<String, dynamic> postableData = {};
  String firstNotify;
  bool isSnooze;
  bool pause;
  var snoozeReminder;
  String secondNotify;
  bool firstSwitchController = false;
  List<String> firstList = [];
  List<String> secondList = [];
  List<String> selectionList = ["Text Message", "Push Notification"];

  List<String> firstSelect = [];
  List<String> secondSelect = [];
  List<String> followUpList = [
    "10 mins",
    "15 mins",
    "20 mins",
    // "30 mins",
    // "45 mins",
    // "60 mins"
  ];
  @override
  void initState() {
    setCurrentScreen(ScreenName.notificationMain);

    updateData();
    super.initState();
  }

  updateData() {
    var uPro = context.read<UserProvider>();
    postableData = uPro.getUserData['data']['userInfo']['preferences'];

    firstSwitchController = postableData['isSnooze'];
    isSnooze = postableData['isSnooze'];
    firstNotify = postableData['first_notify'];
    secondNotify = postableData['second_notify'];
    snoozeReminder = postableData['snoozeReminder'];
    pause = postableData['pause'] ?? false;
    log(selectionList.toString());
    if (firstNotify == "TEXT,PUSH") {
      firstList.addAll(selectionList);
      firstSelect.addAll(["TEXT", "PUSH"]);
    } else if (firstNotify == "PUSH") {
      firstList.add(selectionList[1]);
      firstSelect.add("PUSH");
    } else if (firstNotify == "TEXT") {
      firstList.add(selectionList[0]);
      firstSelect.add("TEXT");
    }
    if (secondNotify == "TEXT,PUSH") {
      secondList.addAll(selectionList);
      secondSelect.addAll(["TEXT", "PUSH"]);
    } else if (secondNotify == "PUSH") {
      secondList.add(selectionList[1]);
      secondSelect.add("PUSH");
    } else if (secondNotify == "TEXT") {
      secondList.add(selectionList[0]);
      secondSelect.add("TEXT");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
            color: Colors.blueAccent,
            context: context,
            name: "Notification Preferences"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1st Notification",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    MultiSelect(
                      list: selectionList,
                      padding: EdgeInsets.zero,
                      selectedItems: firstList,
                      getSelectedItem: (value) {},
                      onPressed: (title, index) {
                        var str = title.split(" ")[0].toUpperCase();
                        if (firstSelect.contains(str)) {
                          firstSelect.remove(str);
                        } else {
                          firstSelect.add(str);
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: firstSwitchController,
                        onChanged: (value) {
                          setState(() {
                            firstSwitchController = value;
                            isSnooze = value;
                          });
                        },
                        title: Text(
                          "Follow up Reminders",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ),
                    firstSwitchController
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Repeat Reminder Duration",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                                CustomPicker(
                                  list: followUpList,
                                  padding: EdgeInsets.zero,
                                  selectedPointer: followUpList
                                      .indexOf("$snoozeReminder mins".trim()),
                                  initiallySelected: true,
                                  onPressed: (title, index) {
                                    snoozeReminder = title.split(" ")[0];
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "2nd Notification",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                                MultiSelect(
                                  list: selectionList,
                                  padding: EdgeInsets.zero,
                                  selectedItems: secondList,
                                  getSelectedItem: (value) {},
                                  onPressed: (title, index) {
                                    var str = title.split(" ")[0].toUpperCase();
                                    if (secondSelect.contains(str)) {
                                      secondSelect.remove(str);
                                    } else {
                                      secondSelect.add(str);
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: pause,
                        onChanged: (value) {
                          setState(() {
                            pause = value;
                          });
                        },
                        title: Text(
                          "Pause Reminders",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 16,
                              ),
                        ),
                        subtitle: Text('Do Not Disturb Mode'),
                      ),
                    ),
                  ],
                ),
              ),
              RoundRectangleButton(
                title: "Save Preferences",
                onPressed: () async {
                  firstNotify = getValue(firstSelect);
                  secondNotify = getValue(secondSelect);
                  postableData['first_notify'] = firstNotify;
                  postableData['isSnooze'] = isSnooze;
                  postableData['snoozeReminder'] = snoozeReminder;
                  postableData['second_notify'] = secondNotify;
                  postableData['pause'] = pause;

                  LoadingProgressDialog().show(context, message: "Updating...");
                  var data =
                      await RestRouteApi(context, ApiPaths.updatePreferences)
                          .post(jsonEncode({"preferences": postableData}));
                  context
                      .read<UserProvider>()
                      .fetchUserInfo(context, force: true);
                  if (data != null) {
                    showToast(data.message, context);
                    Future.delayed(Duration(microseconds: 200))
                        .then((value) => Navigator.pop(context));
                  }
                  LoadingProgressDialog().hide(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getValue(List<String> list) {
    String out = "";
    for (int i = 0; i < list.length; i++) {
      if (i == list.length - 1) {
        out += list[i];
      } else {
        out += list[i];
        out += ",";
      }
    }
    return out;
  }
}

// {
//     "preferences":{

//       "first_notify": "ok",
//       "isSnooze": true,
//       "snoozeReminder": 15,
//       "second_notify": "both"
//     }
// }
