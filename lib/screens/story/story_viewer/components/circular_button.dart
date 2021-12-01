import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final String title;
  final Color color;
  final Color textColor;
  final MaterialColor iconColor;

  const CircularButton({
    Key key,
    this.onTap,
    this.icon,
    this.title = "",
    this.color,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          InkWell(
              onTap: () {},
              child: Icon(
                icon,
                size: 30,
                color: iconColor ?? Colors.red,
              )),
          Text(
            title,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
