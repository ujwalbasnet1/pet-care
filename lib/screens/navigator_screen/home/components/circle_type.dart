import 'package:flutter/material.dart';

class Circular extends StatefulWidget {
  final String imageUrl;
  final Color borderColor;
  final Color color;

  Circular({
    this.color,
    this.imageUrl,
    this.borderColor,
  });
  @override
  CircularState createState() => CircularState();
}

class CircularState extends State<Circular> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: widget.borderColor ?? Colors.orange,
                ),
                color: widget.color,
                borderRadius: BorderRadius.circular(29),
              ),
              child: Image(
                image: AssetImage(widget.imageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
