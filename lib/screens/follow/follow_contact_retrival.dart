import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/screens/caretaker/caretaker_main.dart';
import 'package:pets/screens/contacts/contacts_screen.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowContactRetrieval {
  final BuildContext context;
  final groupDetails;
  final String userId;
  FollowContactRetrieval(
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
}
