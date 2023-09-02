import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables(); // load .env file
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar for Android
  ));
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
    return const CupertinoApp(
      title: 'GoKnights',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
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
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: CupertinoTabBarDemo(),
    );
  }
}
