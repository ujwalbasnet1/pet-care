import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndicatorSlider extends StatelessWidget {
  final int current;
  final int total;
  final double size;
  final Widget child;
  final String imageUrl;
  final Function(int index) onPressed;
  const IndicatorSlider({
    Key key,
    this.current,
    this.total,
    this.size = 30.0,
    this.child,
    this.imageUrl,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total, (index) {
            return InkWell(
              onTap: () {
                onPressed(index);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 2, left: 2),
                child: Container(
                  padding: EdgeInsets.all(.75),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: current == index
                        ? (imageUrl != null
                            ? Border.all(
                                width: 5,
                                color: Colors.blue,
                              )
                            : null)
                        : null,
                  ),
                  child: imageUrl != null
                      ? Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                              )),
                        )
                      : Container(
                          height: size / 5,
                          width: size / 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                current == index ? Colors.black : Colors.grey,
                          ),
                        ),
                ),
              ),
            );
          }).toList()),
    );
  }
}

var current = 2;
Widget indicatorSlide() {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 2, left: 2),
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == 2 ? Colors.grey : Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == 2 ? Colors.black : Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2, left: 2),
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == 2 ? Colors.grey : Colors.black),
          ),
        ),
      ],
    ),
  );
}
