import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pets/utils/app_utils.dart';
import 'avatar_progress_bar.dart';

class FamilyPointsDart extends StatelessWidget {
  final members;

  const FamilyPointsDart({Key key, this.members}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var memberLength = members.length;
    // ignore: unused_local_variable
    var minusValue = 100 / memberLength;

    return Container(
      width: double.infinity,
      child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(memberLength, (index) {
            var memberInfo = members[index]['person'];
            log(memberInfo.toString());
            var points = members[index]['points'];
            // var points = memberInfo['totalpoints'];
            var name = readObjectValue(memberInfo['userInfo'] ?? {}, 'fname');
            var avatar =
                readObjectValue(memberInfo['userInfo'] ?? {}, 'avatar');

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: AvatarProgressBar(
                index: index,
                points: points,
                name: name,
                avatar: avatar,
                length: index,
              ),
            );
          }).toList()
          // [
          //   Icon(
          //     Icons.group_add_outlined,
          //     size: 60,
          //     color: Colors.blue,
          //   ),
          //   Text(
          //     "Setup your Caretaker Group",
          //     style: TextStyle(fontSize: 18),
          //   )
          // ],
          ),
    );
  }
}
