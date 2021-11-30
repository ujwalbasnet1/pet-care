import 'package:flutter/material.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/utils/app_utils.dart';

class AppointmentCard extends StatelessWidget {
  final String month;
  final String date;
  final String title;
  final double height;
  final double width;

  const AppointmentCard(
      {Key key,
      this.month = "January",
      this.date = "26",
      this.title = "Grooming",
      this.height,
      this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final color1 = Color(0xff5197FE);
    final color2 = blueClassicColor;
    final white = Colors.white;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300],
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(2, 2))
          ]),
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 55,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
              color: color2,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[300], color2]),
            ),
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: TextStyle(color: white),
                ),
                month == date
                    ? Container()
                    : Text(
                        date,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: white),
                      )
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                child: Text(
                  capitalize(title) ?? "No Title",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(0xff080040),
                        fontSize: 18,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
