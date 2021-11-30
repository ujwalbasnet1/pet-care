import 'package:flutter/material.dart';

class SquareCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final double width;

  const SquareCard(
      {Key key,
      this.icon = Icons.medical_services_outlined,
      this.title = "Age",
      this.value = "5 years",
      this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color light = Color(0x1f24B7A3);
    final Color dark = Color(0xff24B7A3);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: light,
          border: Border.all(color: dark)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Icon(
                icon,
                size: width / 12,
                color: dark,
              )),
          FittedBox(
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 10, color: dark),
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
