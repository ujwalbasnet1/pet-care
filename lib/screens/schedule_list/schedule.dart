import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_list/schedule_component.dart';
import 'package:pets/screens/schedule_list/tab_bar.dart';
import 'package:pets/screens/schedule_list/update_schedule.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;

  @override
  void initState() {
    super.initState();
    setCurrentScreen(ScreenName.scheduleMain);
    _selectedDay = _focusedDay;
    if (mounted) getTaskList(force: false);
  }

  @override
  void dispose() {
    // _selectedEvents.dispose();

    super.dispose();
  }

  getTaskList({force: false}) async {
    await context.read<UserProvider>().fetchAllPetTasks(context, force: force);
    return true;
  }

  List<Event> _getEventsForDay(DateTime day, data) {
    List<String> events = [];

    for (var item in data) {
      if (item['repeatType'].toString().toLowerCase() == 'everyday') {
        events.add(item['taskType']);
      } else if (item['repeatType'].toString().toLowerCase() == 'weekday') {
        if (day.weekday < 6) {
          events.add(item['taskType']);
        }
      } else if (item['repeatType'].toString().toLowerCase() == 'weekends') {
        if (day.weekday > 5) {
          events.add(item['taskType']);
        }
      } else if (item['repeatType']
          .toString()
          .toLowerCase()
          .contains('weekly')) {
        var days = item['repeatType'].split("/")[1];

        for (var weekday in days.split(",")) {
          if (day.weekday == int.parse(weekday) + 1) {
            events.add(item['taskType']);
          }
        }
      } else if (item['repeatType'].toString().toLowerCase().contains('none')) {
        try {
          if (DateTime.parse(item['dateSelected']).toString().split(" ")[0] ==
              day.toString().split(" ")[0]) {
            events.add(item['taskType']);
          }
        } catch (e) {
          print(e);
        }
      }
    }

    return events.toSet().toList().map((e) => Event(e)).toList();
  }

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);

  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  Widget screen({taskDetails}) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, time, list) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(list.length, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 0.15),
                      width: 50,
                      child: Center(
                        child: Text(
                          "${list[index].title}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 8,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    );
                  }),
                );
              }),
              eventLoader: (DateTime dt) => _getEventsForDay(dt, taskDetails),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
                markerSize: 8,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
              child: Text(
                "All Tasks",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: 18,
                    ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: taskDetails.length,
              itemBuilder: (context, index) {
                var data = taskDetails[index];
                var month = getMonthDateFromType(data)['month'];
                var date = getMonthDateFromType(data)['date'];

                return ScheduleComponents(
                  // imageUrl:,
                  // subTitleDueTime:,
                  isExpired: data['expired'] &&
                      (data['repeatType'].toString().toLowerCase() == 'none'),
                  timeUnit: data['actualTaskMinuteNumber'],
                  switchValue: data['isActive'],
                  taskTitle: data['taskname'],
                  taskType: data['taskType'],
                  time: data['localTime'], //tst
                  repeatType: data['repeatType'] == 'EVERYDAY'
                      ? ""
                      : data['repeatType'] == 'NONE'
                          ? "${data['dateSelected']}"
                          : "${getMonthDateFromType(data)['date']}",
                  onEdit: () {
                    if (context.read<UserProvider>().getUserInfo.isMinor) {
                      showToast(
                          'You are Minor. A Minor cannot perform this Task.',
                          context);
                      return;
                    }
                    openScreen(context, UpdateSchedule(taskId: data['_id']));
                  },
                  onChanged: (value) async {
                    if (context.read<UserProvider>().getUserInfo.isMinor) {
                      showToast(
                          'You are Minor. A Minor cannot perform this Task.',
                          context);
                      return;
                    }
                    LoadingProgressDialog()
                        .show(context, message: "Updating Status");
                    var d = await RestRouteApi(context, ApiPaths.toggleTask)
                        .post(jsonEncode({
                      "tasks": [data['_id']],
                      "value": value
                    }));
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
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  bool switchValue = true;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, UserProvider uPro, Widget child) {
        var petList = uPro.getAllPetTasks;

        return petList == null
            ? LoadingIndicator()
            : petList == false
                ? LoadingIndicator(
                    imageUrl: "assets/gif/sad_dog.gif",
                    message: "Data Not Found",
                    textColor: Colors.black)
                : TabBarGeneric(
                    appBarTitle: "Schedules",
                    isScrollable: true,
                    titles: (petList ?? []).map<String>((e) {
                      return e['name'] as String;
                    }).toList(),
                    screens: petList == null
                        ? [LoadingIndicator()]
                        : petList == false || petList.length == 0
                            ? [
                                LoadingIndicator(
                                    imageUrl: "assets/gif/sad_dog.gif",
                                    message: "Data Not Found",
                                    textColor: Colors.black)
                              ]
                            : List.generate(
                                petList.length,
                                (index) {
                                  return screen(
                                      taskDetails: petList[index]['task']);
                                },
                              ).toList(),
                  );
      },
    );
  }
}
