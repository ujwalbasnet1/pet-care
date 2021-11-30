import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:pets/intro_screens/intro_screen1.dart';
import 'package:pets/intro_screens/text_top_intro_screen.dart';
import 'package:pets/intro_screens/intro_screen4.dart';
import 'package:pets/intro_screens/intro_screen5.dart';
import 'package:pets/utils/app_utils.dart';
import 'login_register_button.dart';

class PageViewerScreen extends StatefulWidget {
  @override
  _PageViewerScreenState createState() => _PageViewerScreenState();
}

class _PageViewerScreenState extends State<PageViewerScreen> {
  final controller = PageController(initialPage: 0);
  int current = 0;
  int totalSlides = 4;
  bool forward = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CarouselController _controller = CarouselController();
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = getWidth(constraints, context);
          final double height = getHeight(constraints, context);
          return Stack(
            children: [
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlayInterval: Duration(seconds: 8),
                  height: height * 100,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: true,
                ),
                items: [
                  IntroScreen1(width: width, height: height),
                  TextTopIntroScreen(
                    width: width,
                    height: height,
                    title: "Automate Pet's Chores",
                    paragraph:
                        "Let us manage your Pet’s chores and make it fun. Score points among your loved ones and leave the headache to us",
                    imageUrl: "assets/images/dogp.png",
                  ),
                  IntroScreen4(width: width, height: height),
                  TextTopIntroScreen(
                    width: width,
                    height: height,
                    title: "Who Does More Work ?",
                    paragraph:
                        "Some Points for every chore you for your Pet Look at Dashboard on weekly, monthly points with your group",
                    imageUrl: "assets/images/last.png",
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
