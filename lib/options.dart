import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:goknights/main.dart';
import 'package:goknights/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app_settings/app_settings.dart';
import 'package:in_app_review/in_app_review.dart';
import 'aboutapp.dart';

class MyOptionsPage extends StatefulWidget {
  const MyOptionsPage({super.key, required this.title});

  final String title;

  @override
  State<MyOptionsPage> createState() => _MyOptionsPageState();
}

TextStyle optionTextStyle = TextStyle(
    color: const CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.black,
  darkColor: CupertinoColors.white,
).resolveFrom(NavigationService.navigatorKey.currentContext!));

class _MyOptionsPageState extends State<MyOptionsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;
  late Future<String> _role;

  CupertinoListSection myAcademicListSection =
      CupertinoListSection.insetGrouped(
    header: Text('My Academics', style: optionTextStyle),
    children: <CupertinoListTile>[
      CupertinoListTile.notched(
        title: Text('Apply to QC', style: optionTextStyle),
        leading: const Icon(
          CupertinoIcons.square_arrow_right,
        ),
        trailing: const CupertinoListTileChevron(),
        onTap: () => _launchURL('https://www.qc.cuny.edu/apply/'),
      ),
      CupertinoListTile.notched(
        title: Text('CUNYFirst', style: optionTextStyle),
        leading: const Icon(
          CupertinoIcons.rectangle_on_rectangle_angled,
        ),
        trailing: const CupertinoListTileChevron(),
        onTap: () => _launchURL('https://home.cunyfirst.cuny.edu/'),
      ),
      CupertinoListTile.notched(
        title: Text('QC Navigate', style: optionTextStyle),
        leading: const Icon(
          CupertinoIcons.compass,
        ),
        trailing: const CupertinoListTileChevron(),
        onTap: () => _launchURL(
            'https://qc-cuny.navigate.eab.com/api/v1/auth/login/?return_to=https%3A%2F%2Fqc-cuny.navigate.eab.com%2F%23%2Fmy%2Fpriority-feed%2F'),
      ),
    ],
  );

  Future getCurrentAcademicList() async {
    _role.then((value) => {
          // if the role is 'current', then build myAcademicListSection with student email option
          if (value == 'prospective')
            {
              setState(() {
                myAcademicListSection = CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(context, "options.my-academics"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "options.apply-to-qc"),
                          style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.square_arrow_right,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://www.qc.cuny.edu/apply/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('CUNYFirst', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.rectangle_on_rectangle_angled,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://home.cunyfirst.cuny.edu/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('QC Navigate', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.compass,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://qc-cuny.navigate.eab.com/api/v1/auth/login/?return_to=https%3A%2F%2Fqc-cuny.navigate.eab.com%2F%23%2Fmy%2Fpriority-feed%2F'),
                    ),
                  ],
                );
              }),
            }
          else if (value == 'faculty')
            {
              setState(() {
                myAcademicListSection = CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(context, "options.my-academics"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text('CUNYFirst', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.rectangle_on_rectangle_angled,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://home.cunyfirst.cuny.edu/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Brightspace', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.square_list,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://brightspace.cuny.edu/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "options.staff-email"),
                          style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.mail,
                      ),
                      additionalInfo: const Text(
                        '@login.cuny.edu',
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://outlook.com/login.cuny.edu'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('QC Navigate Staff', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.compass,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://qc-cuny.campus.eab.com/'),
                    ),
                  ],
                );
              }),
            }
          else
            {
              setState(() {
                myAcademicListSection = CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(context, "options.my-academics"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text('CUNYFirst', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.rectangle_on_rectangle_angled,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://home.cunyfirst.cuny.edu/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Brightspace', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.square_list,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://brightspace.cuny.edu/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "options.student-email"),
                          style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.mail,
                      ),
                      additionalInfo: const Text(
                        '@qmail.cuny.edu',
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://login.microsoftonline.com/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Degreeworks', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.chart_pie,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://degreeworks.cuny.edu/Dashboard_qc'),
                    ),
                    CupertinoListTile.notched(
                      title:
                          Text('QC Navigate Student', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.compass,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://qc-cuny.navigate.eab.com/api/v1/auth/login/?return_to=https%3A%2F%2Fqc-cuny.navigate.eab.com%2F%23%2Fmy%2Fpriority-feed%2F'),
                    ),
                  ],
                );
              }),
            }
        });
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counter') ?? 0;
    });
    _role = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('role') ?? 'current';
    });
    getCurrentAcademicList();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    // list tile text style that match light dark mode of system
    final TextStyle optionTextStyle = TextStyle(
        color: const CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.black,
      darkColor: CupertinoColors.white,
    ).resolveFrom(context));

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        // A list of sliver widgets.
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(FlutterI18n.translate(context, "home.me")),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverToBoxAdapter(
            child: SizedBox(
              height: 900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  myAcademicListSection,
                  CupertinoListSection.insetGrouped(
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                        title: Text('ITS Help Desk', style: optionTextStyle),
                        leading: const Icon(
                          CupertinoIcons.cursor_rays,
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://support.qc.cuny.edu/support/home'),
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: Text(
                        FlutterI18n.translate(context, "options.app-settings"),
                        style: optionTextStyle),
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "options.switch-role"),
                            style: optionTextStyle),
                        leading: const Icon(
                          CupertinoIcons.person_2,
                        ),
                        trailing: const CupertinoListTileChevron(),
                        additionalInfo: FutureBuilder<String>(
                            future: _role,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return const CircularProgressIndicator
                                      .adaptive(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFFE71939)));
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // if 'current', then show 'Current Student', if 'prospective', then show 'Prospective Student', if 'faculty', then show 'Faculty / Staff'
                                    return Text(
                                      snapshot.data == 'current'
                                          ? FlutterI18n.translate(
                                              context, "role.current")
                                          : snapshot.data == 'prospective'
                                              ? FlutterI18n.translate(
                                                  context, "role.prospective")
                                              : FlutterI18n.translate(
                                                  context, "role.faculty"),
                                    );
                                  }
                              }
                            }),
                        onTap: () => {
                          // need to pop the current page (with nav) to go back to onboarding
                          Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const OnboardingPage())),
                        },
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "options.switch-language"),
                            style: optionTextStyle),
                        leading: const Icon(CupertinoIcons.globe),
                        trailing: const CupertinoListTileChevron(),
                        // list FlutterI18n.currentLocale and the corresponding language name
                        additionalInfo: Text(
                          '${FlutterI18n.translate(context, "language.${FlutterI18n.currentLocale(context).toString()}")} (${FlutterI18n.currentLocale(context).toString()})',
                        ),
                        onTap: () => AppSettings.openAppSettings(
                            type: AppSettingsType.settings),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "options.send-feedback"),
                            style: optionTextStyle),
                        leading: const Icon(
                          CupertinoIcons.pencil_outline,
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            // include app version and build number in subject, ask the user to not remove the app version and build number when sending
                            'mailto:ming.lei@qc.cuny.edu?subject=GoKnights%20Feedback%20v${_packageInfo.version}%20(${_packageInfo.buildNumber})&body=Please%20do%20not%20remove%20the%20app%20version%20and%20build%20number%20below%20when%20sending%20feedback.%0A%0A%0A%0A%0A%0A%0A%0A%0A%0AApp%20Version%3A%20${_packageInfo.version}%0ABuild%20Number%3A%20${_packageInfo.buildNumber}%0A'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "options.rate-this-app"),
                            style: optionTextStyle),
                        leading: const Icon(
                          CupertinoIcons.star,
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () {
                          final InAppReview inAppReview = InAppReview.instance;
                          inAppReview.openStoreListing(
                              appStoreId: '6463623285');
                        },
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(context, "options.about-app"),
                            style: optionTextStyle),
                        leading: const Icon(
                          CupertinoIcons.info,
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (BuildContext context) => AboutAppPage(
                                  title: FlutterI18n.translate(
                                      context, "aboutapp.about")),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  FutureBuilder<int>(
                      future: _counter,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFE71939)));
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                  'GoKnights has enlivened your college experience ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.',
                                  style: TextStyle(
                                      color: const CupertinoDynamicColor
                                          .withBrightness(
                                        color: CupertinoColors.black,
                                        darkColor: CupertinoColors.white,
                                      ).resolveFrom(context),
                                      fontSize: 12));
                            }
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  // launch in web browser
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
