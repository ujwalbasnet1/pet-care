import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/bottom_nav.dart';
import 'package:pets/common/buttons/round_rectangle_button.dart';
import 'package:pets/screens/five-steps/about_pet.dart';
import 'package:pets/theming/common_size.dart';
import 'package:pets/utils/app_utils.dart';
import 'components/header.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/utils/static_variables.dart';

class WhoAreYou extends StatefulWidget {
  @override
  _WhoAreYouState createState() => _WhoAreYouState();
}

class _WhoAreYouState extends State<WhoAreYou> {
  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                Header(
                  title: "Who are You",
                  currentPetNumber: -1,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  width: double.infinity,
                  height: 150,
                  child: DottedBorder(
                    radius: Radius.circular(200),
                    color: Colors.grey,
                    strokeWidth: 2,
                    dashPattern: [
                      10,
                      6,
                    ],
                    child: Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/owner.jpg",
                          fit: BoxFit.fitHeight,
                        )),
                  ),
                ),
                RoundRectangleButton(
                  margin: EdgeInsets.zero,
                  title: "Pet Owner",
                  onPressed: isCareTaker
                      ? null
                      : () {
                          openScreen(context, AboutPet());
                        },
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  width: double.infinity,
                  height: 150,
                  child: DottedBorder(
                    radius: Radius.circular(30),
                    color: Colors.blue,
                    strokeWidth: 2,
                    dashPattern: [
                      10,
                      6,
                    ],
                    child: Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/caretaker.jpg",
                          fit: BoxFit.fitHeight,
                        )),
                  ),
                ),
                RoundRectangleButton(
                  margin: EdgeInsets.zero,
                  title: "Caretaker",
                  onPressed: isCareTaker
                      ? () {
                          openScreen(context, BottomNavigation());
                        }
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
