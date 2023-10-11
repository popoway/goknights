import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:goknights/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.title});

  final String title;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _setRole(String newRole) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('role', newRole).then((bool success) {
        return newRole;
      });
    });
  }

  void _showGetStartedActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
            FlutterI18n.translate(context, "onboarding.get-started-title")),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(FlutterI18n.translate(context, "button.cancel")),
        ),
        message: Text(
            FlutterI18n.translate(context, "onboarding.get-started-message")),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              _setRole('current');
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const CupertinoTabBarDemo()));
            },
            child: Text(FlutterI18n.translate(context, "role.current")),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _setRole('prospective');
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const CupertinoTabBarDemo()));
            },
            child: Text(FlutterI18n.translate(context, "role.prospective")),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _setRole('faculty');
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const CupertinoTabBarDemo()));
            },
            child: Text(FlutterI18n.translate(context, "role.faculty")),
          ),
        ],
      ),
    );
  }

  double widget1Opacity = 0;
  double widget2Opacity = 0;
  double widget3Opacity = 0;
  double widget4Opacity = 0;
  double widget5Opacity = 0;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        widget1Opacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        widget2Opacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      setState(() {
        widget3Opacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        widget4Opacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        widget5Opacity = 1;
      });
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
      // forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,) from onboarding.dart)
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: CupertinoPageScaffold(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    // add a fade in animation to the logo using Animated Opacity
                    AnimatedOpacity(
                      opacity: widget1Opacity,
                      duration: const Duration(seconds: 1),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20), // Image border
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(48), // Image radius
                              child: Image.asset('assets/icon/icon.png',
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 16), // Add a 16px padding
                          Text(
                              FlutterI18n.translate(
                                  context, "onboarding.title"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const CupertinoDynamicColor
                                      .withBrightness(
                                    color: CupertinoColors.black,
                                    darkColor: CupertinoColors.white,
                                  ).resolveFrom(context),
                                  fontSize: 24)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    AnimatedOpacity(
                      opacity: widget2Opacity,
                      duration: const Duration(seconds: 1),
                      child: Column(
                        children: [
                          Container(
                            // add a padding left and right
                            padding: const EdgeInsets.only(left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Icon(
                                    CupertinoIcons
                                        .square_stack_3d_down_right_fill,
                                    size: 36),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        FlutterI18n.translate(
                                            context, "onboarding.prompt1a"),
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: const CupertinoDynamicColor
                                              .withBrightness(
                                            color: CupertinoColors.black,
                                            darkColor: CupertinoColors.white,
                                          ).resolveFrom(context),
                                        ),
                                      ),
                                      Text(
                                        FlutterI18n.translate(
                                            context, "onboarding.prompt1b"),
                                        style: TextStyle(
                                          color: const CupertinoDynamicColor
                                              .withBrightness(
                                            color: CupertinoColors.black,
                                            darkColor: CupertinoColors.white,
                                          ).resolveFrom(context),
                                        ),
                                        maxLines: 3,
                                        textAlign: TextAlign.justify,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    AnimatedOpacity(
                      opacity: widget3Opacity,
                      duration: const Duration(seconds: 1),
                      child: Column(
                        children: [
                          Container(
                            // add a padding left and right
                            padding: const EdgeInsets.only(left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Icon(CupertinoIcons.map_pin_ellipse,
                                    size: 36),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        FlutterI18n.translate(
                                            context, "onboarding.prompt2a"),
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: const CupertinoDynamicColor
                                              .withBrightness(
                                            color: CupertinoColors.black,
                                            darkColor: CupertinoColors.white,
                                          ).resolveFrom(context),
                                        ),
                                      ),
                                      Text(
                                        FlutterI18n.translate(
                                            context, "onboarding.prompt2b"),
                                        style: TextStyle(
                                          color: const CupertinoDynamicColor
                                              .withBrightness(
                                            color: CupertinoColors.black,
                                            darkColor: CupertinoColors.white,
                                          ).resolveFrom(context),
                                        ),
                                        maxLines: 3,
                                        textAlign: TextAlign.justify,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    AnimatedOpacity(
                      opacity: widget4Opacity,
                      duration: const Duration(seconds: 1),
                      child: Column(
                        children: [
                          Container(
                            // add a padding left and right
                            padding: const EdgeInsets.only(left: 32, right: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Icon(CupertinoIcons.question, size: 36),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        FlutterI18n.translate(
                                            context, "onboarding.prompt3a"),
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: const CupertinoDynamicColor
                                              .withBrightness(
                                            color: CupertinoColors.black,
                                            darkColor: CupertinoColors.white,
                                          ).resolveFrom(context),
                                        ),
                                      ),
                                      Text(
                                        FlutterI18n.translate(
                                            context, "onboarding.prompt3b"),
                                        style: TextStyle(
                                          color: const CupertinoDynamicColor
                                              .withBrightness(
                                            color: CupertinoColors.black,
                                            darkColor: CupertinoColors.white,
                                          ).resolveFrom(context),
                                        ),
                                        maxLines: 3,
                                        textAlign: TextAlign.justify,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                    child: AnimatedOpacity(
                  opacity: widget5Opacity,
                  duration: const Duration(seconds: 1),
                  child: CupertinoButton.filled(
                    onPressed: () {
                      _showGetStartedActionSheet(context);
                    },
                    child: Text(FlutterI18n.translate(
                        context, "onboarding.get-started")),
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
