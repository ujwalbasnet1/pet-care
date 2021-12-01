import 'package:flutter/material.dart';
import 'package:pets/screens/story/story_viewer/components/circular_button.dart';

class ButttonView extends StatelessWidget {
  final String likes;
  final String shares;
  final String views;
  const ButttonView({Key key, this.likes, this.shares, this.views})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 30, bottom: 30),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularButton(
            color: Colors.transparent,
            icon: Icons.visibility_outlined,
            iconColor: Colors.red,
            title: views,
          ),
          CircularButton(
            color: Colors.transparent,
            icon: Icons.favorite_border,
            title: likes,
            iconColor: Colors.red,
          ),
          CircularButton(
            color: Colors.transparent,
            icon: Icons.share_outlined,
            title: views,
            iconColor: Colors.red,
          )
        ],
      ),
    );
  }
}
