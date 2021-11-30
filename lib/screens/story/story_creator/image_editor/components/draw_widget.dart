import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DrawPage extends StatefulWidget {
  @override
  DrawPageState createState() => new DrawPageState();
}

class DrawPageState extends State<DrawPage> with TickerProviderStateMixin {
  AnimationController controller;
  List<Offset> points = <Offset>[];
  Color color = Colors.black;
  StrokeCap strokeCap = StrokeCap.round;
  double strokeWidth = 5.0;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  List<Painter> painterList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox object = context.findRenderObject();
              Offset localPosition =
                  object.globalToLocal(details.globalPosition);
              points = new List.from(points);
              points.add(localPosition);
            });
          },
          onPanStart: (DragStartDetails details) {
            log(painterList.length.toString());
            setState(() {
              painterList.add(Painter(
                  points: points.toList(),
                  color: color,
                  strokeCap: strokeCap,
                  strokeWidth: strokeWidth));
              points.clear();
              strokeCap = StrokeCap.round;
              strokeWidth = 5.0;

              color = Colors.amber;
            });
          },
          onPanEnd: (DragEndDetails details) => points.add(null),
          child: CustomPaint(
            painter: Painter(
                points: points,
                color: color,
                strokeCap: strokeCap,
                strokeWidth: strokeWidth,
                painters: painterList),
            size: Size.infinite,
          ),
        ),
      ),
      floatingActionButton:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        painterList.length > 0
            ? Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: controller,
                    curve:
                        Interval(0.0, 1.0 - 0 / 3 / 2.0, curve: Curves.easeOut),
                  ),
                  child: FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.clear),
                    onPressed: () {
                      painterList = [];
                      points.clear();
                      setState(() {});
                    },
                  ),
                ),
              )
            : Container(),
        painterList.length > 0
            ? Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: controller,
                    curve:
                        Interval(0.0, 1.0 - 0 / 3 / 2.0, curve: Curves.easeOut),
                  ),
                  child: FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.undo),
                    onPressed: () {
                      painterList.removeAt(painterList.length - 1);
                      setState(() {});
                    },
                  ),
                ),
              )
            : Container(),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: controller,
              curve: Interval(0.0, 1.0 - 1 / 3 / 2.0, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              mini: true,
              child: Icon(Icons.lens),
              onPressed: () {},
            ),
          ),
        ),
        Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: controller,
                  curve:
                      Interval(0.0, 1.0 - 2 / 3 / 2.0, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.color_lens),
                    onPressed: () async {
                      setState(() {
                        painterList.add(Painter(
                            points: points.toList(),
                            color: color,
                            strokeCap: strokeCap,
                            strokeWidth: strokeWidth));
                        points.clear();
                        strokeCap = StrokeCap.round;
                        strokeWidth = 5.0;

                        color = Colors.amber;
                      });
                      // Color temp;
                      // temp = await showDialog(
                      //     context: context,
                      //     builder: (context) => ColorDialog());
                      // if (temp != null) {
                      //   setState(() {
                      //     color = C;
                      //   });
                      // }
                    }))),
        FloatingActionButton(
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                transform: Matrix4.rotationZ(controller.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: Icon(Icons.brush),
              );
            },
          ),
          onPressed: () {
            if (controller.isDismissed) {
              controller.forward();
            } else {
              controller.reverse();
            }
          },
        ),
      ]),
    );
  }
}

class DrawWidgetPainter extends CustomPainter {
  // [DrawWidgetPainter] receives points through constructor
  // @points holds the drawn path in the form (x,y) offset;
  // This class responsible for drawing only
  // It won't receive any drag/touch events by draw/user.
  List<Offset> points = <Offset>[];
  Color color;
  DrawWidgetPainter({this.points, this.color = Colors.amber});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawWidgetPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class Painter extends CustomPainter {
  List<Offset> points;
  Color color;
  StrokeCap strokeCap;
  double strokeWidth;
  List<Painter> painters;

  Painter(
      {this.points,
      this.color,
      this.strokeCap,
      this.strokeWidth,
      this.painters = const []});

  @override
  void paint(Canvas canvas, Size size) {
    for (Painter painter in painters) {
      painter.paint(canvas, size);
    }

    Paint paint = new Paint()
      ..color = color
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => oldDelegate.points != points;
}
