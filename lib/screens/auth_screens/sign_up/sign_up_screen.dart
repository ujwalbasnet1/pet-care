import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/need_help_button.dart';
import 'package:pets/screens/auth_screens/commons/handle_otp.dart';
import 'dart:async';
import 'package:pets/widgets/clipped_button.dart';
import 'package:pets/utils/static_variables.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/screens/auth_screens/login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  String countryCode = "1";
  String countryCodeSo = "IN";
  String fullNumber;
  bool isLoading = false;
  Country _selected;
  var focusNode = FocusNode();
  TextEditingController _referController = new TextEditingController();
  bool isRefered = false;

  toastIt() async {
    _selected = await getCountry();
    setState(() {});
    isRefered = (referalCode ?? "").length > 5;
    if (isRefered) {
      _referController.text = referalCode;

      Future.delayed(Duration(microseconds: 100)).then((value) => {
            if (isRefered & mounted)
              {showToast("You have been refered by id $referalCode", context)}
          });
    }
  }

  @override
  void initState() {
    setCurrentScreen(ScreenName.signUpScreen);
    toastIt();
    // focusNode.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double heigth = constraints.maxHeight;
            return ListView(
              padding: const EdgeInsets.only(top: 40.0, left: 24),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: NeedHelpButton(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Register For Free",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 24, top: heigth / 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          "Mobile",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: Color(0xffF0F0F0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CountryPicker(
                                        dense: false,
                                        showFlag: true,
                                        showDialingCode: true,
                                        showName: false,
                                        showCurrency: false,
                                        showCurrencyISO: false,
                                        onChanged: (Country country) async {
                                          setState(() {
                                            _selected = country;
                                          });
                                        },
                                        selectedCountry: _selected,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      focusNode: focusNode,
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        // suffixIcon: Icon(Icons.cancel),
                                        border: InputBorder.none,
                                        hintText: "Phone Number",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _phoneNumberController.clear();
                                        });
                                      },
                                      child: Icon(Icons.cancel),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      (referalCode ?? "").length > 5
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 25.0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  color: Color(0xffF0F0F0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextField(
                                            // focusNode: focusNode,
                                            controller: _referController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              // suffixIcon: Icon(Icons.cancel),
                                              border: InputBorder.none,
                                              hintText: "Referer Code",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: heigth / 10, left: width / 3),
                    child: ClippedButton(
                        width: width / 2,
                        title: 'SIGN UP',
                        onPressed: () => handleOtp(
                            "message",
                            context,
                            _phoneNumberController,
                            _referController,
                            _selected))),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text("Already a User."),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()));
                      },
                      child: Text(
                        "SIGN IN",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: blueClassicColor,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
