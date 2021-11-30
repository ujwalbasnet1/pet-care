import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:pets/theming/theme.dart';
import 'package:pets/utils/static_variables.dart';

Future<void> errorMessageDialog(BuildContext context, {message}) async {
  if (isOhNoVisible) return;
  isOhNoVisible = true;
  // Navigator.pop(context);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Center(child: Text('Oh No !')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/gif/sad_dog.gif"),
                SingleChildScrollView(
                  child: Text(
                    message ?? 'Something Went Wrong',
                    textAlign: TextAlign.center,
                    style: latoTextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CLOSE'),
                onPressed: () {
                  isOhNoVisible = false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    },
  );
}

/// You cannot close this dialog
class AlertWithBackdrop extends StatelessWidget {
  final String message;
  const AlertWithBackdrop({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Center(child: Text('Oh No !')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/gif/sad_dog.gif"),
              SingleChildScrollView(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: latoTextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
