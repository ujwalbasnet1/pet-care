import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/service/network.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';
import 'successful_dialog.dart';

aknowledge(BuildContext context, message) async {
  Widget doneButton = FlatButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: blueClassicColor,
    child: Text(
      "DONE",
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () {
      Navigator.pop(context, true);
      fetchEarnedPoint(context, message, "done");
    },
  );
  Widget backButton = FlatButton(
    child: Text("ACKNOWLEDGE"),
    onPressed: () {
      Navigator.pop(context, true);
      fetchEarnedPoint(context, message, "ack");
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    title: Text(
      "Task Confirmation",
      style: TextStyle(color: blueClassicColor),
    ),
    content: Text(
      "Have you completed the Task?",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      backButton,
      doneButton,
    ],
  );

  // show the dialog
  return await showModal(
    context: context,
    configuration: FadeScaleTransitionConfiguration(),
    builder: (BuildContext context) {
      return alert;
    },
  );
}

fetchEarnedPoint(BuildContext context, message, type) async {
  var postAbleData = {
    "clickType": type,
    "id": message['id'] ?? message['data']['id'],
    "notifyId": message['notify_id'] ?? message['data']['notify_id']
  };
  LoadingProgressDialog().show(context);
  var data = await RestRouteApi(context, ApiPaths.updateNotifications)
      .post(json.encode(postAbleData));
  if (data == null) return;

  Future.wait([
    context.read<UserProvider>().fetchUserInfo(context, force: true),
    Future.delayed(Duration(microseconds: 200)),
  ]);

  LoadingProgressDialog().hide(context);
  return showModal(
    context: context,
    configuration: FadeScaleTransitionConfiguration(),
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SuccessfulDialog(
            data: data,
          ));
    },
  );
}
