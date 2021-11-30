import 'package:flutter/material.dart';
import 'dart:math' as math;

class ResizebleWidget extends StatefulWidget {
  ResizebleWidget({
    Key key,
    this.child,
    this.size,
    this.parentRect,
    this.onSelect,
  }) : super(key: key);
  final Size size;
  final Widget child;
  final Rect parentRect;
  final Function(dynamic) onSelect;
  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState(size: size);
}

const ballDiameter = 20.0;

class _ResizebleWidgetState extends State<ResizebleWidget> {
  bool isShow = true;
  double height = 120;
  double width = 120;
  final Size size;
  double top = 0;
  double left = 0;
  final key = new GlobalKey();

  _ResizebleWidgetState({this.size}) {
    top = 0;
    //size.height / 3;
    left = 0;
    // size.width / 3;
  }

  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  bool isInside() {
    widget.onSelect(widget.key);
    final stateContext = key.currentContext;
    final Offset position = (stateContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
    final Size size = stateContext.size;
    final Rect rect = position & size;
    return widget.parentRect.contains(rect.center);
  }

  double _scale = 1;
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      Positioned(
        top: top,
        left: left,
        child: ManipulatingBall(
          child: Container(
            key: key,
            height: widget.size.height,
            width: widget.size.width,
            child: Transform.scale(
              scale: _scale,
              child: Center(
                child: widget.child,
              ),
            ),
          ),
          onTap: () {
            widget.onSelect(widget.key);
            setState(() {
              isShow = !isShow;
            });
          },
          onDrag: (dx, dy, deg, scale) {
            // print(dx);
            // if (!isInside()) return;
            isInside();
            double newTop = top + dy, newLeft = left + dx;

            setState(() {
              top = newTop;
              left = newLeft;
              _scale = scale;
              // height = height * scale;
              // width = width * scale;
            });
          },
        ),
      ),
    ];
    if (false)
      list.addAll(
        [
          Positioned(
            top: top - ballDiameter / 2,
            left: left - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var mid = (dx + dy) / 2;
                var newHeight = height - 2 * mid;
                var newWidth = width - 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top + mid;
                  left = left + mid;
                });
              },
            ),
          ),
          // top middle
          Positioned(
            top: top - ballDiameter / 2,
            left: left + width / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var newHeight = height - dy;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  top = top + dy;
                });
              },
            ),
          ),
          // top right
          Positioned(
            top: top - ballDiameter / 2,
            left: left + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var mid = (dx + (dy * -1)) / 2;

                var newHeight = height + 2 * mid;
                var newWidth = width + 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top - mid;
                  left = left - mid;
                });
              },
            ),
          ),
          // center right
          Positioned(
            top: top + height / 2 - ballDiameter / 2,
            left: left + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var newWidth = width + dx;

                setState(() {
                  width = newWidth > 0 ? newWidth : 0;
                });
              },
            ),
          ),
          // bottom right
          Positioned(
            top: top + height - ballDiameter / 2,
            left: left + width - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var mid = (dx + dy) / 2;

                var newHeight = height + 2 * mid;
                var newWidth = width + 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top - mid;
                  left = left - mid;
                });
              },
            ),
          ),
          // bottom center
          Positioned(
            top: top + height - ballDiameter / 2,
            left: left + width / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var newHeight = height + dy;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                });
              },
            ),
          ),
          // bottom left
          Positioned(
            top: top + height - ballDiameter / 2,
            left: left - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var mid = ((dx * -1) + dy) / 2;

                var newHeight = height + 2 * mid;
                var newWidth = width + 2 * mid;

                setState(() {
                  height = newHeight > 0 ? newHeight : 0;
                  width = newWidth > 0 ? newWidth : 0;
                  top = top - mid;
                  left = left - mid;
                });
              },
            ),
          ),
          //left center
          Positioned(
            top: top + height / 2 - ballDiameter / 2,
            left: left - ballDiameter / 2,
            child: ManipulatingBall(
              onDrag: (dx, dy, deg, scale) {
                var newWidth = width - dx;

                setState(() {
                  width = newWidth > 0 ? newWidth : 0;
                  left = left + dx;
                });
              },
            ),
          ),
        ],
      );

    return Stack(children: list);
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key key, this.onDrag, this.child, this.onTap});
  final Function() onTap;
  final Function onDrag;
  final Widget child;
  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;
  double initScale = 1;

  // _handleDrag(details) {
  //   setState(() {
  //     initX = details.globalPosition.dx;
  //     initY = details.globalPosition.dy;
  //   });
  // }

  // _handleUpdate(details) {
  //   var dx = details.globalPosition.dx - initX;
  //   var dy = details.globalPosition.dy - initY;
  //   initX = details.globalPosition.dx;
  //   initY = details.globalPosition.dy;
  //   widget.onDrag(dx, dy);
  // }
  _onScaleUpdate(ScaleUpdateDetails details) {
    var dx = details.focalPoint.dx - initX;
    var dy = details.focalPoint.dy - initY;
    initX = details.focalPoint.dx;
    initY = details.focalPoint.dy;
    var deg = details.rotation;
    var scale = details.scale == 1.0 ? initScale : details.scale;
    //  - initScale;
    initScale = scale;
    widget.onDrag(dx, dy, deg, scale);
  }

  _onScaleStart(ScaleStartDetails details) {
    setState(() {
      initX = details.focalPoint.dx;
      initY = details.focalPoint.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      // onPanStart: _handleDrag,
      // onPanUpdate: _handleUpdate,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: widget.child ??
          Container(
            width: ballDiameter,
            height: ballDiameter,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
    );
  }
}

class DRSView extends StatefulWidget {
  final Widget child;

  const DRSView({Key key, this.child}) : super(key: key);
  @override
  _DRSViewState createState() => _DRSViewState();
}

class _DRSViewState extends State<DRSView> {
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double _rotate = 0.0;
  double _initialScale = 1.0;
  double _initialRotate = 0.0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _offset + _sessionOffset,
      child: Transform.scale(
        scale: _scale,
        child: Transform.rotate(
          angle: math.pi * _rotate,
          child: GestureDetector(
            onScaleStart: (details) {
              _initialFocalPoint = details.focalPoint;
              _initialScale = _scale;
              _initialRotate = _rotate;
            },
            onScaleUpdate: (details) {
              setState(() {
                _sessionOffset = details.focalPoint - _initialFocalPoint;
                _scale = _initialScale * details.scale;
                _rotate =
                    details.rotation == 0 ? _initialRotate : details.rotation;
              });
            },
            onScaleEnd: (details) {
              setState(() {
                _offset += _sessionOffset;
                _sessionOffset = Offset.zero;
              });
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
