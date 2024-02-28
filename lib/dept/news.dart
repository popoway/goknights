import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class MyNewsPage extends StatefulWidget {
  const MyNewsPage({super.key, required this.title});

  final String title;

  @override
  State<MyNewsPage> createState() => _MyNewsPageState();
}

class _MyNewsPageState extends State<MyNewsPage> {
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
            largeTitle: Text(FlutterI18n.translate(context, "home.news")),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverToBoxAdapter(
            child: SizedBox(
              height: 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CupertinoListSection.insetGrouped(
                    header: Text(FlutterI18n.translate(context, "news.ocm"),
                        style: optionTextStyle),
                    footer: Text(
                        FlutterI18n.translate(context, "news.ocm-message"),
                        style: optionTextStyle),
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(context, "news.qview"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.qc.cuny.edu/communications/the-qview/'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "news.frankly-speaking"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.qc.cuny.edu/po/frankly-speaking/'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(context, "news.archive"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.qc.cuny.edu/communications/press-release-archive/'),
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: Text(FlutterI18n.translate(context, "news.tkn"),
                        style: optionTextStyle),
                    footer: Text(
                        FlutterI18n.translate(context, "news.tkn-message"),
                        style: optionTextStyle),
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(context, "news.campus-news"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.theknightnews.com/category/local-news/qc-news/'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(context, "news.op-eds"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.theknightnews.com/category/op-eds/'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(context, "button.learn-more"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () =>
                            _launchURL('https://www.theknightnews.com/'),
                      ),
                    ],
                  ),
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
  // launch in web browser, new window
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}
