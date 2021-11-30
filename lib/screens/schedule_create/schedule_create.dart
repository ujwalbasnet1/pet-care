import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/skip_dialog.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/contacts/add_contact.dart';
import 'package:pets/screens/schedule_create/components/custom_dialog.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';
import 'package:pets/screens/schedule_create/components/type.dart';
import 'package:pets/screens/schedule_create/tasks/create_task.dart';
import 'package:pets/screens/schedule_create/tasks/meal.dart';
import 'package:pets/screens/schedule_create/tasks/medicine.dart';
import 'package:pets/screens/schedule_create/tasks/notes.dart';
import 'package:pets/screens/schedule_create/tasks/play_time.dart';
import 'package:pets/screens/schedule_create/tasks/supplement.dart';
import 'package:pets/screens/schedule_create/tasks/walk.dart';
import 'package:pets/screens/schedule_create/tasks/water.dart';
import 'package:pets/service/network.dart';
import 'package:pets/theming/common_size.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

import 'components/multi_select.dart';
import 'components/my_multiselect.dart';
import 'components/timer_picker/custom_time_picker.dart';

class ScheduleCreate extends StatefulWidget {
  final int screenIndex;
  final bool isOnBoarding;
  final bool isFromAddPets;
  final bool isFromCreateTask;
  ScheduleCreate(
      {this.screenIndex,
      this.isOnBoarding = false,
      this.isFromAddPets = false,
      this.isFromCreateTask = false});
  @override
  _ScheduleCreateState createState() => _ScheduleCreateState();
}

class _ScheduleCreateState extends State<ScheduleCreate> {
  TextEditingController commentController = TextEditingController();
  final style = TextStyle(
    fontSize: 18,
    color: Colors.blue,
  );
  final initialTime = "1:00 AM";
  LoadingProgressDialog loadingIndicator = new LoadingProgressDialog();
  String repeatController = "Everyday";
  bool isSelected = true;
  ScrollController scrollController = ScrollController();
  var currentTime = DateTime.now();
  DateTime selectedTime;
  int pointer = 0;
  DateTime selectedDate;
  bool showError = false;
  String errorMessage = "";
  bool stripeShow = false;
  ScrollController scheduleScrollController = ScrollController();
  List<String> selectionList = [
    "Meal",
    "Walk",
    "Medicine",
    "Supplement",
    "Water",
    "Play Time",
    "Create Task",
    "Notes",
  ];

  onPressed(int value) {
    setState(() {
      pointer = value;
    });
  }

  List<Widget> mealList = [];

  /// Meal Variables
  Map<String, dynamic> mealData = {
    "pet": {},
    "breakfast_time": "7:30 AM",
    "lunch_time": "3:00 PM",
    "dinner_time": "7:00 PM",
    "date": DateTime.now().toString().substring(0, 10),
    "repeat": "Everyday",
    "send_reminder_to": {},
  };
  String breakfastTime;
  String lunchTime;
  String dinnerTime;

  /// General Data for Walk, Medicine, Supplement, Water, Play Time, Notes
  Map<String, dynamic> data = {
    "pet": {},
    "time": null,
    "date": DateTime.now().toString().substring(0, 10),
    "repeat": "Everyday",
    "send_reminder_to": {},
  };

  /// General Variable
  List<String> sendReminderTo = ['ALL'];
  List<String> selectedPets = ['ALL'];

  /// Medicine Vairable
  String medicineTime;
  String medicineTitle;

  /// Medicine Vairable
  String startTime = "1:00 AM";
  String endTime = "1:00 AM";
  String repeatEvery = "4 hrs";

  /// Medicine Vairable
  String supplementTime;
  String supplementTitle;

  /// Medicine Vairable
  String waterTime;
  String waterTitle;

  /// Medicine Vairable
  String playTime;
  String playTitle;

  /// Medicine Vairable
  String notesTime;
  String notesTitle;

  /// Create Task Variable
  String taskType = "Veterinary";
  String taskName = "Doctor Visit";
  String taskTime = "1:00 AM";

