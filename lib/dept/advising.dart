import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAdvisingPage extends StatefulWidget {
  const MyAdvisingPage({super.key, required this.title});

  final String title;

  @override
  State<MyAdvisingPage> createState() => _MyAdvisingPageState();
}

class _MyAdvisingPageState extends State<MyAdvisingPage> {
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
            largeTitle: Text(FlutterI18n.translate(context, "home.advising")),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CupertinoListSection.insetGrouped(
                  header: Text(FlutterI18n.translate(context, "advising.aac"),
                      style: optionTextStyle),
                  footer: Text(
                      FlutterI18n.translate(context, "advising.aac-message"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "advising.make-advising-appointment"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/navigate/qc-navigate-appointments/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "advising.academic-advising-resources"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/aac/academic-resources/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "advising.specialty-advising"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/aac/specialty-advising/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "advising.meet-our-staff"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/aac/meet-our-staff/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "button.learn-more"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://www.qc.cuny.edu/aac/'),
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
