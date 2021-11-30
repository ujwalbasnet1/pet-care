import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/service/network.dart';
import 'dart:convert';
import 'package:pets/common/gradient_bg.dart';

class CustomActivity extends StatefulWidget {
  final scheduleType;
  final String petId;
  const CustomActivity({Key key, this.scheduleType, this.petId})
      : super(key: key);
  @override
  _CustomActivityState createState() => _CustomActivityState();
}

class _CustomActivityState extends State<CustomActivity> {
  LoadingProgressDialog loadingIndicator = new LoadingProgressDialog();
  GlobalKey<FormBuilderState> _csFormKey = GlobalKey<FormBuilderState>();
  String selectedActivityType = "Daily Care";
  _selectPet() {
    return DropdownButton(
        isExpanded: true,
        value: selectedActivityType,
        items: ["Daily Care", "Daily Care2"].map((e) {
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
    columnWidgets.addAll([Text("Activity Type"), _selectPet(), addTextBox(1)]);
    super.initState();
  }

  addTextBox(i) {
    i = i.toString();
    return CommonTextField(
      name: "${widget.scheduleType['type'] + " " + i}",
      labelText: "${widget.scheduleType['type'] + " " + i} ",
    );
  }

  @override
  Widget build(BuildContext context) {
    _dailyCare() {
      return FormBuilderDropdown(
          decoration:
              CommonTextField.decoration.copyWith(labelText: "Category"),
          initialValue: "FULL DAY EVENT",
          name: "category",
          items: ["FULL DAY EVENT"].map((e) {
            return DropdownMenuItem(
              child: Text(e),
              value: e,
            );
          }).toList(),
          onChanged: (value) {});
    }

    _points() {
      return FormBuilderDropdown(
          decoration: CommonTextField.decoration.copyWith(labelText: "Points"),
          initialValue: "10",
          name: "points",
          items: List.generate(10, (index) {
            var val = 5 * (index + 1);
            return DropdownMenuItem(
              child: Text("$val"),
              value: "$val",
            );
          }),
          onChanged: (value) {});
    }

    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
            name: "Add ${widget.scheduleType['type']}", color: Colors.blue),
        body: Container(
          // margin: EdgeInsets.only(bottom: padding * 3),
          child: SingleChildScrollView(
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(padding, padding, padding, padding * 4),
              child: FormBuilder(
                key: _csFormKey,
                child: Column(
                  children: [
                    _dailyCare(),
                    CommonTextField(name: "task_type", labelText: "Task Type"),

                    FormBuilderDateTimePicker(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      name: 'date',
                      // onChanged: _onChanged,
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      // initialValue: DateTime.now(),
                      // enabled: true,
                    ),
                    FormBuilderDateTimePicker(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      name: 'time',
                      // onChanged: _onChanged,
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'Time',
                      ),
                      // initialValue: DateTime.now(),
                      // enabled: true,
                    ),

                    // FormBuilderSwitch(
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.required(context),
                    //   ]),
                    //   decoration: CommonTextField.decoration
                    //       .copyWith(border: InputBorder.none),
                    //   name: "reminder",
                    //   title: Text("Reminder"),
                    //   initialValue: true,
                    // ),
                    // FormBuilderTextField(
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.required(context),
                    //   ]),
                    //   decoration: CommonTextField.decoration
                    //       .copyWith(labelText: "Other Comments"),
                    //   name: "comments",
                    // ),
                    _points()
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

              var utc = values['time'].toUtc();
              var time = values['time'].toString().split(" ")[1];

              var postAbleData = {
                "name": values['task_type'],
                "timeArray": [utc.millisecondsSinceEpoch],
                "localTimeArray": [time],
                "type": "CUSTOM",
                "taskUTCTime": values['date'].toUtc().millisecondsSinceEpoch,
                "category": "FULL DAY EVENT",
                "repeat": values['reminder'],
                "pet": widget.petId,
                "mytimezone": DateTime.now().timeZoneName,
                "localDate": DateTime.now().toString().split(" ")[0],
                "points": values['points']
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
          title: "Add Custom Task",
        ),
      ),
    );
  }
}
