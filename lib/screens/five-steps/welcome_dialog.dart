// import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:pets/screens/five-steps/about_pet.dart';
import 'package:pets/common/bottom_nav.dart';
import 'dart:ui';

welcomeDialog(BuildContext context, String petName, {image, name = ""}) {
  // AudioCache player = new AudioCache();
  // const alarmAudioPath = "sounds/woof_woof.mp3";
  // player.play(alarmAudioPath);
  bool isClosed = false;
  Future.delayed(Duration(seconds: 3)).then((value) async {
    if (!isClosed) Navigator.pop(context, "continue");
  });
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //this right here
            child: Container(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset("assets/images/bo.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 48.0, top: 48),
                          child: CircleAvatar(
                              radius: 40.0,
                              backgroundImage: image == null
                                  ? AssetImage("assets/images/bdog.png")
                                  : NetworkImage(image)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Woof Woof !",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontSize: 29,
                            letterSpacing: 1.5,
                            wordSpacing: 2,
                            color: Colors.purple[900]),
                      ),
                    ),
                    Text(
                      "${name ?? petName} is now onboard",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Color(0xff080040)),
                    ),
                    Spacer(),
                    // Container(
                    //   child: FlatButton(
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Icon(Icons.add_circle_outline_outlined),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Text("Another Pet")
                    //       ],
                    //     ),
                    //     onPressed: () {
                    //       Navigator.pop(context, AboutPet());
                    //     },
                    //   ),
                    // ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: FlatButton(
                            child: Text(
                              "CONTINUE",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {
                              isClosed = true;
                              Navigator.pop(context, "continue");
                              // Navigator.pop(
                              //     context,
                              //     BottomNavigation(
                              //         currentScreen: 2, isOpenTask: true));
                            }),
                      ),
                    ),
                    /* Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.blueAccent,
                        ),
                        Padding(f
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Another pet",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ) */
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
