import 'package:flutter/material.dart';
import 'package:pets/screens/auth_screens/login/login_screen.dart';
import 'package:pets/screens/auth_screens/sign_up/sign_up_screen.dart';
import 'package:pets/widgets/clipped_button.dart';

class LoginRegisterButton extends StatelessWidget {
  final double width;
  final double height;

  const LoginRegisterButton({Key key, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClippedButton(
            width: width * 50,
            title: 'Register for FREE',
            onPressed: () {
              // print('button clicked');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignUpScreen()));
            },
          ),
          SizedBox(
            height: 10,
          ),
          ClippedButton(
              width: width * 50,
              title: 'Login for FREE',
              onPressed: () {
                // print('button clicked');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              }),
        ],
      ),
    );
  }
}
