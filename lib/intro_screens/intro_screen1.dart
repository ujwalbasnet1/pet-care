import 'package:flutter/material.dart';

class IntroScreen1 extends StatelessWidget {
  final double width;
  final double height;
  const IntroScreen1({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/bg_gradient.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            width * 15,
            height * 15,
            width * 15,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    width * 15,
                  ),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/gif/splash.gif",
                ),
              ),
              Column(
                children: [
                  Text(
                    "My Pets Life",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 33,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: height * 5,
                  ),
                  Text(
                    "Hello There !",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        letterSpacing: 2,
                        wordSpacing: 2),
                  ),
                  Text(
                    "Let us manage your Pet’s chores and make it fun. Score points among your loved ones and leave the headache to us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
