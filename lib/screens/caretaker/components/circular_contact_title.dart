import 'package:flutter/material.dart';

import 'dart:typed_data';

class CircularContactTile extends StatelessWidget {
  final String name;
  final bool isSelected;
  final String prefix;
  final Uint8List avatar;

  CircularContactTile({this.name, this.isSelected, this.prefix, this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(50)),
            height: 40,
            width: 40,
            child: Center(
                child: Text(
              prefix,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isSelected == true ? Colors.black : Colors.grey,
                fontSize: 10),
          )
        ],
      ),
    );
  }
}
