import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pets/utils/static_variables.dart';

import 'package:uuid/uuid.dart';
import 'package:pets/screens/aknowledge/acknowledge.dart';
import 'package:pets/service/network.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
var obtainedFirebaseToken = "";
// ignore: unused_element
Future<void> _showBigTextNotification() async {
  var bigTextStyleInformation = BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      styleInformation: bigTextStyleInformation);
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

// ignore: unused_element
Future<void> _showNotification(Map<String, dynamic> message) async {
  var msg = message['notification'];
  var uuid = new Uuid();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    uuid.v1(), "Info", 'Notification for information ',
    importance: Importance.max, priority: Priority.high, ticker: 'ticker',
    playSound: true,
    // sound: RawResourceAndroidNotificationSound("notification_tone"),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, msg['title'] + "FOrn", msg['body'], platformChannelSpecifics,
      payload: jsonEncode(message));
}

Future<void> initNotifications() async {
  //-------------------- Initialization Code---------------------
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  //--------------------------------------
}

Future onSelectNotification(String payload) async {}

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    // Handle data message

    final dynamic data = message.data;
  }

  if (message.notification != null) {
    // Handle notification message
    final dynamic notification = message.notification;
  }

  // Or do other work.
}

initFirebaseNoti(BuildContext context) {
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     message.messageId
//  if ((message['notify_id'] ?? message['data']['notify_id'])
//                 .toString()
//                 .length >
//             15)
    aknowledge(context, message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // _firebaseMessaging.requestNotificationPermissions();
  // Future.delayed(Duration(seconds: 1), () {
  //   FirebaseMessaging.onMessage;
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       if ((message['notify_id'] ?? message['data']['notify_id'])
  //               .toString()
  //               .length >
  //           15) aknowledge(context, message);
  //       // _showItemDialog(message);
  //     },
  //     onBackgroundMessage: myBackgroundMessageHandler,
  //     onLaunch: (Map<String, dynamic> message) async {
  //       showMissedNotification = false;
  //       if ((message['notify_id'] ?? message['data']['notify_id'])
  //               .toString()
  //               .length >
  //           15) {
  //         await aknowledge(context, message);
  //         showMissedNotification = true;
  //       }
  //       // _navigateToItemDetail(message);
  //       // dsd
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       showMissedNotification = false;
  //       if ((message['notify_id'] ?? message['data']['notify_id'])
  //               .toString()
  //               .length >
  //           15) {
  //         await aknowledge(context, message);
  //         showMissedNotification = true;
  //       }
  //       // _navigateToItemDetail(message);
  //     },
  //   );
  // });
  // // _firebaseMessaging.subscribeToTopic("my-pet");
  // _firebaseMessaging.getToken().then((value) {
  //   obtainedFirebaseToken = value;
  //   RestRouteApi(context, ApiPaths.updateFcmToken).updateFirebaseToken();
  // });
  FirebaseMessaging.instance.subscribeToTopic("my-pet");
  FirebaseMessaging.instance.getToken().then((value) {
    obtainedFirebaseToken = value;
    RestRouteApi(context, ApiPaths.updateFcmToken).updateFirebaseToken();
  });
  initNotifications();
}
