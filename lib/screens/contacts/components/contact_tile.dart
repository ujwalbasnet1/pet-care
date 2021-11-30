import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatefulWidget {
  final Contact contact;
  final Function(String) onInvitePressed;
  const ContactTile({
    this.contact,
    this.onInvitePressed,
  });

  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  bool invited = false;

  String getName() {
    String result = widget.contact.phones.first.value.toString();
    if (widget.contact.displayName != null) {
      result = widget.contact.displayName;
    } else {
      if (widget.contact.givenName != "" && widget.contact.givenName != null) {
        result = widget.contact.givenName;
      }
      if (widget.contact.familyName != "" &&
          widget.contact.familyName != null) {
        result = widget.contact.familyName;
      }
      if (widget.contact.middleName != "" &&
          widget.contact.middleName != null) {
        result = widget.contact.middleName;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 1,
        horizontal: 20,
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: CircleAvatar(
                  child: Text(
                      "${widget.contact.initials() == "" ? "#" : widget.contact.initials()}"),
                ),
              ),
              Container(
                width: size.width / 2,
                child: Text(
                  getName(),
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 16,
                        color: Colors.indigo[900],
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 30,
            width: 80,
            child: InkWell(
              onTap: () {
                widget.onInvitePressed(widget.contact.phones.first.value);
                setState(() {
                  invited = true;
                });
              },
              child: Center(
                child: !invited
                    ? Text(
                        "Invite",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Invited",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          )
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
