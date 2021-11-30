import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'components/header.dart';
import 'package:pets/theming/theme.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/common/text_fields/common_textfield.dart';
import './welcome_dialog.dart';
import 'package:pets/service/network.dart';
import 'package:pets/widgets/loading_indicator.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:provider/provider.dart';
import 'package:pets/provider/user_provider.dart';

class PetDetails extends StatefulWidget {
  final petsInfo;

  const PetDetails({Key key, this.petsInfo}) : super(key: key);
  @override
  _AboutPetState createState() => _AboutPetState();
}

class _AboutPetState extends State<PetDetails> {
  String weightDropDown = "KG";
  int weight = 20;
  int currentSelectedIndex;
  var loadingIndicator = new LoadingProgressDialog();
  GlobalKey<FormBuilderState> _formKeyDetails = GlobalKey<FormBuilderState>();

  double sliderController = 2;
  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Header(
              currentPetNumber: 5,
              title: "${widget.petsInfo['name']}'s Details",
            ),
            Expanded(
              child: FormBuilder(
                key: _formKeyDetails,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      FormBuilderDropdown(
                        initialValue: "MALE",
                        decoration: CommonTextField.decoration.copyWith(
                          labelText: "Gender",
                        ),
                        items: ["MALE", "FEMALE"]
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        name: "gender",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: FormBuilderDateTimePicker(
                          name: 'date',
                          // onChanged: _onChanged,
                          inputType: InputType.date,
                          decoration: CommonTextField.decoration.copyWith(
                            labelText: "Birth Date",
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Weight",
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SfSlider(
                                  min: 0.0,
                                  max: 30.0,
                                  showDividers: true,
                                  enableTooltip: true,
                                  tooltipShape: SfPaddleTooltipShape(),
                                  interval: 10.0,
                                  stepSize: 1.0,
                                  value: sliderController,
                                  onChanged: (value) {
                                    setState(() {
                                      sliderController = value;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [],
                                ),
                              ),
                              DropdownButton(
                                value: weightDropDown,
                                onChanged: (value) {
                                  setState(() {
                                    weightDropDown = value;
                                  });
                                },
                                hint: Text("Weight in"),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RoundRectangleButton(
              title: "Let's Onboard",
              onPressed: () async {
                if (_formKeyDetails.currentState.saveAndValidate()) {
                  var cData = _formKeyDetails.currentState.value;
                  var postAbleData = widget.petsInfo;
                  postAbleData['weight'] = weight.toString();
                  postAbleData['birthdata'] = cData['date'].toString();
                  postAbleData['gender'] = cData['gender'].toString();
                  print(postAbleData);
                  loadingIndicator.show(context);
                  var res = await RestRouteApi(context, ApiPaths.addPet)
                      .addPet(postAbleData);
                  loadingIndicator.hide(context);
                  if (res == null) {
                    return;
                  }
                  if (res.status == "error" || res.status == "fail") {
                    showToast(res.message, context);
                  } else {
                    showToast(res.message, context);
                    var data = res.data;

                    Future.delayed(Duration(microseconds: 100))
                        .then((value) async {
                      var screen = await welcomeDialog(context, "",
                          image: data['image'], name: data['name']);
                      if (screen != null) {
                        await context.read<UserProvider>().onPetChange(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => screen,
                            ),
                            (Route<dynamic> route) => false);
                      }
                    });
                  }
                }
                // welcomeDialog(context, "");
              },
            ),
          ],
        ),
      ),
    );
  }
}
