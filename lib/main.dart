import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'GoKnights',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: Color(0xFFE71939),
        primaryContrastingColor: CupertinoColors.white,
        textTheme: CupertinoTextThemeData(
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
