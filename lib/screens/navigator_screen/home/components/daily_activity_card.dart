import 'package:flutter/material.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/navigator_screen/home/components/circle_type.dart';
import 'package:pets/screens/schedule_create/components/type.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:provider/provider.dart';

class DailyActivityCard extends StatefulWidget {
  final String month;
  final String date;
  final String title;
  final double height;
  final double width;
  final String name;
  final String image;
  final String repeatType;
  final List<String> row;
  final bool initialSwitchValue;
  final Function(bool) onChanged;
  final Function() onSettingClicks;

  const DailyActivityCard(
      {Key key,
      this.month = "January",
      this.date = "26",
      this.title = "Grooming",
      this.height,
      this.width,
      this.name,
      this.image,
      this.row,
      this.initialSwitchValue = true,
      this.onChanged,
      this.onSettingClicks,
      this.repeatType})
      : super(key: key);

  @override
  _DailyActivityCardState createState() => _DailyActivityCardState();
}

class _DailyActivityCardState extends State<DailyActivityCard> {
  bool initialSwitchValue = false;
  @override
  void initState() {
    initialSwitchValue = widget.initialSwitchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(color: Color(0xff080040));

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300],
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(2, 2))
            ]),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: widget.width * 0.125,
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.center,
            child: !widget.image.toLowerCase().contains("walk")
                ? Image.asset(
                    widget.image,
                    fit: BoxFit.fitWidth,
                  )
                : Circular(
                    color: Colors.lightBlue[200],
                    imageUrl: getImageAssetUrl(ImageUrlType.walk),
                    borderColor: Colors.orange[300],
                  ),
            //  Icon(
            //   Icons.notification_important,
            //   size: width * 0.10,
            // ),
          ),
          title: SizedBox(
            height: 30,
            child: Row(
              children: [
                Text(
                  widget.name ?? "",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(0xff080040),
                      ),
                ),
                Spacer(),
                Row(
                  children: [
                    Switch(
                      inactiveThumbImage: AssetImage(
                        "assets/images/inactive.png",
                      ),
                      activeThumbImage: AssetImage(
                        "assets/images/active.png",
                      ),
                      // inactiveTrackColor: Colors.redAccent,
                      inactiveThumbColor: Colors.grey,
                      onChanged: (value) {
                        if (context.read<UserProvider>().getUserInfo.isMinor)
                          return;
                        initialSwitchValue = value;
                        widget.onChanged(value);
                        setState(() {});
                      },
                      value: initialSwitchValue,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 8,
                      ),
                      child: InkWell(
                        onTap: widget.onSettingClicks,
                        child: Icon(
                          Icons.settings,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                // IconButton(
                //   icon: Icon(Icons.settings),
                //   onPressed: () {},
                // )
              ],
            ),
          ),
          subtitle: Container(
            height: 30,
            child: ListView(
                scrollDirection: Axis.horizontal,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: List.generate(widget.row.length, (index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: Text(
                        // getTimeFromMinutes(int.parse(row[index]).toString()),
                        "${widget.row[index]}  ${widget.repeatType}",
                        // getTimeString(int.parse(row[index])),
                        style: textStyle,
                      ),
                    ),
                  );
                })),
          ),
          // trailing: Switch(
          //   onChanged: (bool value) {},
          //   value: true,
          // ),
        )
        /*   Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
              color: color2,
            ),
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(month,style: TextStyle(color: white),),
              Text(date,style: TextStyle(color: white),)
            ],),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left : 8.0),
            child: Expanded(
              child: Container(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
                ),
              ),
            ),
          )
        ],
      ),
     */

        );
  }
}
