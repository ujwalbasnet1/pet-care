import 'package:flutter/material.dart';

import '../colors.dart';

class RoundRectangleButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final EdgeInsetsGeometry margin;

  const RoundRectangleButton(
      {Key key,
      this.onPressed,
      this.title = "Continue",
      this.margin = const EdgeInsets.fromLTRB(20, 10, 20, 10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: blueClassicColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 17),
            ),
          ),
          onPressed: onPressed,
        ));
  }
}
