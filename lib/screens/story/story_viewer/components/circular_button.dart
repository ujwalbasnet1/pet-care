import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final String title;
  final Color color;
  final MaterialColor iconColor;
  const CircularButton({
    Key key,
    this.onTap,
    this.icon,
    this.title = "",
    this.color = Colors.blue,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          InkWell(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: color,
                radius: 25,
                child: Icon(
                  icon,
                  size: 30,
                  color: iconColor ?? Colors.white,
                ),
              )),
          Text(
            title,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }
}
