import 'package:flutter/material.dart';

class BoxComponent extends StatefulWidget {
  final String title;
  final int index;
  int pointer;
  Function(int index) onPressed;
  Widget child;
  String imageUrl;
  bool shouldSmall;
  BoxComponent({
    this.title,
    this.index,
    this.pointer,
    this.onPressed,
    this.shouldSmall,
    this.child,
    this.imageUrl = "",
  });
  @override
  _BoxComponentState createState() => _BoxComponentState();
}

class _BoxComponentState extends State<BoxComponent> {
  @override
  Widget build(BuildContext context) {
    widget.shouldSmall = widget.shouldSmall ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 8, 6),
      child: InkWell(
        splashColor: Colors.grey[700],
        onTap: () {
          widget.onPressed(widget.index);
          setState(() {
            widget.pointer = widget.index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.shouldSmall ? 10 : 12,
            vertical: widget.shouldSmall ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: widget.pointer == widget.index
                ? Color(0xff1A81FE)
                : Colors.transparent,
            border: Border.all(),
            borderRadius: BorderRadius.circular(5),
          ),
          // height: 50,
          // width: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: widget.imageUrl.startsWith("http")
                              ? NetworkImage(
                                  widget.imageUrl,
                                )
                              : AssetImage(
                                  widget.imageUrl,
                                ),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : Container(),
                widget.child ?? Container(),
                Text(
                  widget.title.length > 15
                      ? widget.title.substring(0, 15)
                      : widget.title,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: widget.pointer == widget.index
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.shouldSmall ? 12 : 14,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
