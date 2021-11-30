import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pets/common/join_group.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/manage_pets/manage_pet_list.dart';
import 'package:pets/screens/navigator_screen/profiles/notification_prefs/notification_list.dart';
import 'package:pets/screens/navigator_screen/profiles/notification_prefs/notification_main.dart';
import 'package:pets/screens/profile/profile_main.dart';
import 'package:pets/screens/story/request_approval/request_approval_main.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);
  _boldText(text) {
    return Text(text,
        softWrap: true,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
  }

  @override
  Widget build(BuildContext context) {
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

    _socialItem(e) {
      return InkWell(
        onTap: e['action'],
        child: CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage("${e['image']}"),
          backgroundColor: e['color'],
        ),
      );
    }

    var socialItems = [
      {
        "image": "assets/images/instagram.png",
        "action": () async {
          await launch("https://www.instagram.com/mypetslife_pets/");
        },
      },
      {
        "image": "assets/images/twitter.png",
        "action": () async {
          await launch("https://twitter.com/MyPetsLife1");
        },
      },
      {
        "image": "assets/images/facebook.png",
        "action": () async {
          await launch("https://www.facebook.com/mypetslife.petslife");
        },
      }
    ];

    var listItems = [
      {
        "icon": Icons.person,
        "title": "Profile",
        "action": () {
          openScreen(
              context,
              Material(
                child: ProfileMain(),
              ));
        },
        "color": Color(0xff1DA1F2)
      },
      // {
      //   "icon": Icons.contact_page,
      //   "title": "Follower's Request",
      //   "action": () {
      //     openScreen(context, RequestApprovalMain());
      //   },
      //   "color": Color(0xff4CD964)
      // },
      {
        "icon": Icons.pets,
        "title": "Manage / Add Pets",
        "action": () {
          if (context.read<UserProvider>().getUserInfo.isMinor) {
            showToast(
                'You are Minor. A Minor cannot perform this Task.', context);
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
        "icon": Icons.group_add,
        "title": "Join Caretaker Group",
        "action": () async {
          LoadingProgressDialog loadingProgressDialog =
              new LoadingProgressDialog();
          var referCode = await joinGroup(context);
          var userId = context.read<UserProvider>().getUserInfo.userId;
          if (referCode != null) {
            loadingProgressDialog.show(context);

            var data = await RestRouteApi(context, ApiPaths.addByReferalCode)
                .post(json.encode({"userID": userId, "referCode": referCode}));
            if (data != null) {
              showToast(data.message, context);
            }
            await context.read<UserProvider>().onScheduleChange(context);
            loadingProgressDialog.hide(context);
          }
        },
        "color": Colors.green
      },
      {
        "icon": Icons.notifications,
        "title": "Notification",
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationList(),
            ),
          );
        },
        "color": Color(0xffFF3B30)
      },
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
      {
        "icon": Icons.notifications_active,
        "title": "Notification Settings",
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationMain(),
            ),
          );
        },
        "color": Colors.cyan[800]
      },
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

      {
        "icon": Icons.share,
        "title": "Share App",
        "action": () {
          Share.share(
              "Follow this link to join me in Petslife, https://mypetslifeus.page.link/join");
        },
        "color": Colors.indigoAccent
      },
    ];

    _itemsRowCOlumne() {
      return Column(
        children: listItems.map((e) => _itemsRow(e)).toList(),
      );
    }

    _socialRow() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: socialItems.map((e) => _socialItem(e)).toList(),
        ),
      );
    }

    _drawerHeader() {
      return InkWell(
        onTap: () {
          openScreen(
              context,
              Material(
                child: ProfileMain(),
              ));
        },
        child: DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer(
              builder: (BuildContext context, UserProvider uPro, Widget child) {
            var userInfo = uPro.getUserData['data']['userInfo'] ?? {};
            var phone = uPro.getUserData['data']['phone'];
            return Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      image:
                          readObjectValue(userInfo ?? {}, 'avatar').length > 10
                              ? NetworkImage("${userInfo['avatar']}")
                              : AssetImage("assets/images/bdog.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userInfo['fname']} ${userInfo['lname']}",
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("$phone",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              // color: Colors.white,
                              )),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _itemsRowCOlumne(),
          // TODO: social icons alignment
          SizedBox(
            height: 30,
          ),
          Container(child: _socialRow()),
        ],
      ),
    );
  }
}
