import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:pets/screens/auth_screens/phone_verification/otp_screen.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:platform_device_id/platform_device_id.dart';

handleOtp(
    String type,
    BuildContext context,
    TextEditingController _phoneNumberController,
    TextEditingController _referController,
    Country _selected) async {
  if (_phoneNumberController.text.length < 8) {
    showToast("Please Enter Valid Phone No.", context);
    return;
  }
  String countryCode = "1";
  if (_selected != null) {
    countryCode = _selected.dialingCode;
  }
  var fullNumber = "+" + countryCode + _phoneNumberController.text;
  var loadingIndicator = new LoadingProgressDialog();
  loadingIndicator.show(context);
  var body = {
    "phone": fullNumber,
    "type": type,
    "deviceType": Platform.isAndroid ? "Android" : "IOS",
    "deviceID": await PlatformDeviceId.getDeviceId
  };

  var res = await RestRouteApi(context, ApiPaths.send).post(jsonEncode(body));

  loadingIndicator.hide(context);

  if (res.message.contains("OTP SENT")) {
    showToast(res.message, context);
    // phoneAuthData.refer = _referController.text;
    openScreen(
        context,
        _referController != null
            ? OTPScreen(
                phoneNumber: fullNumber,
                isRefered: _referController.text.length > 5,
                isSignup: true,
                referal: _referController.text,
              )
            : OTPScreen(
                phoneNumber: fullNumber, isRefered: false, isSignup: false));
  }
}
