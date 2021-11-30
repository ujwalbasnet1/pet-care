import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:package_info/package_info.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/data.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

dynamic readObjectValue(object, name) {
  var defaultValue = 'NA';
  try {
    defaultValue = object[name] ?? defaultValue;
  } catch (e) {
    log(e, name: name);
  }
  return defaultValue;
}

Uri getUri(String url) {
  return Uri.parse(url);
}

String twoDigit(String val) {
  if (val.length > 2) return "00";
  if (val.length == 1) return "0" + val;

  return val.toString();
}

int getTimeDiff(val) {
  return DateTime.now().toUtc().minute - int.parse(val);
}

String getTimeFromMinutes(String str, {toUtc = true}) {
  var hrMin =
      Duration(minutes: int.parse(str)).toString().split(".")[0].split(":");

  var dateTime = DateTime.parse(
      "2012-02-27 ${twoDigit(hrMin[0])}:${twoDigit(hrMin[1])}:${twoDigit(hrMin[2])}");
  var retVal = toUtc ? dateTime.toUtc() : dateTime;
  return "${twoDigit(retVal.hour.toString())}:${twoDigit(retVal.minute.toString())}";
}

getEpoch(date, time) {
  var dt = date.toString().split(" ");
  dt[1] =
      getTimeFromMinutes(getTimeMinuteFromAmPm(time).toString(), toUtc: false)
          .toString();
  return "${DateTime.parse(dt.join(" ")).toUtc().millisecondsSinceEpoch}";
}

getTimeString(int millisecondsSinceEpoch) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  // final value = DateTime.now().difference(dateTime).abs();
  // String stringTime = value.toString();
  // String dueInTime = stringTime.replaceRange(4, 14, "");

  return dateTime;
}

List<int> getInBetweenTime(int startMin, int endMin, int repeatMin) {
  List<int> times = [];
  int totalMin = endMin - startMin;
  int noInBetweenTime = (totalMin / repeatMin).floor();

  for (var i = 0; i < noInBetweenTime; i++) {
    times.add(startMin + ((i + 1) * repeatMin));
  }
  return times.toSet().toList();
}

String capitalize(String str, {var isSingle = false}) {
  try {
    str =
        isSingle ? str.trim().split(" ")[0] : str.trim(); //tipl.split(" ")[0];
    var newStr =
        str.substring(0, 1).toUpperCase() + str.substring(1, str.length);
    return newStr;
  } catch (e) {
    return str;
  }
}

double getWidth(BoxConstraints constraints, BuildContext context) {
  var width = /*   constraints.maxHeight < constraints.maxWidth ? constraints.maxHeight :   */ constraints
      .maxWidth;
  return width * 0.01; // 1 % of  Width
}

double getHeight(BoxConstraints constraints, BuildContext context) {
  var heigth = constraints
      .maxHeight /*  > constraints.maxWidth ? constraints.maxHeight : constraints.maxWidth */;
  return heigth * 0.01; // 1 % of  height
}

double getScreenRatio(BoxConstraints constraints) {
  final height = constraints.maxHeight;
  final width = constraints.maxWidth;
  double ratio = 0;
  if (height > width)
    ratio = height / width;
  else
    ratio = width / height;
  return ratio;
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

openScreen(BuildContext context, screenName) {
  return Navigator.push(context, MaterialPageRoute(builder: (_) => screenName));
}

pushReplacement(BuildContext context, screenName) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => screenName));
}

pushRoute(BuildContext context, routeName) {
  return Navigator.of(context).pushNamed(routeName);
}

void pushNamedReplaceRoute(BuildContext context, routeName) {
  Navigator.of(context).pushReplacementNamed(routeName);
}

