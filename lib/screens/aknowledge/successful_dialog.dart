import 'dart:async';

import 'package:flutter/material.dart';

class SuccessfulDialog extends StatefulWidget {
  var data;
  SuccessfulDialog({this.data});
  @override
  _SuccessfulDialogState createState() => _SuccessfulDialogState();
}

class _SuccessfulDialogState extends State<SuccessfulDialog> {
  Timer _timer;
  int _start = 3;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.pop(context, true);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      //this right here
      child: new Container(
        height: 400,
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
          // color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
        ),
        child: new Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/checkmark.png",
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    "Successful",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontFamily: "ProximaNova-Bold",
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.data.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 18,
                    fontFamily: "ProximaNova-Regular",
                    fontWeight: FontWeight.normal,
                    wordSpacing: 0.5,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Pop will close in $_start",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
