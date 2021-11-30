import 'package:flutter/material.dart';
import 'dart:typed_data';

class ContactTile extends StatelessWidget {
  final String name;
  final bool isSelected;
  final String prefix;
  final Uint8List avatar;

  ContactTile({this.name, this.isSelected, this.prefix, this.avatar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(50)),
            height: 40,
            width: 40,
            child: Center(
                child: Text(
              prefix,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
        Text(
          name,
          style:
              TextStyle(color: isSelected == true ? Colors.black : Colors.grey),
        )
      ],
    );
  }
}
