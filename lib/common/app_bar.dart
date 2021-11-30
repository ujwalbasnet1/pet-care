import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBarWidget({
  Color color,
  BuildContext context,
  String name,
  actions,
  canBack = true,
  bool centerTitle,
}) {
  // ignore: unused_local_variable
  var secondaryColor = Colors.white;
  if (color == null) {
    color = Colors.transparent;
    secondaryColor = Colors.black;
  }
  return AppBar(
    title: Text(
      name,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.blue,
    automaticallyImplyLeading: canBack,
    elevation: 0,
    centerTitle: centerTitle ?? true,
    actions: actions,
  );
}
