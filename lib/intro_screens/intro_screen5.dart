import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';

class IntroScreen5 extends StatefulWidget {
  final double width;
  final double height;

  const IntroScreen5({Key key, this.width, this.height}) : super(key: key);

  @override
  _IntroScreen5State createState() => _IntroScreen5State();
}

class _IntroScreen5State extends State<IntroScreen5> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: widget.height * 30),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/last.png"), fit: BoxFit.fill)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.fromLTRB(
                widget.width * 8, widget.height * 15, widget.width * 8, 0),
            child: Column(
              children: [
                Text(
                  "Who Does More Work ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Some Points for every chore you for your Pet Look at Dashboard on weekly, monthly points with your group",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: greyColor,
                    ),
                  ),
                ),
                // indicatorSlide(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
