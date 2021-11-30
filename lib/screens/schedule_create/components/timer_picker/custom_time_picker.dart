import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/box_component.dart';

class CustomPicker extends StatefulWidget {
  final int selectedPointer;
  final List<String> list;
  bool shouldSmall;
  final Widget child;
  final List<String> imageUrls;
  final Function(String title, int index) onPressed;
  final bool initiallySelected;
  final EdgeInsetsGeometry padding;
  CustomPicker({
    this.list,
    this.shouldSmall,
    this.child,
    this.imageUrls,
    this.onPressed,
    this.initiallySelected,
    this.padding,
    this.selectedPointer = 0,
  });
  @override
  _CustomPickerState createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int pointer = -1;
  List<String> items = [];
  bool isList;
  List<int> hourList = [];
  List<String> minuteList = [];
  List<String> urls = [];
  bool selected;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    init();
    pointer = widget.selectedPointer;
    super.initState();
  }

  void init() {
    if (widget.selectedPointer != null && widget.shouldSmall == null) {
      _animateToIndex(widget.selectedPointer);
    }
    selected = widget.initiallySelected ?? false;
    widget.shouldSmall = widget.shouldSmall ?? false;
    if (selected) {
      pointer = widget.selectedPointer;
    }
    if (widget.imageUrls != null) {
      for (int i = 0; i < widget.imageUrls.length; i++) {
        urls.add(widget.imageUrls[i]);
      }
    }
    if (widget.list != null) {
      isList = true;
      items = widget.list;
    } else {
      isList = false;
      for (int i = 1; i <= 12; i++) {
        hourList.add(i);
        for (int i = 0; i < 60; i += 30) {
          minuteList.add(i == 0 ? "00" : "$i");
        }
      }
    }
  }

  _animateToIndex(int i) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(i * 50.0,
            duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    for (int i = 0; i < (isList ? items.length : hourList.length); i++) {
      if (items.isNotEmpty) {
        _children.add(
          BoxComponent(
            title: items[i],
            index: i,
            pointer: pointer,
            onPressed: (index) {
              setState(() {
                pointer = index;
              });
              widget.onPressed(items[i], i);
            },
            shouldSmall: widget.shouldSmall,
            imageUrl: i < urls.length ? urls[i] : null,
          ),
        );
      } else {
        _children.add(BoxComponent(
          title: "${hourList[i]}:${minuteList[i]}",
          index: i,
          pointer: pointer,
          onPressed: (index) {
            widget.onPressed("${hourList[i]}:${minuteList[i]}", i);
            setState(() {
              pointer = index;
            });
          },
          shouldSmall: widget.shouldSmall,
        ));
      }
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: widget.padding ??
            const EdgeInsets.only(
              left: 15,
              right: 10,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _children,
        ),
      ),
    );
  }
}