  /// End
  bool isLoading = true;

  @override
  void initState() {
    setCurrentScreen(ScreenName.createSchedule);

    screenInit();
    super.initState();
  }

  skipTaskCreation() async {
    if (widget.isOnBoarding) {
      bool isShowDialog = false;
      loadingIndicator.show(context);
      var data = await RestRouteApi(context, ApiPaths.getTask).get();
      var uPro = context.read<UserProvider>();
      var postAbleData = {
        "repeatType": 'EVERYDAY',
        "pet": uPro.getPetList.map((e) => e['_id']).toList(),
        "sendReminderTo": 'ALL',
        "localDate": DateTime.now().toString().split(" ")[0],
        "localTime": DateTime.now().toString().split(" ")[1],
        "timezone": await FlutterNativeTimezone.getLocalTimezone(),
        "dateSelected": ''
      };
      var utc = DateTime.now();
      var utcMinute = utc.timeZoneOffset.inMinutes;
      loadingIndicator.hide(context);

      if (!data.toString().contains('MEAL')) {
        isShowDialog = true;
        loadingIndicator.show(context);
        postAbleData['taskname'] = 'MEAL REMINDER';
        postAbleData['taskType'] = 'MEAL';
        postAbleData['timeArray'] = [
          getTimeMinuteFromAmPm("7:30 AM"),
          getTimeMinuteFromAmPm("3:00 PM"),
          getTimeMinuteFromAmPm("7:00 PM"),
        ]
            .map((e) {
              return ((e - utcMinute) < 0
                      ? (e - utcMinute) + 1440
                      : (e - utcMinute))
                  .abs();
            })
            .toList()
            .toSet()
            .toList();
        postAbleData['localTimeArray'] = [
          "7:30 AM",
          "3:00 PM",
          "7:00 PM",
        ];
        print(postAbleData);
        var res = await RestRouteApi(context, ApiPaths.createTask)
            .post(jsonEncode(postAbleData));
        loadingIndicator.hide(context);
      }
      if (!data.toString().contains('WALK')) {
        isShowDialog = true;
        loadingIndicator.show(context);
        postAbleData['taskname'] = 'WALK REMINDER';
        postAbleData['taskType'] = 'WALK';
        postAbleData['timeArray'] = [
          getTimeMinuteFromAmPm("7:00 AM"),
          getTimeMinuteFromAmPm("6:00 PM"),
        ]
            .map((e) {
              return ((e - utcMinute) < 0
                      ? (e - utcMinute) + 1440
                      : (e - utcMinute))
                  .abs();
            })
            .toList()
            .toSet()
            .toList();
        postAbleData['localTimeArray'] = [
          "7:00 AM",
          "6:00 PM",
        ];
        print(postAbleData);
        var res = await RestRouteApi(context, ApiPaths.createTask)
            .post(jsonEncode(postAbleData));
        loadingIndicator.hide(context);
      }
      if (isShowDialog) {
        loadingIndicator.show(context);
        await context.read<UserProvider>().onScheduleChange(context);
        loadingIndicator.hide(context);
        await showDialog(
          context: context,
          builder: (context) {
            return SkipDialog();
          },
        );
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddContact(
          isFromAddPets: widget.isFromAddPets,
        ),
      ),
    );
  }

