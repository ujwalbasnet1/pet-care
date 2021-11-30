import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final int currentPetNumber;
  final String title;
  final bool canBack;

  const Header(
      {Key key,
      this.currentPetNumber = 1,
      this.title = "Title",
      this.canBack = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          canBack
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : SizedBox(
                  width: 10,
                ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xff1A81FE),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
