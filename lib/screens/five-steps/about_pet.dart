import 'dart:developer';
import 'dart:io' show File, Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/DataModel/breed_model.dart';
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/custom_gender_selector.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/contacts/add_contact.dart';
import 'package:pets/screens/five-steps/pet_type.dart';
import 'package:pets/screens/five-steps/welcome_dialog.dart';
import 'package:pets/screens/schedule/schedule_main.dart';
import 'package:pets/screens/schedule_create/schedule_create.dart';
import 'package:pets/service/network.dart';
import 'package:pets/utils/app_utils.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'components/header.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:provider/provider.dart';

class AboutPet extends StatefulWidget {
  final infoData;
  final bool isFromAddPets;
  const AboutPet({Key key, this.infoData, this.isFromAddPets = false})
      : super(key: key);
  @override
  _AboutPetState createState() => _AboutPetState();
}

class _AboutPetState extends State<AboutPet> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  var loadingIndicator = new LoadingProgressDialog();
  var selectedBreeds;
  var weightDropDown;
  bool isValidated = false;
  double sliderController = 10;
  String gender;
  var selectedDate;
  bool isAndroid = Platform.isAndroid;
  TextEditingController textEditingController = TextEditingController();
  var _picker = ImagePicker();
  File userImage;
  PickedFile image;
  double radius = 0;
  List breeds = dogBreeds;
  @override
  void initState() {
    init();
    setCurrentScreen(ScreenName.petDetailsForm);
    focusNode.requestFocus();
    super.initState();
  }

  init() {
    var value = widget.infoData['type'];
    breeds = (value == "Dog")
        ? dogBreeds
        : (value == "Cat")
            ? catBreeds
            : (value == "Bird")
                ? birdBreeds
                : [];
    setState(() {});
  }

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

  final focusNode = FocusNode();
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
                            selectedDate = tempPickedDate ?? DateTime.now();
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
                    maximumDate: DateTime.now(),
                    initialDateTime: selectedDate ??
                        DateTime.now().subtract(Duration(days: 1)),
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

  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    var horizontalPadding = EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 8,
    );
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Header(
              title: widget.infoData['petsCount'] == 1
                  ? "About Your Pet"
                  : "About Your ${widget.infoData['currentScreen']}${getSuffix(widget.infoData['currentScreen'])} Pet",
              currentPetNumber: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
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
                                      "assets/images/about_pet.png",
                                    )
                                  : FileImage(userImage),
                              fit: userImage == null
                                  ? BoxFit.contain
                                  : BoxFit.fill,
                              // fit: BoxFit.cover,
                            ),
                          ),
                          height: 130,
                          width: 130,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              focusNode.unfocus();
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
                            "Upload Your Pet's Picture",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: horizontalPadding,
                        child: CommonTextField(
                          textInputAction: TextInputAction.done,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          focusNode: focusNode,
                          name: "pet_name",
                          labelText: "What's your Pet name ?",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Text(
                          "What’s your Pet’s Breed?",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Color(0xff585858),
                                fontSize: 14,
                              ),
                        ),
                      ),
                      breeds.isEmpty
                          ? Padding(
                              padding: horizontalPadding,
                              child: CommonTextField(
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                                // initialValue: _selectedBreeds ?? "",
                                name: "breed",
                                labelText: "Enter Breed",
                              ),
                            )
                          : FormBuilderField(
                              // initialValue: _selectedBreeds,
                              name: "breed",
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
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
                                  child: Container(
                                    // child: SearchableDropdown.single(
                                    //   items: breeds
                                    //       .map((e) =>
                                    //           new DropdownMenuItem<String>(
                                    //             value: e,
                                    //             child: new Text(e),
                                    //           ))
                                    //       .toList(),

                                    //   // breedModel.map((BreedModel value) {
                                    //   //   return new DropdownMenuItem<String>(
                                    //   //     value: value.breedName.toString(),
                                    //   //     child: new Text(
                                    //   //       value.breedName.toString(),
                                    //   //     ),
                                    //   //   );
                                    //   // }).toList(),
                                    //   value: field.value,
                                    //   hint: "Select Breed",
                                    //   searchHint: null,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       // selectedReason = value;
                                    //       // _selectedBreeds = value;
                                    //       field.didChange(value);
                                    //     });
                                    //   },
                                    //   dialogBox: true,
                                    //   isExpanded: true,
                                    //   menuConstraints: null,
                                    // ),
                                  ),
                                );
                              },
                            ),

                      // breeds.isEmpty
                      //     ? Padding(
                      //         padding: horizontalPadding,
                      //         child: CommonTextField(
                      //           validator: FormBuilderValidators.compose([
                      //             FormBuilderValidators.required(context),
                      //           ]),

                      //           // initialValue: _selectedBreeds ?? "",
                      //           name: "breed",
                      //           labelText: "Enter Breed",
                      //         ),
                      //       )
                      //     : Container(
                      //         margin: EdgeInsets.symmetric(
                      //           horizontal: 15,
                      //         ),
                      //         decoration: BoxDecoration(
                      //           border: Border(
                      //             bottom: BorderSide(
                      //               // color: Color(0xff316EBA),
                      //               color: Colors.blue,
                      //               width: 1,
                      //             ),
                      //           ),
                      //         ),
                      //         child: SearchableDropdown.single(
                      //           items: breeds
                      //               .map((e) => new DropdownMenuItem<String>(
                      //                     value: e,
                      //                     child: new Text(e),
                      //                   ))
                      //               .toList(),
                      //           // value: selectedReason,
                      //           hint: "Select Breed",
                      //           searchHint: null,
                      //           onChanged: (value) {
                      //             focusNode.unfocus();
                      //             setState(() {
                      //               // selectedReason = value;
                      //               selectedBreeds = value;
                      //
                      //             });
                      //           },
                      //           underline: Container(),
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .bodyText1
                      //               .copyWith(fontSize: 16),
                      //           dialogBox: true,
                      //           isExpanded: true,
                      //           menuConstraints: null,
                      //         ),
                      //       ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        child: Text(
                          "Gender",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Color(0xff585858),
                                fontSize: 14,
                              ),
                        ),
                      ),
                      Padding(
                        padding: horizontalPadding,
                        child: CustomGenderSelector(
                          onChanged: (value) {
                            focusNode.unfocus();
                            gender = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Container(
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Weight",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Color(0xff585858),
                                      fontSize: 14,
                                    ),
                              ),
                              DropdownButton(
                                value: weightDropDown,
                                onChanged: (value) {
                                  setState(() {
                                    weightDropDown = value;
                                  });
                                },
                                hint: Text("Pound"),
                                items: <String>[
                                  'KG',
                                  'Pounds',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SfSlider(
                        min: 0.0,
                        max: 50.0,
                        showLabels: true,
                        showDividers: true,
                        enableTooltip: true,
                        tooltipShape: SfPaddleTooltipShape(),
                        interval: 5.0,
                        stepSize: 1.0,
                        value: sliderController,
                        onChanged: (value) {
                          setState(() {
                            sliderController = value;
                          });
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 15),
                            child: Text(
                              "Select Birth Date",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Color(0xff585858),
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              // vertical: 5,
                              horizontal: 15,
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                focusNode.unfocus();
                                _selectDate();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: blueClassicColor,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  selectedDate != null
                                      ? "${selectedDate.toString().substring(0, 10)}"
                                      : "Birth Date",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Color(0xff585858),
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      RoundRectangleButton(
                        onPressed: () async {
                          // _formKey.currentState.save();
                          focusNode.unfocus();
                          if (_formKey.currentState.saveAndValidate()) {
                            isValidated = true;
                            var value = _formKey.currentState.value;

                            Map<String, dynamic> petsInfo = {};

                            if (image == null) {
                              // showToast("Select Image", context);

                            } else {
                              petsInfo['image'] = userImage;
                            }
                            petsInfo['type'] = widget.infoData['type'];
                            petsInfo['name'] = value['pet_name'];
                            petsInfo['breed'] = value['breed'];
                            petsInfo['gender'] = gender ?? "MALE";
                            petsInfo['weight'] = sliderController.toString() +
                                " ${weightDropDown ?? "Pound"}";

                            if (selectedDate == null) {
                              // showToast("Please select birth date", context);

                            } else {
                              petsInfo['birthdata'] =
                                  selectedDate.toString().substring(0, 10);
                            }
                            if (isValidated) {
                              loadingIndicator.show(context);
                              var res =
                                  await RestRouteApi(context, ApiPaths.addPet)
                                      .addPet(petsInfo);
                              loadingIndicator.hide(context);
                              if (res == null) {
                                return;
                              }
                              if (res.status == "error" ||
                                  res.status.toString().toLowerCase() ==
                                      "fail") {
                                loadingIndicator.hide(context);
                                showToast(res.message, context);
                              } else {
                                showToast(res.message, context);
                                var data = res.data;
                                context
                                    .read<UserProvider>()
                                    .recentlyAddedPet(data);

                                Future.delayed(Duration(microseconds: 100))
                                    .then((value) async {
                                  var screen = await welcomeDialog(context, "",
                                      image: data['image'], name: data['name']);

                                  if (screen != null) {
                                    loadingIndicator.show(context);
                                    if (widget.infoData['currentScreen'] >=
                                        widget.infoData['petsCount']) {
                                      await context
                                          .read<UserProvider>()
                                          .onPetChange(context);
                                      loadingIndicator.hide(context);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ScheduleCreate(
                                                      isOnBoarding:
                                                          !widget.isFromAddPets,
                                                      isFromAddPets: widget
                                                          .isFromAddPets)),
                                          (Route<dynamic> route) => false);
                                    } else {
                                      loadingIndicator.hide(context);
                                      widget.infoData['currentScreen']++;
                                      openScreen(context,
                                          PetType(infoData: widget.infoData));
                                    }
                                  }
                                });
                              }
                              // openScreen(context, PetType(petsInfo: petsInfo));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
