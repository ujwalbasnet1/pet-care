import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndicatorSliderHome extends StatelessWidget {
  final double size;
  final Widget child;
  final String imageUrl;
  final bool isSelected;
  final Function() onPressed;
  const IndicatorSliderHome({
    Key key,
    this.size = 30.0,
    this.child,
    this.imageUrl,
    this.onPressed,
    this.isSelected = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 2, left: 2),
            child: Container(
              padding: EdgeInsets.all(.75),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? (imageUrl != null
                        ? Border.all(
                            width: 3.5,
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
                              fit: BoxFit.cover)),
                    )
                  : Container(
                      height: size / 5,
                      width: size / 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                    ),
            ),
          ),
        ));
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
