import 'package:flutter/material.dart';

class ApiProgressIndicator extends StatelessWidget {
  final String msg;

  const ApiProgressIndicator({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return msg != null
        ? Container(
            child: Center(
              child: Text(
                msg,
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
