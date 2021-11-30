import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  final Function(String) message;
  final Function() onTap;
  const MessageView({Key key, @required this.message, @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Add a caption ...', border: InputBorder.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: CircleAvatar(
                radius: 25,
                child: InkWell(
                  onTap: onTap,
                  child: Icon(
                    Icons.send,
                    size: 30,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
