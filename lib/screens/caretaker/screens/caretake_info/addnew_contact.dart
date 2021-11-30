import 'package:flutter/material.dart';
import 'package:pets/common/app_bar.dart';
import 'package:pets/theming/theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/service/userid_store.dart';
import 'dart:convert';

class AddNewContact extends StatefulWidget {
  final groupId;
  final referCode;

  const AddNewContact({Key key, this.groupId, this.referCode})
      : super(key: key);
  @override
  _AddNewContactState createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  var isGenerated = false;
  var qrInfo = {};

  @override
  void initState() {
    setCurrentScreen(ScreenName.addNewContact);
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    var userData = await SharedPref().read("userData");

    setState(() {
      qrInfo['phone'] = userData['user']['phone'];
      qrInfo['parentId'] = userData['user']['_id'];
      qrInfo['groupId'] = widget.groupId;
      qrInfo['referCode'] = widget.referCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:
            appBarWidget(color: Colors.blue, name: "Add New Contact", actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]),
        body: Container(
          padding: EdgeInsets.all(padding),
          child: FormBuilder(
            child: Column(
              children: [
                // CommonTextField(
                //   labelText: "Name",
                //   name: "name",
                // ),
                CommonTextField(
                  labelText: "Type",
                  name: "type",
                  readOnly: true,
                  initialValue: "Minor",
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    QrImage(
                      data: jsonEncode(qrInfo) ?? "ABC",
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: padding),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.blue),
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(padding),
                      child: Text(
                        "PLEASE ASK MINOR TO SCAN THIS QR CODE TO ADD TO THE CARETAKER GROUP",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
