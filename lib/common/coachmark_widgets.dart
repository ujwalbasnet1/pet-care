import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:pets/theming/common_size.dart';
import 'package:pets/service/userid_store.dart';

class MarkHelper {
  static showMark(NextMark mark) async {
    var list = await SharedPref().getStringListValue("ExecutedCoachMark");
    if (list == null) {
      list = [];
    }
    if (!list.contains(mark.message)) {
      CoachMark coachMark = CoachMark();
      RenderBox target = mark.key.currentContext.findRenderObject();

      Rect markRect = target.localToGlobal(Offset.zero) & target.size;
      markRect = mark.isCircle
          ? Rect.fromCircle(
              center: markRect.center, radius: markRect.longestSide * 0.6)
          : markRect.inflate(5.0);

      coachMark.show(
          targetContext: mark.key.currentContext,
          markRect: markRect,
          markShape: mark.isCircle ? BoxShape.circle : BoxShape.rectangle,
          children: [
            mark.isCircle
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: Text(mark.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        )),
                  ))
                : Container(
                    margin: EdgeInsets.only(top: markRect.bottom + 15.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: padding),
                      child: Text(mark.message,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          )),
                    ))
          ],
          duration: null,
          onClose: () {
            if (mark.next != null) {
              Timer(Duration(microseconds: 500), () => showMark(mark.next));
            }
          });
      list.add(mark.message);
      await SharedPref().storeStringListValue("ExecutedCoachMark", list);
    }
  }

  static NextMark createSchedule = new NextMark(
      GlobalObjectKey("createSchedule"), "Tap on Button To Create Pet Schedule",
      isCircle: true);
  static NextMark notification = new NextMark(GlobalObjectKey("notification"),
      "Tap on Notification Icon to See Manage Your Pet Notification",
      isCircle: true);
  static NextMark careTaker = new NextMark(GlobalObjectKey("careTaker"),
      "Add Caretaker For Your Pet and Earn Points Who ever do the Pet's Task",
      isCircle: true);
  static NextMark swipeLeft = new NextMark(
      GlobalObjectKey("swipeLeft"), "Manage Multiple Pets \nby Swiping Left",
      next: barGraphPoints, isCircle: false);
  static NextMark inviteFriends = new NextMark(GlobalObjectKey("inviteFriends"),
      "Invite Friends to add to Your Pet Caretaker Group.");
  static NextMark totalPoints = new NextMark(GlobalObjectKey("totalPoints"),
      "Total Earned points are displayed and Points for Each Individual Pet are displayed on below Graph",
      next: swipeLeft);
  static NextMark barGraphPoints = new NextMark(
      GlobalObjectKey("barGraphPoints"),
      "See Points of All Caretaker Members for the Pet.",
      next: careTaker);
}

class NextMark {
  final key;
  final message;
  NextMark next;
  final bool isCircle;
  NextMark(this.key, this.message, {this.next, this.isCircle = false});
}
