import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pets/utils/app_utils.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import '../schedule/custom_activity.dart';
import 'package:pets/common/gradient_bg.dart';

class EventMain extends StatefulWidget {
  final tasks;
  final fullDayEvent;
  final petInfoData;

  const EventMain({Key key, this.tasks, this.fullDayEvent, this.petInfoData})
      : super(key: key);
  @override
  _EventMainState createState() => _EventMainState();
}

class _EventMainState extends State<EventMain> {
  DateTime _currentDate;

  // ignore: unused_field
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  EventList<Event> _markedDateMap = new EventList<Event>(events: {});

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

  @override
  void initState() {
    setCurrentScreen(ScreenName.eventMain);
    _currentDate = new DateTime.now();
    createMarkeEvent();
    super.initState();
  }

  createMarkeEvent() {
    int length = widget.fullDayEvent.length;
    for (int i = 0; i < length; i++) {
      var element = widget.fullDayEvent[i];
      DateTime dt = DateTime(element['taskDate']);
      var event = new Event(
        date: new DateTime(2019, 2, 10),
        title: element['name'],
        // icon: _eventIcon,
        dot: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          color: Colors.red,
          height: 5.0,
          width: 5.0,
        ),
      );
      _markedDateMap.add(dt, event);
    }
  }

  @override
  Widget build(BuildContext context) {
    var pastEvents = [];
    var upcomingEvents = [];

    _taskInfo(width) {
      int length = widget.fullDayEvent.length;
      for (int i = 0; i < length; i++) {
        var element = widget.fullDayEvent[i];

        DateTime dt = getTimeString(int.parse(element['taskDate']));
        if (dt.compareTo(DateTime.now()) < 0) {
          pastEvents.add(element);
        } else {
          upcomingEvents.add(element);
        }
      }
      _buttonCard({text = "", @required color, child}) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  color[200],
                  color[100],
                ]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child ??
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          ),
        );
      }

      _eventCard(title, subTitle, color, {color2, data}) {
        return Column(
          children: [
            ListTile(
              leading: Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                height: 10.0,
                width: 10.0,
              ),
              title: Text(title),
              subtitle: Text(subTitle),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buttonCard(text: "15:00", color: color),
                  SizedBox(
                    width: 5,
                  ),
                  _buttonCard(
                      text: "15:00",
                      color: color2 ?? color,
                      child: InkWell(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onTap: () {
                            // openScreen(context, CustomActivity())
                          }))
                ],
              ),
            ),
            Divider(
              height: 2,
            )
          ],
        );
      }

      _section({title = "Appointments"}) {
        return Container(
          padding: EdgeInsets.only(top: 12, bottom: 2, left: 15),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section(title: "Past Events"),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pastEvents.map<Widget>((e) {
                DateTime dt = getTimeString(int.parse(e['taskDate']));
                return _eventCard(
                    e['name'] ?? "",
                    "${months[dt.month - 1].toString()} ${dt.day.toString()}",
                    Colors.blueGrey,
                    data: e);
              }).toList()),
          _section(title: "Upcoming Events"),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: upcomingEvents.map<Widget>((e) {
                DateTime dt = getTimeString(int.parse(e['taskDate']));
                return _eventCard(
                    e['name'] ?? "",
                    "${months[dt.month - 1].toString()} ${dt.day.toString()}",
                    Colors.pinkAccent,
                    color2: Colors.blueAccent,
                    data: e);
              }).toList())
        ],
      );
    }

    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Appoinments"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: CalendarCarousel(
                            weekDayBackgroundColor: Colors.transparent,
                            markedDatesMap: _markedDateMap,
                            daysHaveCircularBorder: false,
                            selectedDateTime: _currentDate,
                            customGridViewPhysics:
                                NeverScrollableScrollPhysics(),
                            height: 420.0,
                            onDayPressed: (DateTime date, List<Event> events) {
                              this.setState(() => _currentDate = date);

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(date
                                              .toString()
                                              .split(" ")[0]
                                              .toString()
                                              .split("-")
                                              .reversed
                                              .join("-")),
                                          Divider()
                                        ],
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: events
                                          .map((e) => Container(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    // mainAxisSize:
                                                    //     MainAxisSize.min,
                                                    children: [
                                                      Text(e.date
                                                          .toString()
                                                          .split(" ")[0]
                                                          .toString()),
                                                      Text(
                                                        " : ${e.title}",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _taskInfo(width),
                        ),
                        // _currentDate == null ? Container() : _formBuilder(),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                  RoundRectangleButton(
                    onPressed: () {
                      var screen = CustomActivity(scheduleType: {
                        "type": "custom",
                        "title": "Custom Activity"
                      }, petId: widget.petInfoData['_id']);
                      openScreen(context, screen);
                    },
                    title: "Add Custom Task",
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
