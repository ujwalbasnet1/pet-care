import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/need_help_button.dart';
import 'package:pets/screens/auth_screens/commons/handle_otp.dart';
import 'package:pets/screens/auth_screens/commons/minor_login.dart';

import '../../../widgets/clipped_button.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/screens/auth_screens/sign_up/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  String countryCode = "1";
  String countryCodeSo = "US";
  String fullNumber;
  bool isLoading = false;
  var focusNode = FocusNode();
  Country _selected;

  @override
  void initState() {
    // focusNode.requestFocus();
    init();
    setCurrentScreen(ScreenName.loginScreen);
    super.initState();
  }

  init() async {
    _selected = await getCountry();
    setState(() {});
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
              padding: const EdgeInsets.only(top: 40, left: 24),
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        "Sign In",
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
                      "Login For Free",
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
                        padding:
                            EdgeInsets.only(top: 10.0, bottom: heigth / 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: Color(0xffF0F0F0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Container(
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
                      Center(
                        child: Text(
                          "Or",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: InkWell(
                            onTap: () {
                              minorLogin(context);
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.qr_code),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Scan QR Code",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // isLoading == true ? CircularProgressIndicator() : Container(),
                Container(
                    margin: EdgeInsets.only(top: heigth / 10, left: width / 3),
                    child: ClippedButton(
                        width: width / 2,
                        title: 'SIGN IN',
                        onPressed: () => handleOtp("message", context,
                            _phoneNumberController, null, _selected))),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    Text("Not a User"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignUpScreen()));
                      },
                      child: Text(
                        "FREE SIGN UP",
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
              ],
            );
          },
        ),
      ),
    );
  }
}
