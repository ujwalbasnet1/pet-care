import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/custom_gender_selector.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/utils/static_variables.dart';
import 'about_pet.dart';
import 'components/header.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/theming/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/service/network.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/custom_selector.dart';

import 'pet_type.dart';

class AboutYou extends StatefulWidget {
  final bool canBack;
  const AboutYou({Key key, this.canBack = false}) : super(key: key);
  @override
  _AboutYouState createState() => _AboutYouState();
}

class _AboutYouState extends State<AboutYou> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  var loadingIndicator = new LoadingProgressDialog();
  double opacity = 0;
  double radius = 0;
  var _picker = ImagePicker();
  File userImage;
  PickedFile image;
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  getUserImageFromGallery() async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus == PermissionStatus.granted) {
      try {
        image = await _picker.getImage(source: ImageSource.gallery);

        var file = File(image.path);
        setState(() {
          userImage = file;
        });
        return file;
      } catch (e) {
        print(e.toString());
      }
    } else {
      return null;
    }
  }

  getUserImageFromCamera() async {
    await Permission.camera.request();
    var permissionStatus = await Permission.camera.status;
    if (permissionStatus == PermissionStatus.granted) {
      try {
        image = await _picker.getImage(source: ImageSource.camera);

        var file = File(image.path);
        setState(() {
          userImage = file;
        });

        return file;
      } catch (e) {
        print(e.toString());
      }
    } else {
      return null;
    }
  }

  void unfocus() {
    nameFocus.unfocus();
    emailFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Header(
                  title: "About You",
                  canBack: widget.canBack,
                  // currentStep: -1,
                ),
              ),
              FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            image: DecorationImage(
                              image: userImage == null
                                  ? AssetImage(
                                      "assets/images/about_you.png",
                                    )
                                  : FileImage(userImage),
                              fit: userImage == null
                                  ? BoxFit.contain
                                  : BoxFit.cover,
                            ),
                          ),
                          height: 130,
                          width: 130,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              unfocus();
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Select image from",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text("Camera"),
                                                onTap: () async {
                                                  await getUserImageFromCamera();
                                                  if (userImage != null) {
                                                    setState(() {
                                                      radius = 75;
                                                    });
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.photo),
                                                title: Text("Gallery"),
                                                onTap: () async {
                                                  await getUserImageFromGallery();
                                                  if (userImage != null) {
                                                    setState(() {
                                                      radius = 75;
                                                    });
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Text(
                            "Upload Your Profile Picture",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                      CommonTextField(
                        name: "fullname",
                        labelText: "Full Name",
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(context),
                          ],
                        ),
                        focusNode: nameFocus,
                      ),
                      CommonTextField(
                        name: "email",
                        labelText: "Email",
                        // validator: FormBuilderValidators.compose([
                        //   FormBuilderValidators.email(context),
                        // ]),
                        focusNode: emailFocus,
                        textInputAction: TextInputAction.done,
                      ),
                      FormBuilderField(
                        initialValue: "MALE",
                        name: "gender",
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                              decoration: InputDecoration(
                                labelText: "Gender",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                                contentPadding:
                                    EdgeInsets.only(top: 10.0, bottom: 0.0),
                                border: InputBorder.none,
                                errorText: field.errorText,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 0),
                                child: CustomGenderSelector(
                                  onChanged: (value) {
                                    unfocus();
                                    field.didChange(value);
                                  },
                                  isSelected: true,
                                ),
                              ));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isCareTaker
                          ? Container()
                          : FormBuilderField(
                              initialValue: "1",
                              name: "no_of_pets",
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "How many pets do you have",
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize: 20,
                                          ),
                                      contentPadding: EdgeInsets.only(
                                          top: 10.0, bottom: 0.0),
                                      border: InputBorder.none,
                                      errorText: field.errorText,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 0),
                                      child: CustomSelector(
                                        onChanged: (value) {
                                          unfocus();
                                          field.didChange(value.toString());
                                        },
                                      ),
                                    ));
                              },
                            ),
                      RoundRectangleButton(
                        margin: EdgeInsets.only(
                          top: 40,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.saveAndValidate()) {
                            loadingIndicator.show(context);
                            var body = _formKey.currentState.value;
                            var d2Send = {};
                            body.keys.forEach((e) {
                              d2Send[e] = body[e];
                            });
                            d2Send['avatar'] = userImage;
                            var res =
                                await RestRouteApi(context, ApiPaths.updateInfo)
                                    .aboutYou(d2Send);
                            loadingIndicator.hide(context);
                            if (res.status.toLowerCase() == "error" ||
                                res.status.toLowerCase() == "fail") {
                              showToast(res.message, context);
                            } else {
                              showToast(res.message, context);
                              Future.delayed(Duration(microseconds: 100))
                                  .then((value) {
                                // Navigator.pushReplacement(context,
                                //     MaterialPageRoute(builder: (BuildContext context) {
                                //   return /*otpData['userData']['isLogin']
                                //                     ? BottomNavigation()
                                //                     :/
                                // openScreen(context, WhoAreYou());
                                var infoData = {};
                                if (!isCareTaker) {
                                  infoData['petsCount'] =
                                      int.parse(body['no_of_pets']);
                                  infoData['currentScreen'] = 1;
                                }
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return isCareTaker
                                      ? BottomNavigation()
                                      : PetType(infoData: infoData);
                                }));

                                // }));
                              });
                            }
                          } else {
                            showToast("All Fields are mandatory.", context);
                          }
                          // openScreen(context, WhoAreYou());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: RoundRectangleButton(
        //   onPressed: () async {
        //     if (_formKey.currentState.saveAndValidate()) {
        //       loadingIndicator.show(context);
        //       var body = _formKey.currentState.value;

        //       var res = await RestRouteApi(context, ApiPaths.updateInfo)
        //           .aboutYou(body);
        //       loadingIndicator.hide(context);

        //       if (res.status.toLowerCase() == "error" ||
        //           res.status.toLowerCase() == "fail") {
        //         showToast(res.message, context);
        //       } else {
        //         showToast(res.message, context);
        //         Future.delayed(Duration(microseconds: 100)).then((value) {
        //           // Navigator.pushReplacement(context,
        //           //     MaterialPageRoute(builder: (BuildContext context) {
        //           //   return /*otpData['userData']['isLogin']
        //           //                     ? BottomNavigation()
        //           //                     :/
        //           openScreen(context, WhoAreYou());
        //           // }));
        //         });
        //       }
        //     } else {
        //       showToast("All Fields are mandatory.", context);
        //     }

        //     // openScreen(context, WhoAreYou());
        //   },
        // ),
      ),
    );
  }
}
