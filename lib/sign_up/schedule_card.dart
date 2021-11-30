import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScheduleCard extends StatefulWidget {
  final String petImage;
  final int noofFeeds;
  final timediff;
  final String name;

  final String category;
  final String type;
  final String localTime;
  final Function(bool) onChanged;
  final Function() onDelete;
  final Function() onEdit;
  final bool initialSwitchValue;

  const ScheduleCard(
      {Key key,
      this.petImage,
      this.noofFeeds,
      this.timediff,
      this.name,
      this.category,
      this.type,
      this.localTime,
      this.onChanged,
      this.initialSwitchValue,
      this.onDelete,
      this.onEdit})
      : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  bool initialSwitchValue = false;
  @override
  void initState() {
    initialSwitchValue = widget.initialSwitchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      AssetImage(widget.petImage ?? "assets/images/updog1.png"),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      widget.category,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "${widget.type}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Switch(
                          onChanged: (value) {
                            initialSwitchValue = value;
                            widget.onChanged(value);
                            setState(() {});
                          },
                          value: initialSwitchValue,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xffB122FF),
                              border: Border.all(
                                color: Color(0xffB122FF),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 8.0),
                            child: Text(
                              "${(widget.localTime ?? '16:00:00.000').substring(0, 5)}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: widget.onDelete),
            IconSlideAction(
                caption: 'Edit',
                color: Colors.blue,
                icon: Icons.edit,
                onTap: widget.onEdit),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
