import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/schedule_create/components/picker_component.dart';

class Meal extends StatefulWidget {
  final List<Widget> list;
  final bool isFromCreateTask;
  final void Function(String time) getBreakfastTime;
  final void Function(String time) getLunchTime;
  final void Function(String time) getDinnerTime;
  final void Function(List list) onAdd;
  final void Function(List list) onRemove;

  Meal({
    this.list,
    this.getBreakfastTime,
    this.getDinnerTime,
    this.getLunchTime,
    this.isFromCreateTask,
    this.onAdd,
    this.onRemove,
  });

  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<Meal> {
  var padding = const EdgeInsets.symmetric(
    vertical: 5,
    horizontal: 20,
  );
  bool isAndroid = false;
  List _list = [];
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    _list = !widget.isFromCreateTask
        ? [
            {"name": "Breakfast", "time": "7:30 AM"},
            {"name": "Lunch", "time": "3:00 PM"},
            {"name": "Dinner", "time": "7:00 PM"}
          ]
        : [
            {"name": "Meal", "time": "7:30 AM"},
          ];
  }

  @override
  Widget build(BuildContext context) {
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_list.length, (index) {
              return PickerComponent(
                index: index,
                intialTime: _list[index]["time"],
                title: _list[index]["name"],
                canEdit: false,
                onCancelButtonPressed: null,
                // onCancelButtonPressed: index != 0
                //     ? (value) {
                //         setState(() {
                //           _list.removeAt(value);
                //         });
                //         widget.onRemove(_list);
                //       }
                //     : null,
                returnTime: (time) {
                  if (index == 0) {
                    widget.getBreakfastTime(time);
                  } else if (index == 1) {
                    widget.getLunchTime(time);
                  } else if (index == 2) {
                    widget.getDinnerTime(time);
                  } else {
                    widget.getBreakfastTime(time);
                    widget.getDinnerTime(time);
                    widget.getLunchTime(time);
                  }
                },
              );
            }),
          ),
          // Container(
          //   padding: EdgeInsets.all(20),
          //   child: InkWell(
          //     onTap: () {
          //       var tempData = {"name": "Meal", "time": "7:30 PM"};
          //       setState(() {
          //         _list.add(tempData);
          //       });

          //       widget.onAdd(_list);
          //     },
          //     child: DottedBorder(
          //       padding: EdgeInsets.all(10),
          //       radius: Radius.circular(30),
          //       color: Colors.blue,
          //       strokeWidth: 2,
          //       dashPattern: [
          //         10,
          //         6,
          //       ],
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           CircleAvatar(
          //             radius: 15,
          //             child: Icon(Icons.add),
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Text(
          //             "Add More",
          //             style: TextStyle(fontSize: 18),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pets/screens/schedule_create/components/picker_component.dart';

// class Meal extends StatefulWidget {
//   final List<Widget> list;
//   final void Function(String time) getBreakfastTime;
//   final void Function(String time) getLunchTime;
//   final void Function(String time) getDinnerTime;
//   final void Function() onAdd;
//   final void Function() onRemove;
//   Meal({
//     this.list,
//     this.getBreakfastTime,
//     this.getDinnerTime,
//     this.getLunchTime,
//     this.onAdd,
//     this.onRemove,
//   });

//   @override
//   _MealState createState() => _MealState();
// }

// class _MealState extends State<Meal> {
//   var padding = const EdgeInsets.symmetric(
//     vertical: 5,
//     horizontal: 20,
//   );
//   bool isAndroid = false;
//   List<String> _list = ["Breakfast", "Lunch", "Dinner"];
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Column(
//         children: [
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: List.generate(
//               _list.length,
//               (index) {
//                 return PickerComponent(
//                   index: index,
//                   title: _list[index],
//                   onCancelButtonPressed: (value) {
//                     setState(() {
//                       _list.removeAt(value);
//                     });
//                     widget.onRemove();
//                   },
//                   returnTime: (time) {
//                     if (index == 0) {
//                       widget.getBreakfastTime(time);
//                     } else if (index == 1) {
//                       widget.getLunchTime(time);
//                     } else if (index == 2) {
//                       widget.getDinnerTime(time);
//                     } else {
//                       print("Can not return time, see meal.dart file");
//                     }
//                   },
//                 );
//               },
//             ),
//             // children: [
//             //   PickerComponent(
//             //     index: 0,
//             //     title: "Breakfast",
//             //     returnTime: (time) {
//             //       widget.getBreakfastTime(time);
//             //     },
//             //   ),
//             //   PickerComponent(
//             //     index: 1,
//             //     title: "Lunch",
//             //     onCancelButtonPressed: (value) {},
//             //     returnTime: (time) {
//             //       // print(time);
//             //       widget.getLunchTime(time);
//             //     },
//             //   ),
//             //   PickerComponent(
//             //     index: 2,
//             //     title: "Dinner",
//             //     onCancelButtonPressed: (value) {},
//             //     returnTime: (time) {
//             //       // print(time);
//             //       widget.getDinnerTime(time);
//             //     },
//             //   ),
//             // ],
//           ),
// Container(
//   padding: EdgeInsets.all(20),
//   child: InkWell(
//     onTap: () {
//       setState(() {
//         _list.add("New Task");
//       });
//       widget.onAdd();
//     },
//     child: DottedBorder(
//       padding: EdgeInsets.all(10),
//       radius: Radius.circular(30),
//       color: Colors.blue,
//       strokeWidth: 2,
//       dashPattern: [
//         10,
//         6,
//       ],
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 15,
//             child: Icon(Icons.add),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           Text(
//             "Add More",
//             style: TextStyle(fontSize: 18),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
//         ],
//       ),
//     );
//   }
// }
