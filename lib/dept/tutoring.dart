import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTutoringPage extends StatefulWidget {
  const MyTutoringPage({super.key, required this.title});

  final String title;

  @override
  State<MyTutoringPage> createState() => _MyTutoringPageState();
}

class _MyTutoringPageState extends State<MyTutoringPage> {
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
            largeTitle: Text(FlutterI18n.translate(context, "home.tutoring")),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(
                          context, "tutoring.learning-commons"),
                      style: optionTextStyle),
                  footer: Text(
                      FlutterI18n.translate(
                          context, "tutoring.learning-commons-message"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "tutoring.book-an-appointment"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://qclc.mywconline.com/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "tutoring.study-print"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/academics/qclc/#study-print'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "button.learn-more"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/academics/qclc/#tutoring'),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(context, "tutoring.writing-center"),
                      style: optionTextStyle),
                  footer: Text(
                      FlutterI18n.translate(
                          context, "tutoring.writing-center-message"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "tutoring.book-an-appointment"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://www.qc.cuny.edu/academics/wc/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "button.learn-more"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://www.qc.cuny.edu/academics/wc/'),
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
