import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

Widget inviteAppbar(
    {var selectedLength, BuildContext context, Function() onPressed}) {
  return AppBar(
    elevation: 1,
    backgroundColor: blueClassicColor,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Contact"),
        selectedLength.length == 0
            ? Text(
                "Add Participants",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              )
            : Text(
                "${selectedLength.length.toString()} Selected",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              ),
      ],
    ),
    actions: [
      onPressed == null
          ? Container()
          : Padding(
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: onPressed,
              ),
            ),
    ],
  );
}
