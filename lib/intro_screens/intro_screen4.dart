import 'package:flutter/material.dart';

class IntroScreen4 extends StatefulWidget {
  final double width;
  final double height;

  const IntroScreen4({Key key, this.width, this.height}) : super(key: key);

  @override
  _IntroScreen4State createState() => _IntroScreen4State();
}

class _IntroScreen4State extends State<IntroScreen4> {
  int whiteColor = 0xffffffff;
  int blueColor = 0xffDEFBFF;
  List<String> list = [
    "Meals Times",
    "Walk Times",
    "VET Appointments",
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Color(0xff000000), BlendMode.overlay),
      child: Container(
        // TODO REMOVE BOX DECORATION IF NO LONGER NEEDED
        decoration: BoxDecoration(
            // image: DecorationImage(
            // image: AssetImage("assets/images/dog2.png"),
            // fit: BoxFit.cover)),
            ),
        child: Scaffold(
          backgroundColor: Color(0xff190A0B),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    widget.width * 10, 70, widget.width * 10, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Manage your Pet easily with your family/friends",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          color: Colors.white),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: widget.height * 5, bottom: 15),
                      child: Text(
                        " We will Notifiy your group about",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(list.length, (index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          width: widget.width * 55,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                  width: 32,
                                  height: 16,
                                  image:
                                      AssetImage("assets/images/npfood.png")),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  list[index],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/images/dog3.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
