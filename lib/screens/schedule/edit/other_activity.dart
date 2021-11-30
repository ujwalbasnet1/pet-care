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
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';

class OtherActivity extends StatefulWidget {
  final data;
  final String petId;
  const OtherActivity({Key key, this.data, this.petId}) : super(key: key);
  @override
  _OtherActivityState createState() => _OtherActivityState();
}

class _OtherActivityState extends State<OtherActivity> {
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
      name: "${widget.data['type'] + " " + i}",
      labelText: "${widget.data['type'] + " " + i} ",
    );
  }

  @override
  Widget build(BuildContext context) {
    _dailyCare() {
      return FormBuilderDropdown(
          decoration:
              CommonTextField.decoration.copyWith(labelText: "Category"),
          initialValue: "Daily Care",
          name: "category",
          items: ["Daily Care"].map((e) {
            return DropdownMenuItem(
              child: Text(e),
              value: e,
            );
          }).toList(),
          onChanged: (value) {});
    }

    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
            name: "Update ${widget.data['type']}",
            color: Colors.blue,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    if (context.read<UserProvider>().getUserInfo.isMinor) {
                      showToast("Minor Cannot Delete a Task", context);
                      return;
                    }

                    var body = {
                      "id": widget.data['_id'],
                    };
                    LoadingProgressDialog().show(context, message: "Deleting");
                    var res = await RestRouteApi(context, ApiPaths.deleteTask)
                        .post(jsonEncode(body));

                    if (res != null) if (res.status.toString().toLowerCase() ==
                        "success") {
                      context
                          .read<UserProvider>()
                          .fetchTask(context, widget.data['pet'], force: true);
                      showToast("Deleted", context);
                      Future.delayed(Duration(microseconds: 200))
                          .then((value) => Navigator.pop(context));

                      // members.removeAt(index);
                    }
                    LoadingProgressDialog().hide(context);
                  })
            ]),
        body: Container(
          margin: EdgeInsets.only(bottom: padding * 3),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
              child: FormBuilder(
                key: _csFormKey,
                child: Column(
                  children: [
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: columnWidgets,
                    // ),
                    _dailyCare(),
                    FormBuilderDropdown(
                      initialValue: widget.data['type'],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      decoration: CommonTextField.decoration
                          .copyWith(labelText: "Task Type"),
                      items: [
                        "MEAL",
                        "WALK",
                        "BATH",
                        "CLEAN UP",
                        "VET",
                        "PLAY DATE",
                        "GROOMING",
                        "BRUSH TEETH"
                      ].map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      name: "task_type",
                      hint: Text("Select Task"),
                    ),
                    FormBuilderDateTimePicker(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      name: 'date',
                      // onChanged: _onChanged,
                      inputType: InputType.time,
                      decoration: CommonTextField.decoration.copyWith(
                        labelText: 'Appointment Time',
                      ),
                      // initialTime: TimeOfDay(hour: 8, minute: 0),
                      initialValue: DateTime.parse(
                          "${widget.data['localDate']} ${widget.data['localTime']}"),
                      // enabled: true,
                    ),

                    FormBuilderTextField(
                      decoration: CommonTextField.decoration
                          .copyWith(labelText: "Other Comments"),
                      name: "comments",
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
              var utc = values['date'].toUtc();
              var localTimeArray = [values['date'].toString().split(" ")[1]];
              var postAbleData = {
                "id": widget.data['_id'],
                "name":
                    "${widget.data['type'].toString().toUpperCase()} REMINDER",
                "timeArray": [((utc.hour * 60) + utc.minute)],
                "type": values['task_type'],
                "taskUTCTime": "",
                "localTimeArray": localTimeArray[0],
                "category": "DAILY CARE",
                "repeat": values['reminder'],
                "comments": values['task_type'],
                "pet": widget.data['pet'],
                "localDate": DateTime.now().toString().split(" ")[0],
                "mytimezone": DateTime.now().timeZoneName
              };
              print(postAbleData);

              loadingIndicator.show(context);
              var data = await RestRouteApi(context, ApiPaths.editTask)
                  .post(jsonEncode(postAbleData));
              context
                  .read<UserProvider>()
                  .fetchTask(context, widget.data['pet'], force: true);
              if (data != null) {
                showToast(data.message, context);
                Future.delayed(Duration(microseconds: 200))
                    .then((value) => Navigator.pop(context));
              }
              loadingIndicator.hide(context);
            }
          },
          title: "Update Task",
        ),
      ),
    );
  }
}
