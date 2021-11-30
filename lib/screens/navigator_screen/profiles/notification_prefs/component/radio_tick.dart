import 'package:flutter/material.dart';

class RadioTick extends StatefulWidget {
  final Widget leftTitle;
  final Widget rightTitle;
  final Function(bool) isSelected;
  final bool isChecked;

  const RadioTick(
      {Key key,
      this.leftTitle,
      this.rightTitle,
      this.isSelected,
      this.isChecked})
      : super(key: key);
  @override
  _RadioTickState createState() => _RadioTickState();
}

class _RadioTickState extends State<RadioTick> {
  bool isChecked = false;
  var leftTitle;
  var rightTitle;
  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
    leftTitle = widget.leftTitle ?? Container();
    rightTitle = widget.rightTitle ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          setState(() {
            isChecked = !isChecked;
            widget.isSelected(isChecked);
          });
        },
        child: Row(
          children: [
            isChecked
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 30,
                  )
                : Icon(
                    Icons.check_circle_outline,
                    size: 30,
                  ),
            SizedBox(
              width: 10,
            ),
            leftTitle,
            Spacer(),
            rightTitle
          ],
        ),
      ),
    );
  }
}
