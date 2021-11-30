import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/screens/five-steps/about_you.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:convert';
import 'package:pets/service/userid_store.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/utils/static_variables.dart';
import 'package:pets/service/app_pushs.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:pets/screens/auth_screens/login/login_screen.dart';
import 'package:pets/screens/auth_screens/sign_up/sign_up_screen.dart';
import 'package:pets/provider/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isRefered;
  final String referal;
  final bool isSignup;

  OTPScreen(
      {this.phoneNumber, this.isRefered = false, this.referal, this.isSignup});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var loadingIndicator = new LoadingProgressDialog();
  bool isRefered = false;
  var focusNode = FocusNode();
  final bool isAndroid = Platform.isAndroid;
  TimerProvider _timerProvider;
  @override
  void initState() {
    setCurrentScreen(ScreenName.otpScreen);
    focusNode.requestFocus();
    _timerProvider = Provider.of<TimerProvider>(context, listen: false);
    _timerProvider.startTimer(60);
    listenForCode();
    super.initState();
    isRefered = widget.isRefered;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _timerProvider.stopTimer();
    super.dispose();
  }

  listenForCode() async {
    await SmsAutoFill().listenForCode;
  }

  bool isTimeOver = false;

  bool showErrorMessage = false;

  onChanged(pin) async {
    if (pin.length == 4) {
      String deviceId = await PlatformDeviceId.getDeviceId;
      final String currentTimeZone =
          await FlutterNativeTimezone.getLocalTimezone();
      var body = {
        "phone": widget.phoneNumber,
        "type": "message",
        "deviceType": Platform.isAndroid ? "Android" : "IOS",
        "deviceID": deviceId,
        "otp": pin,
        "token": obtainedFirebaseToken,
        "timezone": currentTimeZone
      };
      loadingIndicator.show(context);
      var res = await RestRouteApi(context, ApiPaths.verify)
          .sendOtp(jsonEncode(body));
      loadingIndicator.hide(context);

      if (res != null) {
        SharedPref().storeStringValue("token", res['token']);
        token = res['token'];
        SharedPref().save("userData", res);
        showToast(res['message'], context);
        if (isRefered) {
          isCareTaker = true;
          var postableData = {
            "userID": res['user']['_id'],
            "referCode": widget.referal
          };
          RestRouteApi(context, ApiPaths.updateFcmToken).updateFirebaseToken();
          await RestRouteApi(context, ApiPaths.addByReferalCode)
              .post(jsonEncode(postableData));
        }
        context.read<TimerProvider>().stopTimer();
        Future.delayed(Duration(microseconds: 100)).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return res['isLogin'] ? BottomNavigation() : AboutYou();
          }));
        });
      }
    }
  }

  reSendCode() async {
    context.read<TimerProvider>().startTimer(60);
    loadingIndicator.show(context);
    var body = {
      "phone": (widget.phoneNumber),
      "type": "message",
      "deviceType": Platform.isAndroid ? "Android" : "IOS"
    };

    // ignore: unused_local_variable
    var res = await RestRouteApi(context, ApiPaths.send).post(jsonEncode(body));

    loadingIndicator.hide(context);
    listenForCode();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                minimum: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                          onPressed: () {
                            var screen = widget.isSignup
                                ? SignUpScreen()
                                : LoginScreen();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => screen));
                          },
                          icon: Icon(Icons.arrow_back)),
                    ),
                    Text(
                      "Phone Verification",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                child: Center(
                  child: Column(
                    // runAlignment: WrapAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAndroid
                            ? "Waiting to automatically detect an SMS sent to ${widget.phoneNumber}"
                            : "We have sent you an SMS with a code to the number ${widget.phoneNumber}.",
                        textAlign:
                            isAndroid ? TextAlign.left : TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600]),
                      ),
                      !isAndroid
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "To complete your phone number verification, please enter the 4-digit activation code.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600]),
                              ),
                            )
                          : Container(),
                      InkWell(
                        onTap: () {
                          var screen =
                              widget.isSignup ? SignUpScreen() : LoginScreen();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => screen));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Wrong Number?",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: 16,
                                      color: Color(
                                        0xff147FFF,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: Container(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(3, 6), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38.0),
                          child: PinFieldAutoFill(
                              decoration: UnderlineDecoration(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                colorBuilder: FixedColorBuilder(
                                  Colors.black.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              focusNode: focusNode,
                              onCodeChanged: onChanged, //code changed callback
                              codeLength: 4 //code length, default 6
                              ),
                        ),
                      ),
                    )),
              ),
              showErrorMessage == true
                  ? Text(
                      "Please Enter Correct OTP",
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              Consumer(
                builder: (context, TimerProvider tmPro, child) {
                  var remaingTime = tmPro.getRemainTime;
                  return remaingTime != 0
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListTile(
                            title: Text(
                              "Resend SMS",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                            ),
                            leading: Icon(
                              Icons.mail,
                              color: Colors.grey,
                            ),
                            trailing: Text(
                              "$remaingTime",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 29.0, left: 38),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Didn't you received any code?",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Click",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: InkWell(
                                        onTap: () => reSendCode(),
                                        child: Text(
                                          "Resend",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: blueClassicColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
