import 'package:flutter/material.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_list/update_schedule.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';

class ScheduleComponents extends StatefulWidget {
  final String taskTitle;
  final int subTitleDueTime;
  final String timeUnit;
  final String time;
  final String imageUrl;
  final bool switchValue;
  final String taskType;
  final bool isExpired;
  final Function(bool) onChanged;
  final Function() onEdit;
  final String repeatType;
  ScheduleComponents({
    this.imageUrl,
    this.subTitleDueTime,
    this.timeUnit,
    this.taskTitle,
    this.time,
    this.switchValue = false,
    this.isExpired = false,
    this.onChanged,
    this.onEdit,
    this.taskType,
    this.repeatType,
  });
  @override
  _ScheduleComponentsState createState() => _ScheduleComponentsState();
}

class _ScheduleComponentsState extends State<ScheduleComponents> {
  String subTitle;
  void init() {
    var diff = getTimeDiff(widget.timeUnit);
    if (diff < 0) {
      subTitle = "Overdue $diff ago";
    } else {
      subTitle = "Due in $diff";
    }
  }

  bool initialSwitchValue = false;
  @override
  void initState() {
    initialSwitchValue = widget.switchValue;
    // init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 2,
        bottom: 2,
        right: 2,
      ),
      child: ListTile(
        onTap: () {
          // setState(() {
          //   switchValue = !switchValue;
          // });
        },
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 1, 0),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage(
                    getAssetImage(
                      widget.taskType,
                    ),
                  )),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 130,
                    child: Text(
                      widget.taskTitle ?? "Task Schedule",
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  widget.repeatType == ""
                      ? Container()
                      : Container(
                          width: 130,
                          child: Text(widget.repeatType ?? "",
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.blue)),
                        ),
                  // Container(
                  //   width: 130,
                  //   child: Text(subTitle ?? "Due in 1 hour",
                  //       overflow: TextOverflow.ellipsis,
                  //       style: Theme.of(context).textTheme.bodyText2),
                  // ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.pink,
                    ],
                  ),
                ),
                width: 60,
                height: 30,
                child: Text(
                  widget.time ?? "NA",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Switch(
                value: initialSwitchValue,
                onChanged: (value) {
                  if (context.read<UserProvider>().getUserInfo.isMinor) return;
                  initialSwitchValue = value;
                  widget.onChanged(value);
                  setState(() {});
                },
              ),
              widget.isExpired
                  ? FittedBox(
                      child: Text(
                        'EXPIRED',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : InkWell(
                      onTap: widget.onEdit,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff6D788F),
                              Color(0xff424A59),
                            ],
                          ),
                        ),
                        width: 35,
                        height: 30,
                        child: Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
