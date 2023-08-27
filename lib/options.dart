import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'aboutapp.dart';

class MyOptionsPage extends StatefulWidget {
  const MyOptionsPage({super.key, required this.title});

  final String title;

  @override
  State<MyOptionsPage> createState() => _MyOptionsPageState();
}

class _MyOptionsPageState extends State<MyOptionsPage> {
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
                      title: Text('Send Feedback', style: optionTextStyle),
                      leading: const Icon(
                        CupertinoIcons.pencil_outline,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'mailto:ming@popoway.com?subject=GoKnights%20feedback'),
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
