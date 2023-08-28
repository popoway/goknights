import 'package:flutter/cupertino.dart';
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
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Tutoring'),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CupertinoListSection.insetGrouped(
                  header: Text('Learning Commons', style: optionTextStyle),
                  footer: Text(
                      'The Learning Commons offers free peer tutoring, workshops, study spaces, printing station, and other services.\nLocation: Kiely Hall 131\nEmail: LCommons@qc.cuny.edu\nPhone: 718-997-5670',
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title:
                          Text('Book an Appointment', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://outlook.office365.com/owa/calendar/LearningCommons1@CUNY907.onmicrosoft.com/bookings/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Study & Print', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/academics/qclc/#study-print'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Learn More', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => _launchURL(
                          'https://www.qc.cuny.edu/academics/qclc/#tutoring'),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: Text('Writing Center', style: optionTextStyle),
                  footer: Text(
                      'The Writing Center offers free writing support to all Queens College students, ranging from brainstorming, final revisions, to personal statements and cover letters.\nLocation: Kiely Hall 229\nEmail: qc.writing.center@qc.cuny.edu\nPhone: 718-997-5676',
                      style: optionTextStyle),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                      title:
                          Text('Book an Appointment', style: optionTextStyle),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () =>
                          _launchURL('https://www.qc.cuny.edu/academics/wc/'),
                    ),
                    CupertinoListTile.notched(
                      title: Text('Learn More', style: optionTextStyle),
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
