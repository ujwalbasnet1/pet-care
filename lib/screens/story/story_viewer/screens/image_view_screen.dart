import 'package:flutter/material.dart';
import 'gesture_controller.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  final Function() onNext;
  final Function() onPrevious;
  final Function() onDoubleTap;
  final Function() onLongPressStart;
  final Function() onLongPressEnd;
  final BoxFit fit;
  const ImageView(
      {Key key,
      @required this.imageUrl,
      @required this.onNext,
      @required this.onPrevious,
      @required this.onDoubleTap,
      @required this.onLongPressStart,
      @required this.onLongPressEnd,
      this.fit = BoxFit.fitWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: GestureController(
        child: imageUrl.length > 10
            ? Image.network(
                imageUrl,
                // cacheHeight: 300,
                // cacheWidth: 200,
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/images/bdog.png");
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.white.withAlpha(10),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    ),
                  );
                },
              )
            : Image.asset("assets/images/bdog.png"),
        onNext: onNext,
        onPrevious: onPrevious,
        onDoubleTap: onDoubleTap,
        onLongPressEnd: onLongPressEnd,
        onLongPressStart: onLongPressStart,
      )),
    );
  }
}
