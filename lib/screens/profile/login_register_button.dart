import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/gradientButton.dart';

class LoginRegisterButton extends StatelessWidget {
  final double width;
  final double height;

  const LoginRegisterButton({Key key, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: RaisedGradientButton(
                child: Text(
                  'Setup Google Home',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
                gradient: LinearGradient(
                  colors: [blueClassicColor, blueClassicColor],
                ),
                onPressed: () {
                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SignUpScreen())); */
                }),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: RaisedGradientButton(
                  child: Text(
                    'Setup Alexa',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  gradient: LinearGradient(
                    colors: [blueClassicColor, blueClassicColor],
                  ),
                  onPressed: () async {
                    // String url =
                    //     "https://developer.amazon.com/alexa/console/ask/build/custom/amzn1.ask.skill.2a4304e3-7c71-4365-bb7d-8371c6fcefcd/development/en_US/interfaces";
                    // if (await canLaunch(url)) {
                    //   await launch(url);
                    // } else {
                    //   throw 'Could not launch $url';
                    // }

                    // print('button clicked');
                    /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen())); */
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
