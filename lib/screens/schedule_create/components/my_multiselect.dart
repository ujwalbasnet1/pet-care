import 'dart:developer';

import 'package:flutter/material.dart';

class MyMultiSelect extends StatefulWidget {
  final List list;
  final Widget child;
  final List<String> imageUrls;
  final Function(List<String>) onSelected;
  final EdgeInsetsGeometry padding;
  final List<String> selectedItems;
  final bool isInitiallySelected;

  MyMultiSelect({
    this.list,
    this.child,
    this.imageUrls,
    this.padding,
    this.selectedItems,
    this.onSelected,
    this.isInitiallySelected = false,
  });
  @override
  _MyMultiSelectState createState() => _MyMultiSelectState();
}

class _MyMultiSelectState extends State<MyMultiSelect> {
  List<String> dataList = [];
  @override
  void initState() {
    if ((widget.selectedItems != null) && widget.isInitiallySelected) {
      dataList = widget.selectedItems;
    } else {
      dataList.add('ALL');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 7,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          var data = widget.list[index];
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            child: InkWell(
              splashColor: Colors.grey[700],
              onTap: () {
                if (data['id'] == 'ALL') {
                  dataList.clear();
                  if (isSelected('ALL')) {
                    dataList.remove('ALL');
                  } else {
                    dataList.add('ALL');
                    // dataList.addAll(
                    //     widget.list.map<String>((e) => e['id']).toList());
                  }
                } else {
                  if (dataList.contains(data['id'])) {
                    dataList.remove(data['id']);
                    dataList.remove('ALL');
                  } else {
                    dataList.add(data['id']);
                    dataList.remove('ALL');
                  }
                }

                dataList = dataList.toSet().toList();
                // if (dataList.contains('ALL')) {
                //   widget.onSelected(
                //       widget.list.map<String>((e) => e['id']).toList());
                // } else {
                widget.onSelected(dataList);
                // }
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected(data['id'])
                      ? Color(0xff1A81FE)
                      : Colors.transparent,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      data['image'] != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    data['image'].startsWith("http")
                                        ? NetworkImage(data['image'])
                                        : AssetImage(
                                            data['image'],
                                          ),
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : Container(),
                      widget.child ?? Container(),
                      Text(
                        data['name'],
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: isSelected(data['id'])
                                  ? Colors.white
                                  : Colors.black,
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
        },
      ),
    );
  }

  bool isSelected(item) {
    return dataList.contains(item);
  }
}
