import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/common/custom_selector.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/schedule_create/components/multi_select.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';

import 'package:pets/theming/common_size.dart';
import 'package:pets/service/network.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/common/gradient_bg.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  final missedNoti;
  const NotificationList({Key key, this.missedNoti}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  LoadingProgressDialog loadingProgressDialog = new LoadingProgressDialog();
  var petList;
  String pet = "";
  int time = 0;
  DateTime selectedDate;
  String selectedPets = 'ALL';
  @override
  void initState() {
    setCurrentScreen(ScreenName.notificationList);

    fetchData();
    super.initState();
  }

  fetchData() {
    if (widget.missedNoti == null) {
      if (mounted) {
        var d = DateTime.now().toString().split(" ")[0];
        time = (DateTime.parse(d).toUtc().millisecondsSinceEpoch) ~/ 1000;
        Future.delayed(Duration(microseconds: 100)).then((value) {
          getPets();
          getNotificationList(showLoading: false);
        });
      }
    } else {
      setState(() {
        notificationList = widget.missedNoti;
      });
    }
  }

  getPets() async {
    var uPro = context.read<UserProvider>();
    await uPro.fetchListData(context, force: false);
    var data = uPro.getPetListData;
    if (data != null) {
      setState(() {
        petList = data;
      });
    }

    return true;
  }

  var notificationList;

  getNotificationList({showLoading = true}) async {
    if (selectedPets == 'ALL') {
      var data = context
          .read<UserProvider>()
          .getPetList
          .map((e) => e['_id'])
          .toList()
          .join(",");
      selectedPets = data;
    }
    time = selectedDate != null
        ? (selectedDate.toUtc().millisecondsSinceEpoch) ~/ 1000
        : time;
    //selectedDate
    if (showLoading) LoadingProgressDialog().show(context);
    var data = await RestRouteApi(
            context,
            ApiPaths.getNotificationsFilter +
                "?time=${time.toString()}&pet=${selectedPets}")
        .get();

    if (data != null) {
      setState(() {
        notificationList = data['data'];
      });
    } else {
      notificationList = [];
    }
    if (showLoading) LoadingProgressDialog().hide(context);
    return true;
  }

  _selectDate() async {
    DateTime tempPickedDate = selectedDate;
    await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text('Done'),
                        onPressed: () {
                          setState(() {
                            selectedDate = tempPickedDate;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                Container(
                  height: 195,
                  child: CupertinoDatePicker(
                    initialDateTime: selectedDate ?? DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (time) {
                      setState(() {
                        tempPickedDate = time;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _decoration = InputDecoration(
        contentPadding: EdgeInsets.only(top: 10, left: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)));
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
          color: Colors.blue,
          context: context,
          name: widget.missedNoti == null
              ? "Notifications"
              : "Missed Notifications",
          centerTitle: false,
          actions: [
            widget.missedNoti != null
                ? Container()
                : TextButton(
                    onPressed: () async {
                      if (widget.missedNoti == null) {
                        await _selectDate();
                        getNotificationList();
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          selectedDate == null
                              ? "${DateTime.now().toString().substring(0, 10)}"
                              : "${selectedDate.toString().substring(0, 10)}",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
          ],
        ),
        body: FormBuilder(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              widget.missedNoti == null
                  ? Consumer(
                      builder: (BuildContext context, UserProvider uPro,
                          Widget child) {
                        List petInfoList = uPro.getPetList;
                        var petList = [
                          {"id": 'ALL', "name": 'ALL'}
                        ];
                        if (petInfoList != null) {
                          petInfoList.forEach((e) {
                            petList.add({
                              "id": e['_id'],
                              "name": e['name'],
                              "image": e['image']
                            });
                          });
                        }

                        selectedPets =
                            selectedPets.split(',').length == petInfoList.length
                                ? 'ALL'
                                : selectedPets;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CustomPicker(
                            // selectedItems: selectedPets,
                            initiallySelected: true,
                            selectedPointer: petList
                                .map<String>((e) => e['name'])
                                .toList()
                                .indexOf(selectedPets),
                            list:
                                petList.map<String>((e) => e['name']).toList(),
                            imageUrls:
                                petList.map<String>((e) => e['image']).toList(),

                            onPressed: (title, index) {
                              var id = petList[index]['id'];
                              selectedPets = id;
                              setState(() {});
                              getNotificationList();
                            },
                          ),
                        );
                      },
                    )
                  : Container(),
              Expanded(
                  child: notificationList == null
                      ? LoadingIndicator()
                      : notificationList.length == 0
                          ? LoadingIndicator(
                              imageUrl: "assets/gif/sad_dog.gif",
                              message: "Data Not Found",
                              textColor: Colors.black)
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: padding),
                              itemBuilder: (context, i) {
                                var e = notificationList[i];
                                var isDone = e['doneBy'] == null;
                                var doneBy = isDone
                                    ? e['group']['members'][0]['person']['_id']
                                    : e['doneBy']['_id'];
                                return ListTile(
                                  onTap: () {
                                    showEditDialog(e['name'], e['_id'],
                                        e['group']['members'], doneBy, isDone);
                                  },
                                  trailing: Icon(
                                    Icons.notifications,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  leading: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 18.0,
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(
                                            getAssetImage(e['type'])),
                                      ),
                                      Container(
                                          // padding: EdgeInsets.symmetric(
                                          //     vertical: 15),
                                          child: Text(
                                        "${e['localTime']}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  ),
                                  title: Text(e['name'] ?? ""),
                                  subtitle: Text(e['final_message'] ?? ""),
                                );
                              },
                              separatorBuilder: (_, i) => Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                              itemCount: notificationList.length)),
            ],
          ),
        ),
      ),
    );
  }

  void showEditDialog(name, id, members, ackBy, isDone) {
    GlobalKey<FormBuilderState> _formKeyNoti = GlobalKey<FormBuilderState>();
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 350,
              padding: const EdgeInsets.all(padding * 1),
              child: FormBuilder(
                key: _formKeyNoti,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who did this",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    CommonTextField(
                      readOnly: true,
                      name: "activity_type",
                      labelText: "Activity Type",
                      initialValue: name,
                    ),
                    FormBuilderDropdown(
                      name: "done_by",
                      initialValue: ackBy,
                      decoration: CommonTextField.decoration.copyWith(
                        labelText: isDone ? "Who did this?" : "Done by",
                      ),
                      items: members.map<DropdownMenuItem>((e) {
                        return DropdownMenuItem(
                          child: Text(e['person']['userInfo']['fname'] ?? ""),
                          value: e['person']['_id'],
                        );
                      }).toList(),
                    ),
                    Spacer(),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          color: Colors.red,
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text("Ok"),
                          onPressed: () async {
                            Navigator.pop(context);
                            _formKeyNoti.currentState.save();
                            var value = _formKeyNoti.currentState.value;
                            var sendAbleData = {
                              "clickType": "done",
                              "id": value['done_by'],
                              "notifyId": id,
                              "isFromSettings": true
                            };

                            LoadingProgressDialog().show(context);
                            var data = await RestRouteApi(
                                    context, ApiPaths.updateNotifications)
                                .post(jsonEncode(sendAbleData));
                            if (data != null) showToast(data.message, context);
                            await context
                                .read<UserProvider>()
                                .onScheduleChange(context);
                            getNotificationList();
                            LoadingProgressDialog().hide(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
