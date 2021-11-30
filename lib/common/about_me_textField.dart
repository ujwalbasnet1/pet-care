import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget aboutMeTextField(
    {TextEditingController controller, String header, focusNode}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, top: 27),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xff353535),
              fontSize: 14),
        ),
        Container(
          height: 35,
          padding: const EdgeInsets.only(right: 18),
          child: TextField(
            focusNode: focusNode,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xff353535),
                fontSize: 16),
            decoration:
                InputDecoration(contentPadding: EdgeInsets.only(bottom: 10)),
            controller: controller,
          ),
        )
      ],
    ),
  );
}
