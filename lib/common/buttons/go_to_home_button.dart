import 'package:flutter/material.dart';
import 'package:pets/common/buttons/border_button.dart';

class GoToHomeButton extends StatelessWidget {
  final Function onPressed;
  GoToHomeButton({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return BorderButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Go to",
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Color(0xff1780FE),
                ),
          ),
          Icon(
            Icons.home,
            color: Color(0xff1780FE),
          ),
          Text(
            "Home",
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Color(0xff1780FE),
                ),
          ),
        ],
      ),
    );
  }
}
