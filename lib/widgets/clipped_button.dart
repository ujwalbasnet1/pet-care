import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';

class ClippedButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double width;

  ClippedButton({@required this.title, this.onPressed, this.width});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(40))),
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
          // gradient: LinearGradient(
          //   colors: [const blueClassicColor, const blueClassicColor],
          // ),
          color: blueClassicColor,
          onPressed: onPressed),
    );
  }
}
