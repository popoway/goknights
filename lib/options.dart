import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goknights/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'aboutapp.dart';

class MyOptionsPage extends StatefulWidget {
  const MyOptionsPage({super.key, required this.title});

  final String title;

  @override
  State<MyOptionsPage> createState() => _MyOptionsPageState();
}

class _MyOptionsPageState extends State<MyOptionsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;
  late Future<String> _role;

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counter') ?? 0;
    });
    _role = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('role') ?? 'current';
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
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Me'),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CupertinoListSection.insetGrouped(
                  header: Text('My Academics', style: optionTextStyle),
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
                      title: Text('Blackboard', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.square_list,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://bbhosted.cuny.edu'),
                    ),
                    CupertinoListTile.notched(
                      // title that match light dark mode of system
                      title: Text('Student Email', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.mail,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://outlook.office.com/mail/inbox'),
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
                      title: Text('QC Navigate', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.compass,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://qc-cuny.navigate.eab.com/api/v1/auth/login/?return_to=https%3A%2F%2Fqc-cuny.navigate.eab.com%2F%23%2Fmy%2Fpriority-feed%2F'),
                    ),
                  ],
                ),
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
                  header: Text('App Settings', style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text('Switch Role', style: optionTextStyle),
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
                                return const CircularProgressIndicator.adaptive(
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
                                        ? 'Current Student'
                                        : snapshot.data == 'prospective'
                                            ? 'Prospective Student'
                                            : 'Faculty / Staff',
                                  );
                                }
                            }
                          }),
                      onTap: () => {
                        // need to pop the current page (with nav) to go back to onboarding
                        Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                                builder: (context) => const OnboardingPage(
                                    title: 'Welcome to GoKnights'))),
                      },
                    ),
                    CupertinoListTile.notched(
                      title: Text('Send Feedback', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.pencil_outline,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'mailto:goknights-feedback@popoway.com?subject=GoKnights%20Feedback'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('About GoKnights', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.info,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (BuildContext context) =>
                                const AboutAppPage(title: 'About'),
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
                                'GoKnights has enlivened your college experience for ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.',
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
