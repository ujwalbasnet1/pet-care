import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/buttons/go_to_home_button.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/caretaker/caretaker_main.dart';
import 'package:pets/screens/contacts/contacts_screen.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class AddContact extends StatefulWidget {
  final bool isFromAddPets;

  const AddContact({Key key, this.isFromAddPets = false}) : super(key: key);
  @override
  AddContactState createState() => AddContactState();
}

class AddContactState extends State<AddContact> {
  @override
  void initState() {
    setCurrentScreen(ScreenName.inviteFriendAndFamily);
    context.read<UserProvider>().fetchStoredData();
    super.initState();
  }

  DateTime _lastQuitTime;

  Future<bool> _handleContactPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Widget _socials(String imageUrl, referLink, {Sharing sharing}) {
    String message =
        "MyPetsLife: Your Friend has invited you to their Pet's Caretaker Group. CLICK LINK TO JOIN. $referLink";

    return InkWell(
      onTap: () async {
        if (sharing == Sharing.whatsapp) {
          SocialShare.shareWhatsapp(message);
          // var whatsappUrl = "whatsapp://send?text=$message";
          // await canLaunch(whatsappUrl)
          //     ? launch(whatsappUrl)
          //     : showToast("WhtsApp not installed", context);
        } else if (sharing == Sharing.facebook) {
          var url = "m.me/";
          launch("http://$url?message=$message");
        } else if (sharing == Sharing.other) {
          Share.share(message);
        } else {
          Share.share(message);
        }
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.read<UserProvider>().fetchStoredData();
    return GradientBg(
      child: WillPopScope(
        onWillPop: () async {
          pushReplacement(context, BottomNavigation());
          return true;
        },
        child: Scaffold(
          appBar: appBarWidget(
              name: "Invite Family and Friends",
              centerTitle: false,
              canBack: widget.isFromAddPets),
          backgroundColor: Colors.transparent,
          body: Consumer(
            builder: (BuildContext context, UserProvider uPro, Widget child) {
              var userUserData = widget.isFromAddPets
                  ? uPro.getRecentlyAddedPet
                  : uPro.getStoredUserInfo['user'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        "assets/images/contact_add.png",
                      ),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Invite your family & friends who help you to take care of " +
                          (userUserData['name'] ?? "your pets"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your Code:",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 16),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "${userUserData['myrefercode'] ?? userUserData['referCode']}",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text:
                                "${userUserData['myrefercode'] ?? userUserData['referCode']}"));
                        showToast("Copied to Clipboard", context);
                      },
                    ),
                  ]),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        bool isGranted =
                            await _handleContactPermission(Permission.contacts);
                        if (isGranted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ContactsScreen(
                                referCode:
                                    "${userUserData['myrefercode'] ?? userUserData['referCode']}",
                                userId:
                                    "${userUserData['_id'] ?? userUserData['user']}",
                                referLink: widget.isFromAddPets
                                    ? userUserData['referLink']
                                    : "",
                              ),
                            ),
                          );
                        } else {
                          isGranted = await _handleContactPermission(
                              Permission.contacts);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Invite from your Contacts",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Container(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _socials(
                            "assets/images/whatsapp.png",
                            userUserData['referLink'] ??
                                userUserData['myreferlink'],
                            sharing: Sharing.whatsapp,
                          ),
                          // _socials("assets/images/chat.png"),
                          // _socials("assets/images/messanger.png"),
                          InkWell(
                            onTap: () {
                              String message =
                                  "MyPetsLife: Your Friend has invited you to their Pet's Caretaker Group. CLICK LINK TO JOIN. ${userUserData['referLink'] ?? userUserData['myreferlink']}";

                              Share.share(message);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(Icons.more_horiz_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GoToHomeButton(
                    onPressed: () {
                      pushReplacement(context, BottomNavigation());
                    },
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
