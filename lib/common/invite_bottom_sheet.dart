import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/screens/caretaker/caretaker_main.dart';
import 'package:pets/screens/contacts/contacts_screen.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteBottomSheet {
  final BuildContext context;
  final groupDetails;
  final String userId;
  InviteBottomSheet(
    this.context,
    this.groupDetails,
    this.userId,
  );
  Future<bool> _handleContactPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Widget _socials(String imageUrl, referLink, {Sharing sharing}) {
    String message =
        "MyPetsLife: Your Friend has invited you to their Pet's Caretaker Group. CLICK LINK TO JOIN. $referLink";

    return InkWell(
      onTap: () async {
        Navigator.pop(context);

        if (sharing == Sharing.whatsapp) {
          await SocialShare.shareWhatsapp(message);
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

  showBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
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
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/contact_add.png",
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        // width: 300,
                        child: Text(
                          "Invite your family and Friends to take care of ${groupDetails['name'].replaceAll(" GROUP", "")}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Your Code",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    groupDetails['referCode'],
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: "${groupDetails['referCode']}"));
                      showToast("Code Copied", context);
                    },
                  ),
                ],
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      bool isGranted =
                          await _handleContactPermission(Permission.contacts);
                      if (isGranted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ContactsScreen(
                              groupInfo: groupDetails,
                              userId: userId,
                              referLink: groupDetails['referLink'],
                            ),
                          ),
                        );
                      } else {
                        isGranted =
                            await _handleContactPermission(Permission.contacts);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Invite from your contacts",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                          ),
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
                        groupDetails['referLink'],
                        sharing: Sharing.whatsapp,
                      ),
                      InkWell(
                        onTap: () {
                          String message =
                              "MyPetsLife: Your Friend has invited you to their Pet's Caretaker Group. CLICK LINK TO JOIN. ${groupDetails['referLink']}";
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
            ],
          ),
        );
      },
    );
  }
}
