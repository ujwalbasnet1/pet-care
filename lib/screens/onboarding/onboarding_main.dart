import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pets/common/indicatorSlide.dart';
import 'package:pets/common/need_help_button.dart';
import 'package:pets/intro_screens/intro_screen1.dart';
import 'package:pets/intro_screens/text_top_intro_screen.dart';
import 'package:pets/intro_screens/intro_screen4.dart';
import 'package:pets/intro_screens/intro_screen5.dart';
import 'package:pets/utils/app_utils.dart';
import 'package:pets/screens/onboarding/components/sign_in_sign_up_buttons.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:pets/utils/static_variables.dart';
import 'package:pets/screens/auth_screens/sign_up/sign_up_screen.dart';

class OnBoardingMain extends StatefulWidget {
  @override
  _OnBoardingMainState createState() => _OnBoardingMainState();
}

class _OnBoardingMainState extends State<OnBoardingMain> {
  static void initDynamicLinks(context) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deepLink = data?.link;

    if (deepLink != null) {
      referalCode = deepLink.path.replaceAll("/", "") ?? "";
      if (referalCode.length > 5) {
        Future.delayed(Duration(microseconds: 200)).then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ));
        });
      }
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        referalCode = deepLink.path.replaceAll("/", "") ?? "";
        if (referalCode.length > 5) {
          Future.delayed(Duration(microseconds: 200)).then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(),
                ));
          });
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  @override
  void initState() {
    setCurrentScreen(ScreenName.onboardingMain);

    initDynamicLinks(context);
    super.initState();
  }

  int totalSlides = 4;
  CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = getWidth(constraints, context);
          final double height = getHeight(constraints, context);
          // var align = Align(
          //     alignment: Alignment.bottomRight,
          //     child: LoginRegisterButton(width: width, height: height));
          return Stack(
            children: [
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                    autoPlayInterval: Duration(seconds: 4),
                    height: height * 100,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    onPageChanged: (value, reason) {
                      setState(() {
                        current = value;
                      });
                    }
                    // onPageChanged: (_,__){_carouselController.s}
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
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SignInSignUpButtons(),
                      SizedBox(
                        height: 50,
                      ),
                      IndicatorSlider(total: totalSlides, current: current),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: SafeArea(
                  child: NeedHelpButton(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
