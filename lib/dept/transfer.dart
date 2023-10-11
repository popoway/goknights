import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTransferPage extends StatefulWidget {
  const MyTransferPage({super.key, required this.title});

  final String title;

  @override
  State<MyTransferPage> createState() => _MyTransferPageState();
}

class _MyTransferPageState extends State<MyTransferPage> {
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
            largeTitle: Text(FlutterI18n.translate(context, "home.transfer")),
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
                          context, "transfer.transfer-explorer"),
                      style: optionTextStyle),
                  footer: Text(
                      FlutterI18n.translate(
                          context, "transfer.transfer-explorer-message"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "transfer.transfer-explorer-by-course"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://explorer.cuny.edu/course-transfer'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(
                              context, "transfer.transfer-explorer-by-subject"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://explorer.cuny.edu/transfer-rules'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context,
                              "transfer.transfer-explorer-by-transcript"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://explorer.cuny.edu/logincuny'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context, "button.learn-more"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://explorer.cuny.edu/'),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: Text(
                      FlutterI18n.translate(
                          context, "transfer.qc-transfer-support"),
                      style: optionTextStyle),
                  footer: Text(
                      FlutterI18n.translate(
                          context, "transfer.qc-transfer-support-message"),
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context,
                              "transfer.qc-transfer-support-transfer-honors"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/academics/ohs/transfer-honors-program/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context,
                              "transfer.qc-transfer-support-transfer-advising"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/aac/transfer-advising/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text(
                          FlutterI18n.translate(context,
                              "transfer.qc-transfer-support-international-transfer"),
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://www.qc.cuny.edu/academics/iss/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('STEM Academy', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://lagcc-cuny.digication.com/queens-stem-academy/home-1/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('ACE QC', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://www.qc.cuny.edu/aceqc/ace/'),
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
