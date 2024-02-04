import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCareersPage extends StatefulWidget {
  const MyCareersPage({super.key, required this.title});

  final String title;

  @override
  State<MyCareersPage> createState() => _MyCareersPageState();
}

class _MyCareersPageState extends State<MyCareersPage> {
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
            largeTitle: Text(FlutterI18n.translate(context, "home.careers")),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverToBoxAdapter(
            child: SizedBox(
              height: 950,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CupertinoListSection.insetGrouped(
                    header: Text(FlutterI18n.translate(context, "careers.cei"),
                        style: optionTextStyle),
                    footer: Text(
                        FlutterI18n.translate(context, "careers.cei-message"),
                        style: optionTextStyle),
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "careers.career-liaisons"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.qc.cuny.edu/academics/cei/career-meet-the-team/'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "careers.upcoming-workshops-events"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.qc.cuny.edu/academics/cei/next-workshop/'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "careers.join-hireqc"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://queenscollege-csm.symplicity.com/'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(context, "button.learn-more"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://www.qc.cuny.edu/academics/cei/'),
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    header: Text(FlutterI18n.translate(context, "careers.cdc"),
                        style: optionTextStyle),
                    footer: Text(
                        FlutterI18n.translate(context, "careers.cdc-message"),
                        style: optionTextStyle),
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "careers.upcoming-workshops-events"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL('https://linktr.ee/qcareers'),
                      ),
                      CupertinoListTile.notched(
                        title: Text(
                            FlutterI18n.translate(
                                context, "careers.join-mailing-list"),
                            style: optionTextStyle),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _launchURL(
                            'https://docs.google.com/forms/d/e/1FAIpQLScBS5SX3wWDiSbFHfKDgXY7PgZ45TmnwRYMfTFIEJOdgNWjHA/viewform'),
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
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
