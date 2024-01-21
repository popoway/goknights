import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_review/in_app_review.dart';

import 'home.dart';
import 'onboarding.dart';

int counter = 0;
String role = 'current';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void _showReviewDialog() async {
  final InAppReview inAppReview = InAppReview.instance;

  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
  }
}

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
  // if (false) {
  //   counter = 0;
  // } else {
  //   await prefs.setInt("counter", counter + 1);
  // }
  // print('counter ${counter}');
  // print('role ${role}');
  await prefs.setInt("counter", counter + 1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Brightness _brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
    // print(_packageInfo);
    // store version, build number and installerStore in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("version", _packageInfo.version);
    await prefs.setString("buildNumber", _packageInfo.buildNumber);
    await prefs.setString("installerStore", _packageInfo.installerStore!);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initPackageInfo();
    // print(counter.toString());
    // if counter == 5 or 20, show review dialog
    if (counter == 5 || counter == 20) {
      // print('show review dialog ' + counter.toString());
      _showReviewDialog();
    }
    // set system navigation bar color and icon brightness for android
    var mySystemTheme = _brightness == Brightness.light
        ? SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor:
                CupertinoTheme.of(context).barBackgroundColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor:
                CupertinoTheme.of(context).barBackgroundColor,
            systemNavigationBarIconBrightness: Brightness.light,
          );
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFE71939), brightness: _brightness),
          primaryColor: const Color(0xFFE71939),
        ),
        child: CupertinoApp(
          navigatorKey: NavigationService.navigatorKey,
          title: 'GoKnights',
          debugShowCheckedModeBanner: false,
          theme: const CupertinoThemeData(
            applyThemeToAll: true,
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
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(
                  useCountryCode: false,
                  fallbackFile: 'en',
                  basePath: 'assets/flutter_i18n'),
              missingTranslationHandler: (key, locale) {
                print(
                    "--- Missing Key: $key, languageCode: ${locale?.languageCode}");
              },
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('es'), // Spanish
            Locale('zh'), // Chinese
            Locale('he'), // Hebrew
            Locale('hi'), // Hindi
            // Locale('it'), // Italian
            // Locale('ru'), // Russian
          ],
          localeListResolutionCallback: (allLocales, supportedLocales) {
            final locale = allLocales?.first.languageCode;
            if (locale == 'en') {
              return const Locale('en', 'US');
            }
            if (locale == 'es') {
              return const Locale('es', 'ES');
            }
            if (locale == 'zh') {
              return const Locale('zh', 'CN');
            }
            if (locale == 'he') {
              return const Locale('he', 'IL');
            }
            if (locale == 'hi') {
              return const Locale('hi', 'IN');
            }
            // The default locale
            return const Locale('en', 'US');
          },
          builder: FlutterI18n.rootAppBuilder(),
          home: counter == 0
              ? const OnboardingPage()
              : const CupertinoTabBarDemo(),
        ));
  }
}
