import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class MyStudentLifePage extends StatefulWidget {
  const MyStudentLifePage({super.key, required this.title});

  final String title;

  @override
  State<MyStudentLifePage> createState() => _MyStudentLifePageState();
}

class _MyStudentLifePageState extends State<MyStudentLifePage> {
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
            largeTitle:
                Text(FlutterI18n.translate(context, "home.student-life")),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(context, "student-life.osdl"),
                      style: optionTextStyle),
                  footer: Text(
                      FlutterI18n.translate(
                          context, "student-life.osdl-message"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "student-life.clubs"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/sl/clubs-and-organizations/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "student-life.student-association"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/sl/student-association/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "student-life.food-pantry"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/sdl/food-pantry/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "student-life.nso"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://www.qc.cuny.edu/sdl/osdl-nso/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "button.learn-more"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://www.qc.cuny.edu/sdl/'),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(context, "student-life.vpsa"),
                      style: optionTextStyle),
                  footer: Text(
                      FlutterI18n.translate(
                          context, "student-life.vpsa-message"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "student-life.student-affairs"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/student-affairs-enrollment-management/sa/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "student-life.meet-our-staff"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/student-affairs-enrollment-management/saemdirectory/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "button.learn-more"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/student-affairs-enrollment-management/'),
                    ),
                  ],
                ),
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
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}
