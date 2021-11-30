import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';

class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double radius;
  final double strokeWidth;
  final Gradient gradient;
  final bool isAnimated;

  AnimatedGradientBorder({
    Key key,
    @required this.strokeWidth,
    @required this.radius,
    @required this.gradient,
    @required this.child,
    this.isAnimated,
  }) : super(key: key);

  @override
  _AnimatedGradientBorderState createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with TickerProviderStateMixin {
  AnimationController _resizableController;
  double radius = 95;

  @override
  void initState() {
    radius += widget.isAnimated ? 25 : 0;
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );

    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      child: new AnimatedBuilder(
          animation: _resizableController,
          builder: (context, child) {
            return CustomPaint(
              painter: _GradientPainter(
                  strokeWidth: widget.strokeWidth +
                      (widget.isAnimated
                          ? (1 -
                              _resizableController.value * widget.strokeWidth)
                          : 0),
                  radius: widget.radius,
                  gradient: widget.gradient),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[widget.child],
                ),
              ),
            );
          }),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {@required double strokeWidth,
      @required double radius,
      @required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
