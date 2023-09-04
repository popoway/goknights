import 'package:flutter/cupertino.dart';
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
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Transfer'),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CupertinoListSection.insetGrouped(
                  header:
                      Text('CUNY Transfer Explorer', style: optionTextStyle),
                  footer: Text(
                      'CUNY Transfer Explorer makes important information about college transfer public and easy to understand so that students know what to expect before they enroll in a new college.\n * CUNY login required',
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text('CUNY to CUNY by Course',
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://explorer.cuny.edu/course-transfer'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('CUNY to CUNY by Subject',
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://explorer.cuny.edu/transfer-rules'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('CUNY to CUNY by Transcript *',
                          style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://explorer.cuny.edu/logincuny'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Learn More', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL('https://explorer.cuny.edu/'),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: Text('QC Transfer Support', style: optionTextStyle),
                  footer: Text(
                      'ACE QC is a comprehensive support program designed to build on transfer students’ academic momentum and help students complete their bachelor’s degree on time.',
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title: Text('Transfer Honors', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/academics/ohs/transfer-honors-program/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Transfer Advising', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/aac/transfer-advising/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('International Transfer',
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
