import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pets/provider/user_profile_provider.dart';
import 'package:provider/provider.dart';

import 'common/bottom_nav.dart';
import 'provider/main_provider.dart';
import 'provider/timer_provider.dart';
import 'provider/user_provider.dart';
// pets imports
import 'screens/onboarding/onboarding_main.dart';
import 'screens/story/story_creator/camera_view/camera_provider.dart';
import 'screens/story/story_viewer/provider/story_main_provider.dart';
import 'service/userid_store.dart';
import 'utils/app_utils.dart';
import 'utils/static_variables.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryMainProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: FeatureDiscovery(
        child: MyApp(),
      ),
    ),
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      debugShowCheckedModeBanner: false,
      title: 'My Pet\'s life',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Firebase.initializeApp();
    setCurrentScreen(ScreenName.main);
    checkUserLogin();
    super.initState();
  }

  checkUserLogin() async {
    token = await SharedPref().getStringValue("token");

    var screen;
    if (token != null) {
      if (token.length > 10) {
        screen = BottomNavigation();
      }
    } else {
      screen = OnBoardingMain();
    }
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(Duration(microseconds: 100));
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(),
      ),
    );
  }
}
