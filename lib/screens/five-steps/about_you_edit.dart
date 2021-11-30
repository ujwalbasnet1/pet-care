
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/common/custom_gender_selector.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/service/network.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';

class AboutYouEdit extends StatefulWidget {
  final bool canBack;
  final userInfo;

  const AboutYouEdit({Key key, this.canBack = true, this.userInfo})
      : super(key: key);
  @override
  _AboutYouEditState createState() => _AboutYouEditState();
}

class _AboutYouEditState extends State<AboutYouEdit> {
  GlobalKey<FormBuilderState> _formProfileEditKey =
      GlobalKey<FormBuilderState>();
  var loadingIndicator = new LoadingProgressDialog();
  var focusNode = FocusNode();

  @override
  void initState() {
    setCurrentScreen(ScreenName.editProfile);
    focusNode.requestFocus();
    super.initState();
  }

  double opacity = 0;
  var _picker = ImagePicker();
  File userImage;
  PickedFile image;
  double radius = 0;

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

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: FormBuilder(
                key: _formProfileEditKey,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75),
                            image: DecorationImage(
                              image: userImage == null
                                  ? NetworkImage(
                                      "${widget.userInfo['avatar'] ?? 'https://d2m3ee76kdhdjs.cloudfront.net/static_assets/dog.png'}")
                                  : FileImage(userImage),
                              fit: userImage == null
                                  ? BoxFit.contain
                                  : BoxFit.contain,
                            ),
                          ),
                          height: 130,
                          width: 130,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Upload Your Profile Picture",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      CommonTextField(
                        initialValue: widget.userInfo['fname'],
                        name: "fullname",
                        labelText: "Name",
                      ),
                      CommonTextField(
                        initialValue: widget.userInfo['email'],
                        name: "email",
                        labelText: "Email",
                      ),
                      FormBuilderField(
                        initialValue: widget.userInfo['gender'],
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
                                  initValue: ["MALE", "FEMALE", "OTHER"]
                                          .indexOf(widget.userInfo['gender']) +
                                      1,
                                  onChanged: (value) {
                                    field.didChange(value);
                                  },
                                  isSelected: true,
                                ),
                              ));
                        },
                      ),
                      RoundRectangleButton(
                        margin: EdgeInsets.only(top: 50),
                        onPressed: () async {
                          if (_formProfileEditKey.currentState
                              .saveAndValidate()) {
                            var d2Send = {};
                            var body = _formProfileEditKey.currentState.value;
                            body.keys.forEach((e) {
                              d2Send[e] = body[e];
                            });
                            d2Send['avatar'] = userImage;
                            loadingIndicator.show(context);
                            var res =
                                await RestRouteApi(context, ApiPaths.updateInfo)
                                    .aboutYou(d2Send);

                            if (res == null ||
                                res.status.toLowerCase() == "error" ||
                                res.status.toLowerCase() == "fail") {
                              // showToast(res.message, context);
                              loadingIndicator.hide(context);
                            } else {
                              await context
                                  .read<UserProvider>()
                                  .onCaretakerChange(context);
                              // showToast(res.message, context);
                              loadingIndicator.hide(context);
                              Navigator.pop(context);
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
              )),
            ),
          ],
        ),
      ),
    );
  }
}
