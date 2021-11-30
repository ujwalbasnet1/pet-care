import 'package:flutter/material.dart';

class LoadingProgressDialog {
  bool isVisible = false;
  show(BuildContext context, {message}) {
    isVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingIndicator(message: message);
      },
    );
  }

  hide(BuildContext context) {
    isVisible = false;
    Navigator.pop(context);
  }
}

class LoadingIndicator extends StatelessWidget {
  final String message;
  final String imageUrl;
  final Color textColor;
  final Function() onPressed;

  const LoadingIndicator({
    Key key,
    this.message = "Loading ...",
    this.imageUrl,
    this.textColor,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: onPressed == null ? 250 : 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  height: message != null ? 150 : 130,
                  child:
                      Image.asset(imageUrl ?? "assets/gif/loading_colored.gif"),
                ),
                Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      message ?? "Loading ...",
                      style: TextStyle(
                          fontSize: 22, color: textColor ?? Colors.white),
                    )),
                onPressed == null
                    ? Container()
                    : ElevatedButton(
                        onPressed: onPressed, child: Text("Refresh"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
