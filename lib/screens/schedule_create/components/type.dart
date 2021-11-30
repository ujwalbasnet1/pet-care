import 'package:flutter/material.dart';

class CircleType extends StatefulWidget {
  final String title;
  final String imageUrl;
  final Color borderColor;
  final Color selectedColor;
  final Color unSelectedColor;
  final Function(bool isSelected) onPressed;
  final bool isSelected;
  final int self;
  final int pointer;
  CircleType({
    this.title,
    this.imageUrl,
    this.borderColor,
    this.selectedColor,
    this.unSelectedColor,
    this.onPressed,
    this.isSelected,
    this.pointer,
    this.self,
  });
  @override
  CircleTypeState createState() => CircleTypeState();
}

class CircleTypeState extends State<CircleType> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.self == widget.pointer ? true : false;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        widget.onPressed(isSelected);
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        child: Column(
          children: [
            // Icon(
            //   Icons.download_done_rounded,
            //   color: isSelected ? Colors.green : Colors.grey[300],
            // ),
            isSelected
                ? Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage("assets/images/checked.png"),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                border: Border.all(
                  width: isSelected ? 2 : 0,
                  color: widget.borderColor ?? Colors.orange,
                ),
                color:
                    isSelected ? widget.selectedColor : widget.unSelectedColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: Image(
                image: AssetImage(widget.imageUrl),
              ),
            ),
            // CircleAvatar(
            //   backgroundColor: Colors.white60,
            //   radius: 35,
            //   backgroundImage: AssetImage(widget.imageUrl),
            // ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${widget.title}",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