  // Timer _timer;
  // void startTimer() async {
  //   int _start = 3;
  //   scheduleScrollController.animateTo(
  //       scheduleScrollController.position.minScrollExtent,
  //       duration: Duration(milliseconds: 10),
  //       curve: Curves.fastOutSlowIn);
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //           stripeShow = false;
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  Future<void> screenInit() async {
    selectedDate = DateTime.now();
    await context.read<UserProvider>().fetchUserInfo(context, force: false);
    context.read<UserProvider>().selectedPet(0);

    mealHeight = widget.isOnBoarding
        ? 300
        : widget.isFromAddPets
            ? 300
            : 100;
    if (widget.screenIndex == 0) {
      pointer = 0;
    } else if (widget.screenIndex == 1) {
      pointer = 6;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
        }
      });
      repeatController = "Do Not Repeat";
    } else if (widget.screenIndex == 2) {
      pointer = 7;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
        }
      });
    } else {
      pointer = 0;
    }

    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String error) async {
    setState(() {
      showError = true;
      errorMessage = error;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      showError = false;
    });
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
                    // minimumDate: DateTime.now().subtract(Duration(hours: 1)),
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

  double mealHeight;
  double createHeight = 300;
  var nameDropDown;
  @override
  Widget build(BuildContext context) {
    List pageList = [
      Meal(
        isFromCreateTask: widget.isFromCreateTask,
        list: mealList,
        getBreakfastTime: (time) {
          breakfastTime = time;
        },
        getLunchTime: (time) {
          lunchTime = time;
        },
        getDinnerTime: (time) {
          dinnerTime = time;
        },
        onAdd: (list) {
          print(list);
          setState(() {
            mealHeight += 100;
          });
        },
        onRemove: (list) {
          print(list);
          setState(() {
            mealHeight -= 100;
          });
        },
      ),
      Walk(
        getEndTime: (time) {
          endTime = time;
        },
        getRepeats: (repeat) {
          repeatEvery = repeat;
        },
        getStartTime: (time) {
          startTime = time;
        },
      ),
      Medicine(
        getTime: (time) {
          medicineTime = time;
        },
        getTitle: (title) {
          medicineTitle = title;
        },
      ),
      Supplement(
        getTime: (time) {
          supplementTime = time;
        },
        getTitle: (title) {
          supplementTitle = title;
        },
      ),
      Water(
        getTime: (time) {
          waterTime = time;
        },
        getTitle: (title) {
          waterTitle = title;
        },
      ),
      PlayTime(
        getTime: (time) {
          playTime = time;
        },
        getTitle: (title) {
          playTitle = title;
        },
      ),
      CreateTask(
        getTaskType: (type) {
          taskType = type;
          setState(() {
            createHeight = 300;
          });
        },
        getTaskName: (name) {
          taskName = name;
          // if (taskName.toLowerCase() == "others") {
          //   setState(() {
          //     createHeight = 350;
          //   });
          // } else {
          //   setState(() {
          //     createHeight = 300;
          //   });
          // }
        },
        getTime: (time) {
          taskTime = time;
        },
      ),
      // Notes(
      //   getTime: (time) {
      //     notesTime = time;
      //   },
      //   getTitle: (title) {
      //     notesTitle = title;
      //   },
      // ),
    ];
    List<Widget> items = [
      CircleType(
        self: 0,
        pointer: pointer,
        title: "Meal",
        imageUrl: getImageAssetUrl(ImageUrlType.meal),
        borderColor: Colors.orange,
        selectedColor: Colors.indigo[900],
        unSelectedColor: Colors.indigo[400],
        onPressed: (value) {
          setState(() {
            repeatController = "Everyday";
            mealHeight = widget.isOnBoarding
                ? 300
                : widget.isFromAddPets
                    ? 300
                    : 100;
          });
          onPressed(0);
        },
      ),
      SizedBox(
        width: 20,
      ),
      CircleType(
        self: 1,
        pointer: pointer,
        title: "Walk",
        imageUrl: getImageAssetUrl(ImageUrlType.walk),
        borderColor: Colors.orange[300],
        selectedColor: Colors.lightBlue[600],
        unSelectedColor: Colors.lightBlue[200],
        onPressed: (value) {
          setState(() {
            repeatController = "Everyday";
            mealHeight = 300;
          });
          onPressed(1);
        },
      ),
      SizedBox(
        width: 20,
      ),
      CircleType(
        self: 2,
        pointer: pointer,
        title: "Medicine",
        imageUrl: getImageAssetUrl(ImageUrlType.medicine),
        borderColor: Colors.red[300],
        selectedColor: Colors.yellow[800],
        unSelectedColor: Colors.yellow[200],
        onPressed: (value) {
          setState(() {
            repeatController = "Everyday";
          });
          onPressed(2);
        },
      ),
      SizedBox(
        width: 20,
      ),
      CircleType(
        self: 3,
        pointer: pointer,
        title: "Supplement",
        imageUrl: getImageAssetUrl(ImageUrlType.supplement),
        borderColor: Colors.orange[300],
        selectedColor: Colors.blueAccent[700],
        unSelectedColor: Colors.blueAccent,
        onPressed: (value) {
          onPressed(3);
        },
      ),
      SizedBox(
        width: 20,
      ),
      CircleType(
        self: 4,
        pointer: pointer,
        title: "Water",
        imageUrl: getImageAssetUrl(ImageUrlType.water),
        borderColor: Colors.orange[300],
        selectedColor: Colors.blueAccent[700],
        unSelectedColor: Colors.blueAccent,
        onPressed: (value) {
          setState(() {
            repeatController = "Everyday";
          });
          onPressed(4);
        },
      ),
      SizedBox(
        width: 20,
      ),
      CircleType(
        self: 5,
        pointer: pointer,
        title: "Play Time",
        imageUrl: getImageAssetUrl(ImageUrlType.playTime),
        borderColor: Colors.orange[300],
        selectedColor: Colors.blueAccent[700],
        unSelectedColor: Colors.blueAccent,
        onPressed: (value) {
          setState(() {
            repeatController = "Everyday";
          });
          onPressed(5);
        },
      ),
      SizedBox(
        width: 20,
      ),
      CircleType(
        self: 6,
        pointer: pointer,
        title: "Create Task",
        imageUrl: getImageAssetUrl(ImageUrlType.createTask),
        borderColor: Colors.orange[300],
        selectedColor: Colors.blueAccent[700],
        unSelectedColor: Colors.blueAccent,
        onPressed: (value) {
          setState(() {
            repeatController = "Do Not Repeat";
            createHeight = 300;
          });
          onPressed(6);
        },
      ),
      // SizedBox(
      //   width: 20,
      // ),
      // CircleType(
      //   self: 7,
      //   pointer: pointer,
      //   title: "Notes",
      //   imageUrl: getImageAssetUrl(ImageUrlType.notes),
      //   borderColor: Colors.orange[300],
      //   selectedColor: Colors.blueAccent[700],
      //   unSelectedColor: Colors.blueAccent,
      //   onPressed: (value) {
      //     setState(() {
      //       repeatController = "Everyday";
      //     });
      //     onPressed(7);
      //   },
      // ),
    ];

    return GradientBg(
      child: WillPopScope(
        onWillPop: () async {
          if (widget.isFromAddPets) {
            pushReplacement(context, BottomNavigation());
          }
          return true;
        },
        child: Scaffold(
          appBar: appBarWidget(
            name: "Create Schedule",
            actions: [
              widget.isFromCreateTask
                  ? Container()
                  : FlatButton(
                      onPressed: () => skipTaskCreation(),
                      child: Text(
                        "SKIP",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                      ),
                    )
            ],
            centerTitle: false,
          ),
          backgroundColor: Colors.transparent,
          body: isLoading
              ? LoadingIndicator()
              : SingleChildScrollView(
                  controller: scheduleScrollController,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: items,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select Pet",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                            ),
                            // InkWell(
                            //   child: Text("Select All"),
                            //   onTap: () {},
                            // ),
                          ],
                        ),
                      ),
                      Selector(
                        shouldRebuild: (_, __) => selectedPets.length == 0,
                        selector: (_, UserProvider uPro) => uPro.getPetList,
                        builder:
                            (BuildContext context, petInfoList, Widget child) {
                          // List petInfoList = petList;

                          var petList = [
                            {"id": 'ALL', "name": 'ALL'}
                          ];
                          if (petInfoList != null) {
                            petInfoList.forEach((e) {
                              petList.add({
                                "id": e['_id'],
                                "name": e['name'],
                                "image": e['image']
                              });
                            });
                          }

                          if (selectedPets.contains('ALL')) {
                            selectedPets =
                                petList.map<String>((e) => e['id']).toList();
                          }

                          return CustomPicker(
                            selectedPointer: 0,
                            initiallySelected: true,
                            // selectedItems: selectedPets,
                            list:
                                petList.map<String>((e) => e['name']).toList(),
                            imageUrls:
                                petList.map<String>((e) => e['image']).toList(),
                            onPressed: (value, index) {
                              selectedPets = [petList[index]['id']];
                              if (index == 0) {
                                selectedPets = petList
                                    .map<String>((e) => e['id'])
                                    .toList();
                              }
                              context.read<UserProvider>().selectedPet(index);
                            },
                          );
                        },
                      ),

                      Container(
                        height: (pointer == 0 || pointer == 1
                            ? mealHeight
                            : (pointer == 6 ? createHeight : 170)),
                        // height: (pointer == 0 || pointer == 1 || pointer == 6)
                        //     ? widget.isFromCreateTask
                        //         ? 100
                        //         : 320
                        //     : 170,
                        child: PageView(
                          children: [
                            pageList[pointer],
                          ],
                        ),
                      ),
                      // ),
                      pointer != 7
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    // vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: repeatHandler,
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
                              ],
                            )
                          : Container(),
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
                                            ? "${selectedDate.toString().split(" ")[0]}"
                                            : "${DateTime.now().toString().split(" ")[0]}",
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
                      pointer != 7
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
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
                                      // InkWell(
                                      //   child: Text("Select All"),
                                      //   onTap: () {},
                                      // ),
                                    ],
                                  ),
                                ),
                                Consumer(
                                  builder: (BuildContext context,
                                      UserProvider uPro, Widget child) {
                                    sendReminderTo = [];
                                    var userInfo = [
                                      {"id": 'ALL', "name": 'ALL'}
                                    ];
                                    sendReminderTo = userInfo
                                        .map<String>((e) => e['id'])
                                        .toList();
                                    var members = (uPro.getMembersListByPet);
                                    if (members != null) {
                                      members.forEach((e) {
                                        userInfo.add({
                                          "id": e['id'],
                                          "name": e['name'],
                                          "image": e['image']
                                        });
                                      });
                                    }

                                    return FutureBuilder(
                                      future: Future.delayed(
                                          Duration(milliseconds: 100)),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        return snapshot.connectionState ==
                                                ConnectionState.done
                                            ? MyMultiSelect(
                                                selectedItems: sendReminderTo,
                                                list: userInfo,
                                                onSelected:
                                                    (List<String> items) {
                                                  sendReminderTo = items;
                                                  print(items);
                                                },
                                              )
                                            : Container(
                                                height: 40,
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                      },
                                    );
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              borderSide: BorderSide(
                                                  color: Colors.blueAccent)),
                                        ),
                                        maxLines: null,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : Container(),
                      showError
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Center(
                                child: Text(
                                  "$errorMessage",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(color: Colors.redAccent),
                                ),
                              ),
                            )
                          : Container(),
                      pointer != 7
                          ? RoundRectangleButton(
                              onPressed: onScheduleAddHandler,
                              title:
                                  "Add ${pointer != 6 ? selectionList[pointer] : "Task"} Schedules",
                            )
                          : Container(),
                    ],
                  ),
                ),
        ),
      ),
    );
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
    }
    return result;
  }

  void showSelectorModals() {
    showModal(
      context: context,
      builder: (context) {
        return CustomDialog(
          onCancel: () {},
          onSaved: (weekly, value) {
            var list = value.toList();
            if (list.isNotEmpty) {
              repeatController = "$weekly on ";
              for (int i = 0; i < list.length; i++) {
                repeatController +=
                    list[i] + (i != list.length - 1 ? ", " : "");
              }
              setState(() {});
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  onScheduleAddHandler() async {
    // setState(() {
    //   stripeShow = true;
    // });
    // startTimer();

    try {
      if (selectedPets.isEmpty || sendReminderTo.isEmpty) {
        showToast("Please select Pets and People to send remidner", context);
        return;
      }
      selectedPets.remove("ALL");
      // sendReminderTo.remove("ALL");

      data["taskname"] = "${selectionList[pointer]} REMINDER".toUpperCase();
      data["taskType"] = "${selectionList[pointer]}".toUpperCase();
      data["pet"] = selectedPets.isEmpty ? {"ALL"} : selectedPets;
      data["date"] = selectedDate != null
          ? "${selectedDate.toString().split(" ")[0]}"
          : null;
      data["send_reminder_to"] =
          sendReminderTo.isEmpty ? ["ALL"].join(",") : sendReminderTo.join(",");
      data["comment"] = commentController.text;

      if (pointer == 0) {
        if (widget.isFromCreateTask) {
          data["timeArray"] = [
            getTimeMinuteFromAmPm(breakfastTime),
          ];
          data["localTimeArray"] = [
            breakfastTime ?? initialTime,
          ];
        } else {
          data["timeArray"] = [
            getTimeMinuteFromAmPm(breakfastTime),
            getTimeMinuteFromAmPm(lunchTime),
            getTimeMinuteFromAmPm(dinnerTime),
          ];
          data["localTimeArray"] = [
            breakfastTime ?? initialTime,
            lunchTime ?? initialTime,
            dinnerTime ?? initialTime,
          ];
        }

        data["repeat"] = repeatController;
        data["comment"] = commentController.text;
      } else if (pointer == 1) {
        int repeatMin =
            repeatEvery == null ? 0 : int.parse(repeatEvery.split(" ")[0]) * 60;

        int srtMin = getTimeMinuteFromAmPm(startTime);
        int endMin = getTimeMinuteFromAmPm(endTime);

        data["timeArray"] = [srtMin];
        data["localTimeArray"] = [
          startTime,
        ];

        if (repeatMin < (endMin - srtMin)) {
          List<int> intBetTime = getInBetweenTime(srtMin, endMin, repeatMin);
          data["timeArray"].addAll(intBetTime);

          List<String> localInTime = intBetTime.map((e) {
            var aMpM = e > 720 ? "PM" : "AM";
            var time = (e > 720 ? (e - 720) / 60 : e / 60).toString();
            var minute = (60 * double.parse('0.${time.split('.')[1]}'))
                .floor()
                .toString();
            return "${time.split('.')[0]}:${twoDigit(minute)} $aMpM";
          }).toList();
          data["localTimeArray"].addAll(localInTime);
        }

        if (startTime != endTime) {
          data["timeArray"].add(endMin);
          data["localTimeArray"].add(endTime);
        }
      } else if (pointer == 2) {
        data["timeArray"] = [
          getTimeMinuteFromAmPm(medicineTime),
        ];
        data["localTimeArray"] = [
          medicineTime ?? initialTime,
        ];
      } else if (pointer == 3) {
        data["timeArray"] = [
          getTimeMinuteFromAmPm(supplementTime),
        ];
        data["localTimeArray"] = [
          supplementTime ?? initialTime,
        ];
      } else if (pointer == 4) {
        data["timeArray"] = [
          getTimeMinuteFromAmPm(waterTime),
        ];
        data["localTimeArray"] = [
          waterTime ?? initialTime,
        ];
      } else if (pointer == 5) {
        data["timeArray"] = [
          getTimeMinuteFromAmPm(playTime),
        ];
        data["localTimeArray"] = [
          playTime ?? initialTime,
        ];
      } else if (pointer == 6) {
        data["taskType"] = (taskType ?? "Veterinary").toUpperCase();
        data["taskname"] = taskName + " Reminder";
        if (taskName == null) {
          showToast("Please select a valid task name", context);
        }
        data["timeArray"] = [
          getTimeMinuteFromAmPm(taskTime),
        ];
        data["localTimeArray"] = [
          taskTime ?? initialTime,
        ];
      } else if (pointer == 7) {
        data["time"] = notesTime;
        data["supplement_title"] = notesTitle;
      }

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
        var mappedNum =
            days.split(", ").map((e) => list.indexOf(e.trim())).toList();
        repeatType = 'Weekly/${mappedNum.join(",")}';
      } else if (repeatType.contains('Monthly')) {
        var days = repeatType.split(" on ")[1];
        var mappedNum = days.split(", ");
        repeatType = 'Monthly/${mappedNum.join(",")}';
      }
      data['pet'].remove("ALL");
      var postAbleData = {
        "repeat": repeatController,
        "comment": commentController.text,
        "taskname": data["taskname"],
        "taskType": data["taskType"],
        "timeArray": pointer == 6
            ? [getEpoch(selectedDate, data["localTimeArray"][0])]
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
        "localTimeArray": (data["localTimeArray"] as List).toSet().toList(),
        "repeatType":
            repeatType == 'Do Not Repeat' ? 'NONE' : repeatType.toUpperCase(),
        "pet": data['pet'],
        "sendReminderTo": data['send_reminder_to'],
        "localDate": DateTime.now().toString().split(" ")[0],
        "localTime": DateTime.now().toString().split(" ")[1],
        "timezone": await FlutterNativeTimezone.getLocalTimezone(),
        "dateSelected": data['date'],
        "isOnboarding": widget.isOnBoarding,
      };

      print(postAbleData);
      loadingIndicator.show(context);
      logEvent(data["taskType"], isEvent: true);
      var res = await RestRouteApi(context, ApiPaths.createTask)
          .post(jsonEncode(postAbleData));
      await context.read<UserProvider>().onScheduleChange(context);
      loadingIndicator.hide(context);
      if (res != null) {
        showToast(res.message, context);
        Future.delayed(Duration(microseconds: 200)).then((value) async {
          if (widget.isOnBoarding) {
            if (pointer < 2) {
              if (pointer == 1) {
                var ret = await showConfirmationDialog(context, "");
                if (ret != null) {
                  if (ret) {
                    openScreen(
                        context,
                        AddContact(
                          isFromAddPets: widget.isFromAddPets,
                        ));

                    return;
                  }
                }
              }
              int cPointer = pointer + 1;
              onPressed(cPointer);
            }
          }
        });
      }
    } catch (e) {
      // showToast("Please Select Pets and persons to send reminder",
      //     context);
      // showToast("Select persons to send reminder", context);
      // showToast("Please Select All fields", context);
      print(e);
    }
  }

  void repeatHandler() {
    List<String> list = [
      "Everyday",
      "Weekday",
      "Weekends",
      "Weekly" + " on " + "${_getDay(DateTime.now().weekday)}",
      "Monthly" +
          " on " +
          (selectedDate != null
              ? "${selectedDate.day}"
              : "${DateTime.now().day}"),
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
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Repeat",
                      style: Theme.of(context).textTheme.headline6,
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
              Container(
                child: Column(
                  children: List.generate(list.length, (index) {
                    return ListTile(
                        title: Text(list[index]),
                        onTap: () {
                          Navigator.of(context).pop();
                          if (list[index].toLowerCase() != "custom") {
                            setState(
                              () {
                                repeatController = list[index];
                              },
                            );
                          } else {
                            showSelectorModals();
                          }
                        });
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

showConfirmationDialog(BuildContext context, message) async {
  Widget doneButton = FlatButton(
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        "Continue",
      ),
    ),
    onPressed: () {
      Navigator.pop(context, false);
    },
  );
  Widget backButton = FlatButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: blueClassicColor,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        "Skip",
        style: TextStyle(color: Colors.white),
      ),
    ),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    // title: Text(
    //   "Task Confirmation",
    //   style: TextStyle(color: blueClassicColor),
    // ),
    content: Text(
      "Do You want to continuing adding more Task/Schedules?",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      doneButton,
      backButton,
    ],
  );

  // show the dialog
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
