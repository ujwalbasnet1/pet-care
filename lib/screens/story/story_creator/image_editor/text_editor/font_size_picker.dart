import 'dart:developer';

import 'package:flutter/material.dart';

class FontSizePicker extends StatefulWidget {
  final fontSize;
  final Function(double) onChange;
  const FontSizePicker({Key key, this.fontSize, @required this.onChange})
      : super(key: key);

  @override
  _FontSizePickerState createState() => _FontSizePickerState();
}

class _FontSizePickerState extends State<FontSizePicker> {
  double yPos = 10;
  final double maxHeight = 300;
  final double offset = 75;

  _handleDrag(Offset localPosition) {
    final double cPos = localPosition.dy;
    if (1 < cPos && cPos < maxHeight - 15) {
      setState(() {
        yPos = cPos;
      });

      widget.onChange((100 - (cPos / maxHeight) * 100) + offset);
    }
  }

  @override
  void initState() {
    initSize();

    super.initState();
  }

  initSize() {
    yPos = (widget.fontSize == null
        ? maxHeight - 20
        // : ((100 - widget.fontSize) / 100) * (maxHeight + widget.fontSize));
        : ((100 - widget.fontSize + offset) / 100) * maxHeight);

    log("ref" + (widget.fontSize).toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log("ref" + yPos.toString());
    return Container(
      height: maxHeight,
      child: GestureDetector(
          onPanDown: (details) => _handleDrag(details.localPosition),
          onPanUpdate: (details) => _handleDrag(details.localPosition),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ClipPath(
                clipper: CustomTriangleClipper(),
                child: Container(
                  width: 15,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Color(0xffF25D50), Color(0xffF2BB77)],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: yPos,
                  child: CircleAvatar(
                    radius: 8,
                  ))
            ],
          )),
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.60, size.height);
    path.lineTo(size.width * 0.40, size.height);
    // path.lineTo(size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
