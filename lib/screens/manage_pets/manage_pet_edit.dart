import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pets/DataModel/breed_model.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/colors.dart';
import 'package:pets/common/custom_gender_selector.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import 'package:pets/provider/user_provider.dart';
import 'package:pets/screens/five-steps/components/custom_breed.dart';
import 'package:pets/screens/schedule_create/components/timer_picker/custom_time_picker.dart';
import 'package:pets/service/network.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/widgets/loading_indicator.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ManagePetEdit extends StatefulWidget {
  final data;

  const ManagePetEdit({Key key, this.data}) : super(key: key);
  @override
  _ManagePetEditState createState() => _ManagePetEditState();
}

class _ManagePetEditState extends State<ManagePetEdit> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  var _selectedBreeds = "";
  var customType = "Dog";
  int currentSelectedIndex;
  var petsType = ["Dog", "Cat", "Bird", "Others"];
  List breeds = dogBreeds;
  double sliderController = 0;
  var selectedDate;
  @override
  void initState() {
    setCurrentScreen(ScreenName.managePetEdit);
    update();
    super.initState();
  }

  double radius = 0;
  var _picker = ImagePicker();
  var userImage;
  PickedFile image;
  int weight = 10;
  String weightDropDown = "KG";
  String gender = "MALE";
  var weightInfo = "";

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

  _selectDate() async {
    print("===========");
    print(selectedDate);
    DateTime tempPickedDate =
        null; //selectedDate == null ? null : selectedDate;
    return await showModalBottomSheet<DateTime>(
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
                          Navigator.of(context).pop(selectedDate);
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
                    initialDateTime: DateTime.now().subtract(Duration(days: 1)),
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

  update() {
    var value = widget.data['type'];
    if (!petsType.contains(widget.data['type'])) {
      petsType.remove('Others');
      petsType.add(widget.data['type']);
      petsType.add('Others');
    }
    // if (!petsType.contains(widget.data['breed'])) {
    //   petsType.remove('Others');
    //   petsType.add(widget.data['type']);
    //   petsType.add('Others');
    // }
    _selectedBreeds = widget.data['breed'];
    breeds = (value == "Dog")
        ? dogBreeds
        : (value == "Cat")
            ? catBreeds
            : (value == "Bird")
                ? birdBreeds
                : [];
    customType = widget.data['type'];
    userImage = widget.data['image'];
    gender = widget.data['gender'] ?? "MALE";

    weightInfo = widget.data['weight'];
    if (widget.data['birthdata'] != null) {
      //DateTime.parse(widget.data['birthdata']);
      selectedDate = widget.data['birthdata'];
    }
    if (weightInfo.toString().length > 3) {
      sliderController = double.parse(weightInfo.toString().split(" ")[0]);
      weightDropDown = weightInfo.toString().split(" ")[1];
    }
    setState(() {});
  }

  var loadingIndicator = new LoadingProgressDialog();
  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Edit Pet's Info"),
        ),
        body: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(radius),
                          image: DecorationImage(
                            image: userImage == null
                                ? AssetImage(
                                    "assets/images/about_you.png",
                                  )
                                : userImage.toString().startsWith('http')
                                    ? NetworkImage(userImage)
                                    : FileImage(userImage),
                            fit: userImage == null ? BoxFit.cover : BoxFit.fill,
                          ),
                        ),
                        height: 150,
                        width: 150,
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text("Add your Pet's Picture"),
                      ),
                    ),
                    CommonTextField(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      initialValue: widget.data['name'],
                      name: "name",
                      labelText: "What's your Pet name ?",
                    ),
                    FormBuilderField(
                      initialValue: customType,
                      name: "type",
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Pet's Type",
                            labelStyle:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 20,
                                    ),
                            contentPadding:
                                EdgeInsets.only(top: 10.0, bottom: 0.0),
                            border: InputBorder.none,
                            errorText: field.errorText,
                          ),
                          child: CustomPicker(
                              selectedPointer: petsType.indexOf(field.value),
                              padding: EdgeInsets.zero,
                              list: petsType,
                              onPressed: (value, index) async {
                                if (value == "Others") {
                                  var data = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: CustomBreed(
                                              myContext: context,
                                              type: "Pet's"),
                                        );
                                      });
                                  if (data != null) {
                                    petsType.remove('Others');
                                    petsType.add(data['breed_name']);
                                    petsType.add('Others');
                                  }
                                  field.didChange(data['breed_name']);
                                } else {
                                  field.didChange(value.toString());
                                }
                                // "Dog", "Cat", "Bird"
                                breeds = (value == "Dog")
                                    ? dogBreeds
                                    : (value == "Cat")
                                        ? catBreeds
                                        : (value == "Bird")
                                            ? birdBreeds
                                            : [];
                                _selectedBreeds =
                                    breeds.length > 0 ? breeds[0] : "";
                                setState(() {});
                              }),
                        );
                      },
                    ),
                    breeds.isEmpty
                        ? CommonTextField(
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            initialValue: _selectedBreeds ?? "",
                            name: "breed",
                            labelText: "Enter Breed",
                          )
                        : FormBuilderField(
                            initialValue: _selectedBreeds,
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
                                  //       .map(
                                  //           (e) => new DropdownMenuItem<String>(
                                  //                 value: e,
                                  //                 child: new Text(e),
                                  //               ))
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
                                  //       _selectedBreeds = value;
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
                    Wrap(
                      children: [
                        // Text("Unable to find your breed?"),
                        // InkWell(
                        //   onTap: () async {
                        //     var data = await showDialog(
                        //         context: context,
                        //         builder: (BuildContext context) {
                        //           return Dialog(
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(20)),
                        //             child: CustomBreed(
                        //               myContext: context,
                        //             ),
                        //           );
                        //         });
                        //     if (data != null) {
                        //       breedModel.add(
                        //           BreedModel(breedName: data['breed_name']));
                        //       setState(() {
                        //         _selectedBreeds = data['breed_name'];
                        //       });
                        //     }
                        //   },
                        //   child: Text(
                        //     " Add Custom Breed here",
                        //     style: TextStyle(color: Colors.blue),
                        //   ),
                        // ),
                        FormBuilderField(
                          initialValue: gender,
                          name: "gender",
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 0),
                                  child: CustomGenderSelector(
                                    initValue: ["MALE", "FEMALE", "OTHER"]
                                            .indexOf(gender) +
                                        1,
                                    onChanged: (value) {
                                      field.didChange(value);
                                    },
                                    isSelected: true,
                                  ),
                                ));
                          },
                        ),

                        FormBuilderField(
                          initialValue: selectedDate,
                          name: "birthdata",
                          builder: (FormFieldState<dynamic> field) {
                            return InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Select Birth Date",
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
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () async {
                                    var sDate = await _selectDate();
                                    if (sDate != null) {
                                      field.didChange(
                                          sDate.toString().split(" ")[0]);
                                    }
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
                                      field.value != "null"
                                          ? "${field.value.toString()}"
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
                                ));
                          },
                        ),

                        FormBuilderField(
                          initialValue: weightInfo,
                          name: "weight",
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                field.didChange(
                                                    '${sliderController.toString()} $value');
                                                setState(() {
                                                  weightDropDown = value;
                                                });
                                              },
                                              hint: Text("Weight in"),
                                              items: <String>[
                                                'KG',
                                                'Pound',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        color: Colors.black),
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
                                      interval: 10.0,
                                      stepSize: 1.0,
                                      value: sliderController,
                                      onChanged: (value) {
                                        field.didChange(
                                            '${value.toString()} $weightDropDown');
                                        setState(() {
                                          sliderController = value;
                                        });
                                      },
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ],
                    ),
                    RoundRectangleButton(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      title: "Update",
                      onPressed: () async {
                        if (_formKey.currentState.saveAndValidate()) {
                          var body = _formKey.currentState.value;
                          var d2Send = {};
                          body.keys.forEach((e) {
                            d2Send[e] = body[e];
                          });

                          if (!userImage.toString().startsWith("http")) {
                            d2Send['image'] = userImage;
                          }

                          loadingIndicator.show(context);
                          var res = await RestRouteApi(
                                  context,
                                  ApiPaths.updatePet +
                                      "?id=" +
                                      widget.data["_id"])
                              .addPet(d2Send);

                          if (res == null) {
                            loadingIndicator.hide(context);
                            return;
                          }
                          if (res.status == "error" || res.status == "fail") {
                            loadingIndicator.hide(context);
                            showToast(res.message, context);
                          } else {
                            showToast(res.message, context);
                            // ignore: unused_local_variable
                            var data = res.data;
                            await context
                                .read<UserProvider>()
                                .onPetChange(context);
                            loadingIndicator.hide(context);
                            Future.delayed(Duration(microseconds: 200))
                                .then((value) async {
                              Navigator.pop(context);
                            });
                          }
                        }
                        // welcomeDialog(context, "");
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
