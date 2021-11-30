import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/service/network.dart';
import 'dart:convert';
import 'package:pets/common/gradient_bg.dart';

class CreateSchedule extends StatefulWidget {
  final scheduleType;
  final String petId;

  const CreateSchedule({Key key, this.scheduleType, this.petId})
      : super(key: key);
  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  String selectedActivityType = "Daily Care";
  LoadingProgressDialog loadingIndicator = new LoadingProgressDialog();
  GlobalKey<FormBuilderState> _csFormKey = GlobalKey<FormBuilderState>();
  _dailyCare() {
    return DropdownButton(
        isExpanded: true,
        value: selectedActivityType,
        items: ["Daily Care"].map((e) {
          return DropdownMenuItem(
            child: Text(e),
            value: e,
          );
        }).toList(),
        onChanged: (value) {});
  }

  List<Widget> columnWidgets = [];
  @override
  void initState() {
    columnWidgets.addAll([Text("Activity Type"), _dailyCare(), addTextBox(1)]);
    super.initState();
  }

  addTextBox(i) {
    i = i.toString();
    var textBox = Row(
      children: [
        Expanded(
          child: FormBuilderDateTimePicker(
            inputType: InputType.time,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
            decoration: CommonTextField.decoration.copyWith(
                labelText:
                    capitalize("${widget.scheduleType['type'] + " " + i} ")),
            name: "${widget.scheduleType['type'] + " " + i}",
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            if ((int.parse(i) + 1) > 2) {
              columnWidgets.removeAt(int.parse(i) + 1);
              setState(() {});
            } else {
              showToast("Minimum On Time is Required", context);
            }
          },
        )
      ],
    );
    return textBox;
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
            name: "Add ${widget.scheduleType['type']}", color: Colors.blue),
        body: Container(
          margin: EdgeInsets.only(bottom: padding * 3),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
              child: FormBuilder(
                key: _csFormKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: columnWidgets,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        columnWidgets.add(addTextBox(columnWidgets.length - 1));
                        setState(() {});
                      },
                      child: DottedBorder(
                        padding: EdgeInsets.all(10),
                        radius: Radius.circular(30),
                        color: Colors.blue,
                        strokeWidth: 2,
                        dashPattern: [
                          10,
                          6,
                        ],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              child: Icon(Icons.add),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add More",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    FormBuilderSwitch(
                      decoration: InputDecoration(border: InputBorder.none),
                      name: "reminder",
                      title: Text("Reminder"),
                      initialValue: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: RoundRectangleButton(
          onPressed: () async {
            if (_csFormKey.currentState.saveAndValidate()) {
              var values = _csFormKey.currentState.value;
              var times = [];
              var localTimeArray = [];

              for (var element in values.entries) {
                if (element.key.startsWith("meal") ||
                    element.key.startsWith("walk")) {
                  localTimeArray.add(element.value.toString().split(" ")[1]);
                  var utc = element.value.toUtc();

                  times.add((utc.hour * 60) + utc.minute);
                }
              }
              var postAbleData = {
                "name":
                    "${widget.scheduleType['type'].toString().toUpperCase()} REMINDER",
                "timeArray": times,
                "localTimeArray": localTimeArray,
                "type": widget.scheduleType['type'].toString().toUpperCase(),
                "taskUTCTime": "",
                "category": "DAILY CARE",
                "repeat": values['reminder'],
                "pet": widget.petId,
                "localDate": DateTime.now().toString().split(" ")[0],
                "mytimezone": DateTime.now().timeZoneName
              };
              print(postAbleData);
              loadingIndicator.show(context);
              var data = await RestRouteApi(context, ApiPaths.addTask)
                  .post(jsonEncode(postAbleData));
              loadingIndicator.hide(context);
              if (data != null) {
                showToast(data.message, context);
                Future.delayed(Duration(microseconds: 200))
                    .then((value) => Navigator.pop(context));
              }
            }
          },
          title: "Create Task",
        ),
      ),
    );
  }
}
