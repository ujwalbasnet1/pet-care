import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/event_screens/event_main.dart';
import 'package:pets/screens/schedule_create/schedule_create.dart';
import 'package:pets/screens/schedule_list/update_schedule.dart';
import 'package:pets/service/network.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'daily_activity_card.dart';
import 'package:pets/screens/schedule/schedule_main.dart';
import 'appoinment_card.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

class HomeTask extends StatelessWidget {
  final tasks;
  final petInfoData;

  const HomeTask({Key key, this.tasks, this.petInfoData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String image = "assets/images/bdog.png";
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    var images = {
      "walk": "assets/images/updog2.png",
      "meal": "assets/images/updog1.png",
    };
    var dailyCare = [];
    var fullDayEvent = [];
    for (var i = 0; i < tasks.length; i++) {
      var task = tasks[i];
      if (task['expired'] &&
          task['repeatType'].toString().toLowerCase() == 'none') continue;
      var typeTask = {
        "repeat": task['repeat'],
        "isActive": task['isActive'],
        "repeatType": task["repeatType"],
        "name": task['taskname'],
        "type": task['taskType'],
        "localTime": [task['localTime']],
        "id": [task['_id']],
        "taskDate": task['localDate'],
        "dateSelected": task['dateSelected']
      };

      var types = [
        "VETERINARY",
        "GROOMING",
        "CLEANING",
        "SHOPPING",
        "TRAINING",
        "MEASUREMENTS",
        "OTHERS",
      ];
      // DAILY CARE", "FULL DAY EVENT
      if (types.indexOf(task['taskType'].toString().toUpperCase()) == -1) {
        if (dailyCare.length != 0) {
          var pos = dailyCare.firstWhere(
              (element) => element['type'] == task['type'],
              orElse: () => "false");
          if (pos.toString() != "false") {
            pos['localTime'].add(task['localTime']);
            pos['id'].add(task['_id']);
          } else {
            dailyCare.add(typeTask);
          }
        } else {
          dailyCare.add(typeTask);
        }
      } else {
        if (fullDayEvent.length != 0) {
          // var pos = fullDayEvent.firstWhere(
          //     (element) => element['type'] == task['type'],
          //     orElse: () => "false");
          // if (pos.toString() != "false") {
          //   pos['localTime'].add(task['localTime']);
          // } else {
          fullDayEvent.add(typeTask);
          // }
        } else {
          fullDayEvent.add(typeTask);
        }
      }
    }

    _section({title = "Appointments"}) {
      return Container(
        padding: EdgeInsets.only(top: 18, bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: greyColor,
                fontSize: 14,
              ),
        ),
      );
    }

    // ignore: unused_element
    _appointSection(title) {
      return DottedBorder(
        dashPattern: [3, 1],
        child: Container(
          // decoration: BoxDecoration(border: Border.all()),
          width: double.infinity,
          height: 60,
          color: Colors.white,
          child: Center(
              child: Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(title: "Upcoming Appointments"),
            fullDayEvent.length > 0
                ? Column(
                    children: fullDayEvent.map((e) {
                    var month = getMonthDateFromType(e)['month'];
                    var date = getMonthDateFromType(e)['date'];

                    return InkWell(
                      onTap: () {
                        // openScreen(
                        //     context,
                        //     EventMain(
                        //         tasks: tasks,
                        //         fullDayEvent: fullDayEvent,
                        //         petInfoData: petInfoData));
                      },
                      child: AppointmentCard(
                        height: 20,
                        width: width,
                        month: month,
                        date: date, //(now.day + index).toString(),
                        title: e['name'] ?? "",
                      ),
                    );
                  }).toList())
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 50,
                    child: InkWell(
                      splashColor: Colors.grey[500],
                      onTap: () {
                        if (context.read<UserProvider>().getUserInfo.isMinor) {
                          showToast(
                              'You are Minor. A Minor cannot perform this Task.',
                              context);
                          return;
                        }
                        openScreen(
                            context,
                            ScheduleCreate(
                              screenIndex: 1,
                              isFromCreateTask: true,
                            ));
                      },
                      child: Center(
                        child: Text(
                          "Plan your first appointment",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Color(0xff080040),
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ),
                  ),
            _section(title: "Daily Activity"),
            dailyCare.length > 0
                ? Column(
                    children: dailyCare.map((e) {
                    return InkWell(
                      onTap: () {
                        if (context.read<UserProvider>().getUserInfo.isMinor) {
                          showToast(
                              'You are Minor. A Minor cannot perform this Task.',
                              context);
                          return;
                        }
                        openScreen(context, UpdateSchedule(taskId: e['id'][0]));
                      },
                      child: DailyActivityCard(
                          initialSwitchValue: e['isActive'],
                          repeatType: e['repeatType'] == 'EVERYDAY'
                              ? ""
                              : e['repeatType'] == 'NONE'
                                  ? "( ${e['dateSelected']} )"
                                  : "( ${getMonthDateFromType(e)['date']} )",
                          onSettingClicks: () {
                            if (context
                                .read<UserProvider>()
                                .getUserInfo
                                .isMinor) {
                              showToast(
                                  'You are Minor. A Minor cannot perform this Task.',
                                  context);
                              return;
                            }
                            openScreen(
                                context, UpdateSchedule(taskId: e['id'][0]));
                          },
                          onChanged: (value) async {
                            if (context
                                .read<UserProvider>()
                                .getUserInfo
                                .isMinor) {
                              showToast(
                                  'You are Minor. A Minor cannot perform this Task.',
                                  context);
                              return;
                            }
                            LoadingProgressDialog()
                                .show(context, message: "Updating Status");
                            var d =
                                await RestRouteApi(context, ApiPaths.toggleTask)
                                    .post(jsonEncode(
                                        {"tasks": e['id'], "value": value}));

                            if (d != null) {
                              if (d.message != 'error') {
                                showToast(d.message, context);
                              }
                            }

                            await context
                                .read<UserProvider>()
                                .onScheduleChange(context);
                            LoadingProgressDialog().hide(context);
                          },
                          image: getAssetImage(e['type']) ?? image,
                          width: width,
                          name: e['name'] ?? "",
                          row: e["localTime"]
                              .map<String>((e) => e.toString())
                              .toList()),
                    );
                  }).toList())
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 50,
                    child: InkWell(
                      splashColor: Colors.grey[500],
                      onTap: () {
                        if (context.read<UserProvider>().getUserInfo.isMinor) {
                          showToast(
                              'You are Minor. A Minor cannot perform this Task.',
                              context);
                          return;
                        }
                        openScreen(
                            context,
                            ScheduleCreate(
                              screenIndex: 0,
                              isFromCreateTask: true,
                            ));
                      },
                      child: Center(
                        child: Text(
                          "Add Your First Schedule",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Color(0xff080040),
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ),
                  ),
            // : InkWell(
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (BuildContext context) =>
            //               ScheduleMain()));
            // },
            //     child: Image.asset(
            //       "assets/images/daily_appointment.png",
            //       width: MediaQuery.of(context).size.width,
            //       fit: BoxFit.fill,
            //     ),
            //     // Image.asset("assets/images/schedule.jpg")
            //   ),
          ],
        );
      },
    );
  }
}
