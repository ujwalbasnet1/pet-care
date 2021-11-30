import 'package:flutter/material.dart';
import 'package:pets/screens/auth_screens/login/login_screen.dart';
import 'package:pets/screens/auth_screens/sign_up/sign_up_screen.dart';

class SignInSignUpButtons extends StatefulWidget {
  @override
  _SignInSignUpButtonsState createState() => _SignInSignUpButtonsState();
}

class _SignInSignUpButtonsState extends State<SignInSignUpButtons> {
  _halfRoundedButton({bool left = true, String title = "title", onTap}) {
    return Material(
      borderOnForeground: false,
      elevation: 9.0,
      color: Colors.blue,
      borderRadius: left
          ? BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            )
          : BorderRadius.only(
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              // border: Border.symmetric(vertical: BorderSide()),
              borderRadius: left
                  ? BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    )),
          child: Center(
              child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _halfRoundedButton(
              title: "SIGN IN",
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              }),
          Container(
            width: 2,
            color: Colors.black,
          ),
          _halfRoundedButton(
              title: "SIGN UP",
              left: false,
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ));
              }),
        ],
      ),
    );
  }
}
