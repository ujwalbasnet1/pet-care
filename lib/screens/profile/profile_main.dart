import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/custom_image.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/screens/manage_pets/manage_pet_list.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/service/userid_store.dart';
import '../../main.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/screens/family_screens/family_main.dart';
import 'package:pets/screens/five-steps/about_you_edit.dart';
import 'package:pets/common/buttons/border_button.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_review/in_app_review.dart';
import 'points_table.dart';

class ProfileMain extends StatefulWidget {
  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  // var userData;
  var userId = "";
  var isLoaded = false;
  @override
  void initState() {
    setCurrentScreen(ScreenName.profileMain);

    fetchUserInfo();
    getUserInfo();
    appInfo();
    super.initState();
  }

  getUserInfo() async {
    var user = await SharedPref().read("userData");
    if (mounted)
      setState(() {
        userId = user['user']['_id'];
      });
  }

  String version = "v1.0.13";
  appInfo() {
    getAppInfo().then((PackageInfo packageInfo) {
      if (mounted)
        setState(() {
          version = "${packageInfo.version}/${packageInfo.buildNumber}";
        });
    });
  }

  var points = "0";

  fetchUserInfo() async {
    if (mounted)
      await context.read<UserProvider>().fetchUserInfo(context, force: false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserProvider uPro, child) {
        return uPro.getUserData == null
            ? LoadingIndicator()
            : uPro.getUserData == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingIndicator(
                          imageUrl: "assets/gif/sad_dog.gif",
                          message: "Data Not Found",
                          textColor: Colors.black),
                      Center(
                        child: Container(
                          height: 80,
                          child: BorderButton(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            title: "Logout",
                            onPressed: () {
                              context.read<UserProvider>().logout();
                              SharedPref().remove("token");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Wrapper(),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    color: Colors.transparent,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        // ignore: unused_local_variable
                        final double width = getWidth(constraints, context);
                        // ignore: unused_local_variable
                        final double height = getHeight(constraints, context);
                        var userInfo =
                            uPro.getUserData['data']['userInfo'] ?? {};
                        var phone = uPro.getUserData['data']['phone'];

                        var listItems = [
                          // {
                          //   "icon": Icons.notifications,
                          //   "title": "Notification",
                          //   "action": () {},
                          //   "color": Color(0xffFF3B30)
                          // },
                          // {
                          //   "icon": Icons.add,
                          //   "title": "Add Members",
                          //   "action": () {
                          //     // Navigator.push(
                          //     //   context,
                          //     //   MaterialPageRoute(
                          //     //     builder: (context) => CareTakerMain(),
                          //     //   ),
                          //     // );
                          //   },
                          //   "color": Colors.green
                          // },
                          // {
                          //   "icon": Icons.add,
                          //   "title": "Add Pets",
                          //   "action": () {
                          //     if (context
                          //         .read<UserProvider>()
                          //         .getUserInfo
                          //         .isMinor) {
                          //       showToast("Minor Cannot Add a Pet", context);
                          //     } else {
                          //       openScreen(context, AboutPet());
                          //     }
                          //   },
                          //   "color": Colors.green
                          // },
                          // {
                          //   "icon": Icons.notifications_active,
                          //   "title": "Notification Prefs",
                          //   "action": () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => NotificationMain(),
                          //       ),
                          //     );
                          //   },
                          //   "color": Colors.cyanAccent
                          // },

                          // {
                          //   "icon": Icons.notification_important,
                          //   "title": "Notification List",
                          //   "action": () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => NotificationList(),
                          //       ),
                          //     );
                          //   },
                          //   "color": Colors.amber
                          // },
                          // {
                          //   "icon": Icons.pets,
                          //   "title": "Manage Pets",
                          //   "action": () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => ManagePetList(),
                          //       ),
                          //     );
                          //   },
                          //   "color": Color(0xff4CD964)
                          // },
                          {
                            "icon": Icons.pets,
                            "title": "Manage / Add Pets",
                            "action": () {
                              if (context
                                  .read<UserProvider>()
                                  .getUserInfo
                                  .isMinor) {
                                showToast(
                                    'You are Minor. A Minor cannot perform this Task.',
                                    context);
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManagePetList(),
                                ),
                              );
                            },
                            "color": Color(0xff4CD964)
                          },
                          {
                            "icon": Icons.mic,
                            "title": "Setup Alexa",
                            "action": () async {
                              showToast(
                                  "Feature will be available soon", context);
                              // String url =
                              //     "https://developer.amazon.com/alexa/console/ask/build/custom/amzn1.ask.skill.2a4304e3-7c71-4365-bb7d-8371c6fcefcd/development/en_US/interfaces";
                              // if (await canLaunch(url)) {
                              //   await launch(url);
                              // } else {
                              //   throw 'Could not launch $url';
                              // }
                            },
                            "color": Color(0xff007AFF)
                          },
                          // {
                          //   "icon": Icons.group_add,
                          //   "title": "Join Group",
                          //   "action": () async {
                          //     LoadingProgressDialog loadingProgressDialog =
                          //         new LoadingProgressDialog();
                          //     var referCode = await joinGroup(context);
                          //     if (referCode != null) {
                          //       loadingProgressDialog.show(context);

                          //       var data = await RestRouteApi(
                          //               context, ApiPaths.addByReferalCode)
                          //           .post(json.encode({
                          //         "userID": userId,
                          //         "referCode": referCode
                          //       }));
                          //       if (data != null) {
                          //         showToast(data.message, context);
                          //       }
                          //       loadingProgressDialog.hide(context);
                          //     }
                          //   },
                          //   "color": Colors.cyanAccent
                          // },
                          // {
                          //   "icon": Icons.family_restroom,
                          //   "title": "Family",
                          //   "action": () {
                          //     openScreen(
                          //         context,
                          //         FamilyMain(
                          //             family: uPro.getUserData['data']['pet'] +
                          //                 uPro.getUserData['data']
                          //                     ['caretaker']));
                          //   },
                          //   "color": Colors.lightGreen
                          // },

                          {
                            "icon": Icons.rate_review,
                            "title": "Rate and Review",
                            "action": () async {
                              final InAppReview inAppReview =
                                  InAppReview.instance;

                              if (await inAppReview.isAvailable()) {
                                inAppReview.requestReview();
                              }
                            },
                            "color": Colors.orange
                          },
                          {
                            "icon": Icons.table_chart,
                            "title": "Points Table",
                            "action": () async {
                              openScreen(context, PointsTable());
                            },
                            "color": Color(0xff007AFF)
                          },
                          // {
                          //   "icon": Icons.qr_code,
                          //   "title": "Scan Qr (Only Minor)",
                          //   "action": () {
                          //     openScreen(
                          //         context,
                          //         FamilyMain(
                          //             family: uPro.userData['data']['pet'] +
                          //                 uPro.userData['data']['caretaker']));
                          //   },
                          //   "color": Colors.amber
                          // },
                          {
                            "icon": Icons.headphones,
                            "title": "Help Center",
                            "color": Colors.redAccent,
                            "action": () {
                              showModal(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Container(
                                      width: double.infinity,
                                      height: 70,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          await sendEmail();
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Need Help? Please send us mail at",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            Text(
                                              "support@mypetslife.us",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Colors.blue,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          },

                          {
                            "icon": Icons.help,
                            "title": "About Us",
                            "color": Colors.greenAccent,
                            "action": () {
                              showModal(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "MyPetsLife v$version",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    content: Text(
                                      "MyPetsLife is a digital product to help you manage your Pets life with your family. Our goal is to leave the schedule of your pet to be managed by this product",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(color: Colors.blue),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          },

                          {
                            "icon": Icons.logout,
                            "title": "Logout",
                            "action": () {
                              SharedPref().remove("token");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Wrapper(),
                                ),
                              );
                            },
                            "logout": Color(0xffFF3B30)
                          },
                        ];

                        _boldText(text) {
                          return Text(text,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600));
                        }

                        _profileHeader() {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          child: CustomImage(
                                              url: readObjectValue(
                                                  userInfo, 'avatar')),
                                        )),
                                  ),

                                  // Image.network(
                                  //   userInfo['avatar'],
                                  //   height: height * 15,
                                  // ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _boldText(
                                            "${userInfo['fname']} ${userInfo['lname']}"),
                                        Text(phone ??
                                            userInfo['email'] ??
                                            "Phone No."),
                                        Text('v$version')
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      await openScreen(
                                          context,
                                          AboutYouEdit(
                                              userInfo: uPro.getUserData['data']
                                                      ['userInfo'] ??
                                                  {}));

                                      // setState(() {});
                                    },
                                  ),
                                  // Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          );
                        }

                        _itemsRow(e) {
                          return ListTile(
                              onTap: e['action'],
                              leading: CircleAvatar(
                                  backgroundColor: e['color'],
                                  child: Icon(
                                    e['icon'],
                                    color: Colors.white,
                                  )),
                              title: _boldText(e['title']),
                              trailing: Icon(Icons.arrow_forward_ios));
                        }

                        _itemsRowCOlumne() {
                          return Column(
                            children:
                                listItems.map((e) => _itemsRow(e)).toList(),
                          );
                        }

                        return Scaffold(
                            appBar: AppBar(
                              title: Text('Profile'),
                            ),
                            body: GradientBg(
                              child: RefreshIndicator(
                                onRefresh: () => fetchUserInfo(),
                                child: ListView(children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: _profileHeader()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 25,
                                    ),
                                    child: Divider(
                                      thickness: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: _itemsRowCOlumne(),
                                  ),
                                  // Container(
                                  //     margin: const EdgeInsets.only(bottom: 40.0),
                                  //     child: ActionChip(
                                  //       backgroundColor: Colors.blue,
                                  //       label: Text(
                                  //         "Show Acknowledge",
                                  //         style: TextStyle(color: Colors.white),
                                  //       ),
                                  //       onPressed: () {
                                  //         aknowledge(context, "message");
                                  //       },
                                  //     ))
                                ]),
                              ),
                            ));
                      },
                    ),
                  );
      },
    );
  }
}
