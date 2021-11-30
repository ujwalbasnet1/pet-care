import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<String> list;
  final Widget child;
  final List<String> imageUrls;
  final Function(String title, int index) onPressed;
  final Function(Set selectedItems) getSelectedItem;
  final EdgeInsetsGeometry padding;
  final List<String> selectedItems;

  MultiSelect({
    this.list,
    this.child,
    this.imageUrls,
    this.onPressed,
    this.getSelectedItem,
    this.padding,
    this.selectedItems,
  });
  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  Set selectedItem = {};
  bool controller = false;
  @override
  void initState() {
    update();
    super.initState();
  }

  update() {
    for (var item in widget.selectedItems ?? []) {
      selectedItem.add(item);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: widget.padding ??
            const EdgeInsets.only(
              left: 15,
              right: 10,
            ),
        child: Row(
          children: [
            Row(
              children: List.generate(widget.list.length, (index) {
                return Box(
                  isSelected: selectedItem.contains(widget.list[index]),
                  imageUrl:
                      widget.imageUrls == null ? null : widget.imageUrls[index],
                  title: widget.list[index],
                  onPressed: (value) {
                    if (value) {
                      if (selectedItem.contains('ALL')) {
                        selectedItem.clear();
                      }

                      selectedItem.add(widget.list[index]);
                    } else {
                      selectedItem.remove(widget.list[index]);
                    }
                    widget.onPressed(widget.list[index], index);
                    widget.getSelectedItem(selectedItem);
                    setState(() {});
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class Box extends StatefulWidget {
  final String imageUrl;
  final Widget child;
  final String title;
  final bool isSelected;
  final Function(bool value) onPressed;
  final int pointer;
  Box({
    this.imageUrl,
    this.child,
    this.title,
    this.onPressed,
    this.pointer,
    this.isSelected = false,
  });
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  bool isSelected;
  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 7,
      ),
      child: InkWell(
        splashColor: Colors.grey[700],
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });

          widget.onPressed(isSelected);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff1A81FE) : Colors.transparent,
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
                              ? NetworkImage(widget.imageUrl)
                              : AssetImage(
                                  widget.imageUrl,
                                ),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : Container(),
                widget.child ?? Container(),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
