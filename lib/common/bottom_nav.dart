import 'dart:async';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/schedule_create.dart';
import 'package:pets/screens/schedule_create/tasks/notes_tabs.dart';
import 'package:pets/screens/schedule_list/schedule.dart';
import 'package:pets/screens/story/explore/shorts_main.dart';
import 'package:pets/screens/story/gif_stories.dart';
import 'package:pets/screens/story/story_creator/camera_view/camera_view.dart';
import 'package:pets/service/app_pushs.dart';
import 'package:pets/service/userid_store.dart';
import 'package:pets/screens/caretaker/caretaker_main.dart';
import 'package:pets/screens/navigator_screen/home/home_main.dart';
import 'package:pets/screens/profile/profile_main.dart';
import 'package:pets/utils/app_utils.dart';
import 'colors.dart';
import 'userid.dart';
import 'package:pets/screens/schedule/schedule_main.dart';
import 'gradient_bg.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/utils/static_variables.dart';
import 'package:pets/service/network.dart';
import 'dart:convert';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/common/join_group.dart';
import 'package:pets/common/coachmark_widgets.dart';

class BottomNavigation extends StatefulWidget {
  final userdata;
  final int currentScreen;
  final bool isOpenTask;
  BottomNavigation({
    this.userdata,
    this.currentScreen = 0,
    this.isOpenTask = false,
  });
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  // Widget add() {
  //   return Container(
  //     child: FloatingActionButton(
  //       onPressed: null,
  //       // heroTag: "Add",
  //       tooltip: 'Add',
  //       child: Icon(Icons.add),
  //     ),
  //   );
  // }

  // Widget image() {
  //   return Container(
  //     child: FloatingActionButton(
  //       onPressed: null,
  //       // heroTag: "Image",
  //       tooltip: 'Image',
  //       child: Icon(Icons.image),
  //     ),
  //   );
  // }

  // Widget inbox() {
  //   return Container(
  //     child: FloatingActionButton(
  //       onPressed: null,
  //       // heroTag: "Inbox",
  //       tooltip: 'Inbox',
  //       child: Icon(Icons.inbox),
  //     ),
  //   );
  // }

  getUserId() async {
    var userData = await SharedPref().read("userData");
    if (userData['_id'] != null) {
      globalUserId = userData['user']['_id'];
    }
    initData();
  }

  DateTime _lastQuitTime;
  int _currentIndex = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  initData() {
    if (mounted) {
      if (widget.isOpenTask) {
        openScreen(context, ScheduleMain());
      }
      setState(() {
        _currentIndex = widget.currentScreen;
      });

      Future.delayed(Duration.zero).then((value) async {
        initFirebaseNoti(context);
        initDynamicLinks(context);
        if (isLoginRefer) {
          if (referalCode != "") {
            LoadingProgressDialog()
                .show(context, message: "Adding to Caretaker Group");
            var postableData = {
              "userID": globalUserId,
              "referCode": referalCode
            };
            RestRouteApi(context, ApiPaths.updateFcmToken)
                .updateFirebaseToken();
            await RestRouteApi(context, ApiPaths.addByReferalCode)
                .post(jsonEncode(postableData));
            LoadingProgressDialog().hide(context);
          }
        }
      });
    }
  }

  showExitDialog(BuildContext context, message) async {
    Widget doneButton = FlatButton(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          "CANCEL",
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
          "EXIT",
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () {
        Navigator.pop(context, true);
        exit(0);
      },
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Text(
        "Do you want to exit from Application?",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        doneButton,
        backButton,
      ],
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  var careTaker = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ignore: unused_local_variable
        final double width = constraints.maxWidth;
        // ignore: unused_local_variable
        final double height = constraints.maxHeight;
        final List<Widget> _children = [
          HomeMain(onPressTabChange: (int bottom, int tab) {
            careTaker = tab;
            onTabTapped(bottom);
          }),
          Schedule(),
          CareTakerMain(currentTab: careTaker),
          // ShortsMain(),
          ShortsMain(data: {'stories': gifStories}),
        ];
        _bottomBar(
            {IconData icon, String name, int index, key, String imageUrl}) {
          var color = _currentIndex == index
              ? Color(0xff1E83FE)
              : Color(0xff4893FE).withOpacity(0.5);
          return InkWell(
            key: key,
            onTap: () => onTabTapped(index),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  imageUrl == null
                      ? Icon(
                          icon,
                          color: color,
                        )
                      : Opacity(
                          opacity: _currentIndex == index ? 1 : 0.5,
                          child: Image.asset(
                            imageUrl,
                            height: 22,
                          ),
                        ),
                  Text(
                    name,
                    style: TextStyle(color: color),
                  )
                ],
              ),
            ),
          );
        }

        return GradientBg(
          child: WillPopScope(
            onWillPop: () async {
              if (_currentIndex != 0) {
                setState(() {
                  _currentIndex = 0;
                });
                return false;
              }
              if (_lastQuitTime == null ||
                  DateTime.now().difference(_lastQuitTime).inSeconds > 0.001) {
                showExitDialog(context, "");
                _lastQuitTime = DateTime.now();
                return false;
              }
              exit(0);
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: _children.elementAt(_currentIndex),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: "CameraView",
                backgroundColor: Colors.red,
                child: Icon(Icons.camera_alt),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CameraView()));
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 4.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bottomBar(
                      index: 0,
                      name: "Home",
                      imageUrl: "assets/images/home.png",
                    ),
                    _bottomBar(
                      index: 1,
                      name: "Schedule",
                      imageUrl: "assets/images/schedule.png",
                    ),
                    Container(
                      height: 0,
                      width: 50,
                    ),
                    _bottomBar(
                      key: MarkHelper.careTaker.key,
                      index: 2,
                      name: "Caretaker", //"Family",
                      imageUrl: "assets/images/caretaker.png",
                    ),
                    _bottomBar(
                      index: 3,
                      name: "Shorts",
                      imageUrl: "assets/images/shorts.png",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

updateReferer(BuildContext context) async {
  if (isLoginRefer) {
    LoadingProgressDialog loadingProgressDialog = new LoadingProgressDialog();
    var referCode = await joinGroup(context, referalCode: referalCode);
    if (referCode != null) {
      loadingProgressDialog.show(context, message: "Adding to Caretaker Group");
      var userData = await SharedPref().read("userData");
      var userId = userData['user']['_id'];
      var data = await RestRouteApi(context, ApiPaths.addByReferalCode)
          .post(json.encode({"userID": userId, "referCode": referCode}));
      if (data != null) {
        showToast(data.message, context);
      }
      await context.read<UserProvider>().onScheduleChange(context);
      loadingProgressDialog.hide(context);
    }
    referCode = "";
    isLoginRefer = false;
  }
}

void initDynamicLinks(BuildContext context) async {
  final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();

  final Uri deepLink = data?.link;

  if (deepLink != null) {
    referalCode = deepLink.path.replaceAll("/", "");
    if (referalCode.length > 5) {
      if (token != null) {
        isLoginRefer = true;
        updateReferer(context);
      }
    }
  }

  FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
    final Uri deepLink = dynamicLink?.link;

    if (deepLink != null) {
      referalCode = deepLink.path.replaceAll("/", "");
      if (referalCode.length > 5) {
        if (token != null) {
          isLoginRefer = true;
          updateReferer(context);
        }
      }
    }
  }, onError: (OnLinkErrorException e) async {
    print(e.message);
  });
}
