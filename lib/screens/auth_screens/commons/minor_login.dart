import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/screens/five-steps/about_you.dart';
import 'package:pets/service/network.dart';
import 'package:pets/service/userid_store.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/utils/static_variables.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:platform_device_id/platform_device_id.dart';

Future<void> minorLogin(BuildContext context) async {
  try {
    String qrCode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    if (qrCode != "-1") {
      showEditDialog(qrCode, context);
    }
    // sendText(barcode);
  } on PlatformException {}
}

void showEditDialog(qRData, BuildContext context) {
  GlobalKey<FormBuilderState> _formKeyMinor = GlobalKey<FormBuilderState>();
  _onLoginButtonClick() async {
    if (_formKeyMinor.currentState.saveAndValidate()) {
      var val = _formKeyMinor.currentState.value;
      if (val['minorName'] != null) {
        isCareTaker = true;
        userName = val['minorName'];
        var postableData = jsonDecode(qRData);

        postableData['deviceID'] = await PlatformDeviceId.getDeviceId;
        postableData['deviceType'] = Platform.isAndroid ? "Android" : "IOS";

        postableData['minorName'] = val['minorName'];

        Navigator.pop(context);
        LoadingProgressDialog().show(context);
        var res = await RestRouteApi(context, ApiPaths.addMinor)
            .sendOtp(jsonEncode(postableData));

        if (res != null) {
          showToast(res['message'], context);
          SharedPref().storeStringValue("token", res['token']);
          token = res['token'];
          SharedPref().save("userData", res);
          showToast(res['message'], context);

          var referalData = {
            "userID": res['user']['_id'],
            "referCode": postableData['referCode']
          };
          RestRouteApi(context, ApiPaths.updateFcmToken).updateFirebaseToken();
          await RestRouteApi(context, ApiPaths.addByReferalCode)
              .post(jsonEncode(referalData));

          Future.delayed(Duration(microseconds: 100)).then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return res['isLogin'] ? BottomNavigation() : AboutYou();
            }));
          });
        }

        LoadingProgressDialog().hide(context);
      } else {
        showToast("Please Enter User Name", context);
      }
    }
  }

  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Container(
              height: 400,
              padding: const EdgeInsets.all(padding * 2),
              child: Center(
                child: FormBuilder(
                  key: _formKeyMinor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Your Minor Name",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      CommonTextField(
                        name: "minorName",
                        labelText: "Minor Name",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: blueClassicColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Container(
                            width: 110,
                            child: RoundRectangleButton(
                              margin: EdgeInsets.all(0),
                              title: "Login",
                              onPressed: _onLoginButtonClick,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
