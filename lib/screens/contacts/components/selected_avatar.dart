import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class SelectedAvatar extends StatelessWidget {
  final Contact contact;
  final Function onTap;
  SelectedAvatar({this.contact, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(
                  contact.initials() == "" ? "#" : contact.initials(),
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Positioned(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14)),
                      child: Icon(
                        Icons.cancel,
                        size: 28,
                      ),
                    ),
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: 64,
          alignment: Alignment.center,
          child: Text(
            contact.displayName,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
