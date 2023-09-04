import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'onboarding.dart';

int counter = 0;
String role = 'current';
final _mainNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables(); // load .env file
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar for Android
  ));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  counter = (prefs.getInt('counter') ?? 0);
  role = (prefs.getString('role') ?? 'current');
  // if debug mode (kDebugMode == true), always show onboarding
  if (false) {
    counter = 0;
  } else {
    await prefs.setInt("counter", counter + 1);
  }
  // print('counter ${counter}');
  // print('role ${role}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return CupertinoApp(
      navigatorKey: _mainNavigatorKey,
      title: 'GoKnights',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: Color(0xFFE71939),
        primaryContrastingColor: CupertinoColors.white,
        textTheme: CupertinoTextThemeData(
          primaryColor: Color(0xFFE71939),
          textStyle: TextStyle(
            color: CupertinoColors.black,
          ),
          actionTextStyle: TextStyle(
            color: Color(0xFFE71939),
          ),
          tabLabelTextStyle: TextStyle(
            color: Color(0xFFE71939),
          ),
        ),
      ),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: counter == 0
          ? const OnboardingPage(title: 'Welcome to GoKnights')
          : const CupertinoTabBarDemo(),
    );
  }
}