void showToast(String msg, BuildContext context, {int duration, int gravity}) {
  var x = msg.toLowerCase();
  // ignore: unused_local_variable
  Color color = x.contains(RegExp('r"^(?=.*not)(?=.*error)"'))
      ? Colors.red
      : Theme.of(context).cardColor;
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  if (msg != null) Toast.show(msg, context, duration: 2, gravity: 0);
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(var data) {
  return base64Encode(data);
}

printDebug(msg, {tag = ''}) {
  // if(isDebugging)
  print(tag + msg.toString());
}

double fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

int getTimeMinuteFromAmPm(String str) {
  str = str ?? "1:00 AM";
  //(utc.hour * 60) + utc.minute
  var timeStr = str.split(" ");
  var hrMin = timeStr[0].split(":");
  var aMpM = (timeStr[1] == 'AM') ? 0 : 12;

  int hr = int.parse(hrMin[0]);
  int min = int.parse(hrMin[1]);
  return (((aMpM + hr) * 60) + min);
}

getStatusColor(int i) {
  switch (i - 1) {
    case 1:
      return Colors.green;
      break;
    case 2:
      return Colors.green[200];
      break;
    case 3:
      return Colors.green;
      break;
    case 4:
      return Colors.red;
      break;
    default:
      return Colors.blue;
  }
}

enum ImageUrlType {
  meal,
  walk,
  medicine,
  supplement,
  water,
  playTime,
  createTask,
  notes
}

String getImageAssetUrl(ImageUrlType imageUrlType) {
  String out;
  String baseUrl = "assets/images";
  if (imageUrlType == ImageUrlType.meal) {
    out = baseUrl + "/meal.png";
  } else if (imageUrlType == ImageUrlType.walk) {
    out = baseUrl + "/walk.png";
  } else if (imageUrlType == ImageUrlType.medicine) {
    out = baseUrl + "/medicine.png";
  } else if (imageUrlType == ImageUrlType.supplement) {
    out = baseUrl + "/supplement.png";
  } else if (imageUrlType == ImageUrlType.water) {
    out = baseUrl + "/water.png";
  } else if (imageUrlType == ImageUrlType.playTime) {
    out = baseUrl + "/play_time.png";
  } else if (imageUrlType == ImageUrlType.createTask) {
    out = baseUrl + "/create_task.png";
  } else if (imageUrlType == ImageUrlType.notes) {
    out = baseUrl + "/notes.png";
  }
  return out;
}

sendEmail() async {
  final Uri email = Uri(
      scheme: 'mailto',
      path: 'support@mypetslife.us',
      queryParameters: {'subject': 'Help'});
  await launch(email.toString());
}

String getAssetImage(String str) {
  String baseUrl = "assets/images";

  var img = {
    "meal": "/meal.png",
    "walk": "/walk.png",
    "medicine": "/medicine.png",
    "supplement": "/supplement.png",
    "water": "/water.png",
    "playtime": "/play_time.png",
    "createtask": "/create_task.png",
    "notes": "/notes.png",
    "veterinary": "/veterinary.png",
    "grooming": "/grooming.png",
    "cleaning": "/cleaning.png",
    "shopping": "/shopping.png",
    "training": "/training.png",
    "measurements": "/measurement.png",
    "others": "/others.png"
  };
  var key = str.toLowerCase().replaceAll(" ", "");

  return baseUrl + (img[key] ?? "/meal.png");
}

String getSuffix(int number) {
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

setCurrentScreen(String name) {
  FirebaseAnalytics().setCurrentScreen(screenName: '$name');
}

logEvent(String name, {isEvent = false}) async {
  name = name.replaceAll(" ", "_");
  FirebaseAnalytics().logEvent(name: '$name', parameters: null);
  RestRouteApi(null, ApiPaths.sendEvents).sendEvent(name, isEvent);
}

Future<PackageInfo> getAppInfo() async {
  return await PackageInfo.fromPlatform();
}

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
const shortWeekdays = [
  "Su",
  "Mo",
  "Tu",
  "We",
  "Th",
  "Fr",
  "Sa",
];

getMonthDateFromType(e) {
  var month = "";
  var date = "";
  try {
    if (e['dateSelected'] == null) {
      var splitted = e['repeatType'].split("/");
      month = splitted[0];
      date = splitted[0];
      if (splitted.length > 1) {
        if (month.toLowerCase() == 'weekly') {
          var weekdaysInt = splitted[1].toString().split(",");
          List<String> weekdaySorts = [];
          // log(splitted[1].toString());
          for (var item in weekdaysInt) {
            weekdaySorts.add(shortWeekdays[int.parse(item)]);
          }
          date = weekdaySorts.join(",");
        } else {
          date = splitted[1];
        }
      }
    } else {
      List<String> data = e['dateSelected'].split("-");
      data[1] = twoDigit(data[1]);
      data[2] = twoDigit(data[2]);
      DateTime dt = DateTime.parse(data.join("-"));
      month = months[dt.month - 1].toString();
      date = twoDigit(dt.day.toString());
    }
  } catch (e) {
    log(e);
  }
  return {'month': month, 'date': date};
}

toDatefromInvalidDate(d) {
  if (d == null) return DateTime.now();
  List<String> data = d.split("-");
  data[1] = twoDigit(data[1]);
  data[2] = twoDigit(data[2]);
  return DateTime.parse(data.join("-"));
}

Future<Country> getCountry() async {
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

  var isoCode = contries
      .singleWhere((element) => element['timeZone'] == currentTimeZone)['iso'];
  return Country.ALL.singleWhere(
    (item) => item.isoCode == isoCode,
  );
}

class ScreenName {
  static String main = "Main";
  static String loginScreen = "Login_Screen";
  static String otpScreen = "Otp_Screen";
  static String signUpScreen = "SignUp_Screen";
  static String addNewContact = "AddNew_Contact";
  static String careTakerList = "Care_Taker_List";
  static String careTakerMain = "Care_Taker_Main";
  static String contactScreen = "Contact_Screen";
  static String eventMain = "Event_Main";
  static String familyMain = "Family_Main";
  static String managePetEdit = "Manage_Pet_Edit";
  static String managePetList = "Manage_Pet_List";
  static String homeMain = "Home_Main";
  static String notificationMain = "Notification_Main";
  static String notificationList = "Notification_List";
  static String onboardingMain = "Onboarding_Main";
  static String profileMain = "Profile_Main";
  static String createSchedule = "Create_Schedule";
  static String scheduleMain = "Schedule_Main";
  static String editProfile = "Edit_Profile";
  static String selectPetType = "Select_Pet_Type";
  static String petDetailsForm = "Pet_Details_Form";
  static String inviteFriendAndFamily = "Invite_Friend_And_Family";
  static String navigation = "Navigation";
  static String clickAddReminder = "Click_Add_Reminder";
  static String clickAddTask = "Click_Add_Task";
  static String clickAddNotes = "Click_Add_Notes";
  // static String navigation = "Invite_Friend_And_Family";
}
