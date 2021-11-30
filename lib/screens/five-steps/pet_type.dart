import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pets/DataModel/pet_type_model.dart';
import 'package:pets/screens/five-steps/select_breed.dart';
import 'package:pets/sign_up/pet_type.dart';
import 'package:pets/utils/app_utils.dart';
import 'about_pet.dart';
import 'components/custom_breed.dart';
import 'components/header.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/common/gradient_bg.dart';

class PetType extends StatefulWidget {
  final infoData;
  final bool isFromAddPets;
  const PetType({Key key, this.infoData, this.isFromAddPets = false})
      : super(key: key);
  @override
  _PetTypeState createState() => _PetTypeState();
}

class _PetTypeState extends State<PetType> {
  int currentSelectedIndex;
  String customType = '';
  DateTime _lastQuitTime;
  var loadingIndicator = new LoadingProgressDialog();
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    setCurrentScreen(ScreenName.selectPetType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: WillPopScope(
        onWillPop: () async {
          if (_lastQuitTime == null ||
              DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
            showToast('Press again Back Button to Exit', context);
            _lastQuitTime = DateTime.now();
            return false;
          }
          exit(0);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Header(
                canBack: widget.isFromAddPets,
                currentPetNumber: 3,
                // title: "About Your Pet",
                title: widget.infoData['petsCount'] == 1
                    ? "About Your Pet"
                    : "About Your ${widget.infoData['currentScreen']}${getSuffix(widget.infoData['currentScreen'])} Pet",
              ),
              Expanded(
                child: FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: FormBuilderField(
                      initialValue: "Dogs",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                      name: "type",
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                            decoration: InputDecoration(
                              labelText: "What is your Pet Type?",
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
                            child: GridView.count(
                              // physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 4 / 5,
                              children:
                                  List.generate(petYpeList.length, (index) {
                                return PetTypeTile(
                                  // backGroundColor:
                                  // petYpeList[index].backgroundColor,
                                  name: petYpeList[index].name,
                                  petImage: petYpeList[index].petImage,
                                  isSelected:
                                      petYpeList[index].name == field.value,
                                  onPressed: () async {
                                    field.didChange(petYpeList[index].name);
                                    customType = petYpeList[index].name;

                                    if (index == 3) {
                                      {
                                        var data = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: CustomBreed(
                                                    myContext: context,
                                                    type: "Type"),
                                              );
                                            });
                                        if (data != null) {
                                          customType = data['breed_name'];
                                        }
                                      }
                                    }

                                    var infoData = widget.infoData;
                                    infoData['type'] = customType;
                                    openScreen(
                                        context,
                                        AboutPet(
                                            infoData: infoData,
                                            isFromAddPets:
                                                widget.isFromAddPets));
                                    // setState(() {
                                    //   currentSelectedIndex = index;
                                    //   categoryName = petYpeList[index].name;

                                    // });
                                  },
                                );
                              }),
                            ));
                      },
                    ),
                  ),
                ),
              ),
              // Text(customType),
              // RoundRectangleButton(
              //   title: "Next",
              //   onPressed: () async {
              //     if (_formKey.currentState.saveAndValidate()) {
              //       var type = _formKey.currentState.value;

              //       //  var infoData = {
              //       //       'petsCount': int.parse(body['no_of_pets']),
              //       //       'currentScreen': 1
              //       //     };

              //       var infoData = widget.infoData;
              //       infoData['type'] = type;

              //       // widget.petsInfo['type'] =
              //       //     type['type'].toString().toLowerCase() == "others"
              //       //         ? customType
              //       //         : type['type'];
              //       // openScreen(context, SelectBreed(petsInfo: widget.petsInfo));
              //       openScreen(context, AboutPet(infoData: infoData));
              //     }
              //     // widget.formKey.currentState.;
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
