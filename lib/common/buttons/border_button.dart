import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final EdgeInsetsGeometry margin;
  final child;
  const BorderButton(
      {Key key,
      this.onPressed,
      this.title = "Continue",
      this.margin = const EdgeInsets.fromLTRB(30, 10, 30, 0),
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 50,
      width: 175,
      decoration: BoxDecoration(
        // color: Colors.amber,
        border: Border.all(width: 2, color: Colors.blueAccent),
        //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: child ??
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
          ),
        ),
        // color: blueClassicColor,
        onTap: onPressed,
      ),
    );
  }
}
