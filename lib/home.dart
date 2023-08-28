import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quick_actions/quick_actions.dart';

import 'map.dart';
import 'options.dart';
import 'dept/tutoring.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon);
  final String title;
  final IconData icon;
}

class CupertinoTabBarDemo extends StatelessWidget {
  const CupertinoTabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final tabInfo = [
      const _TabInfo(
        'Discover',
        CupertinoIcons.layers_alt,
      ),
      const _TabInfo(
        'Map',
        CupertinoIcons.map,
      ),
      const _TabInfo(
        'Me',
        CupertinoIcons.profile_circled,
      ),
    ];

    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 17),
      child: CupertinoTabScaffold(
        restorationId: 'cupertino_tab_scaffold',
        tabBar: CupertinoTabBar(
          items: [
            for (final tabInfo in tabInfo)
              BottomNavigationBarItem(
                label: tabInfo.title,
                icon: Icon(tabInfo.icon),
              ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            restorationScopeId: 'cupertino_tab_view_$index',
            defaultTitle: tabInfo[index].title,
            builder: (context) => _CupertinoDemoTab(
              title: tabInfo[index].title,
              icon: tabInfo[index].icon,
            ),
          );
        },
      ),
    );
  }
}

class _CupertinoDemoTab extends StatelessWidget {
  const _CupertinoDemoTab({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (icon == CupertinoIcons.layers_alt) {
      return MyHomePage(title: title);
    } else if (icon == CupertinoIcons.map) {
      return MyMapPage(title: title);
    } else if (icon == CupertinoIcons.profile_circled) {
      return MyOptionsPage(title: title);
    } else {
      return Container();
    }
  }
}

/// This is the stateless widget that the main application instantiates.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showCounselingActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Counseling'),
        message: const Text(
            "Licensed psychologists and counselors offer individual counseling, groups, and referrals to appropriate college or community resources. All sessions are free and confidential.\nTo set up your first appointment, the first step is to email or call our office. Students will be scheduled a time for a brief screening with a counselor.\n\nLocation: Frese Hall 1st Floor\nEmail: CounselingServices@qc.cuny.edu\nPhone: 718-997-5420"),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _launchURL('mailto:CounselingServices@qc.cuny.edu');
            },
            child: const Text('Make an Appointment'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://www.qc.cuny.edu/cs/');
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  void _showPrintingActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Printing'),
        message: const Text(
            "Student QCard comes with \$10 printing fund each semester (5 cents a page). Upload your documents to the printing system and print them out at any printer on campus:\n\n•	Rosenthal Library 2nd floor\n• I Building 2nd floor lab\n• Powdermaker Hall 210\n• Kiely Hall 131\n• Student Union LL52\n• Queens Hall Lobby"),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://qcprint.qc.cuny.edu/myprintcenter/#');
            },
            child: const Text('Upload Documents'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL(
                  'https://www.qc.cuny.edu/its/wp-content/uploads/sites/16/2022/08/QC-Printing-and-Copying.pdf');
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  void _showShuttleActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Shuttle'),
        message: const Text(
            'Any Queens College student may ride the shuttle by displaying a current QCard as identification.'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _launchURL(
                  'https://queenscollegeshuttles.com/map?showHeader=0&route=3235&silent_disable_timeout=1');
            },
            child: const Text('Real Time Map'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL(
                  'https://www.calendarwiz.com/mobile.html?crd=queenscollege&nolognavbar=1&cid[]=255008#');
            },
            child: const Text('Schedule'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://www.qc.cuny.edu/a/shuttle/');
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  // String shortcut = 'no action set';
  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType == 'action_printing') {
          // shortcut = 'action one';
          _launchURL('https://qcprint.qc.cuny.edu/myprintcenter/#');
        } else if (shortcutType == 'action_shuttle') {
          // shortcut = 'action two';
          _showShuttleActionSheet(context);
        }
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'action_printing',
        localizedTitle: 'Printing',
      ),
      const ShortcutItem(type: 'action_shuttle', localizedTitle: 'Shuttle'),
    ]).then((void _) {
      setState(() {
        // if (shortcut == 'no action set') {
        //   shortcut = 'actions ready';
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if landscape, show 5 icons per row; if portrait, show 3 icons per row
    final columnCount =
        MediaQuery.of(context).orientation == Orientation.landscape ? 5 : 3;
    List<Map<String, dynamic>> iconList = [
      {
        'icon': CupertinoIcons.text_badge_checkmark,
        'name': 'Advising',
        'url': 'https://bbhosted.cuny.edu/webapps/login/',
      },
      {
        'icon': CupertinoIcons.book,
        'name': 'Tutoring',
        'url': 'https://www.qc.cuny.edu/academics/qclc/#tutoring',
      },
      {
        'icon': CupertinoIcons.rectangle_stack_fill_badge_person_crop,
        'name': 'Careers',
        'url': 'https://www.qc.cuny.edu/academics/cei/',
      },
      {
        'icon': CupertinoIcons.tickets,
        'name': 'Scholarships',
        'url': 'https://www.qc.cuny.edu/academics/ohs/',
      },
      {
        'icon': CupertinoIcons.chat_bubble_2,
        'name': 'Counseling',
        'url': 'https://www.qc.cuny.edu/cs/',
      },
      {
        'icon': CupertinoIcons.bookmark,
        'name': 'Library',
        'url': 'https://library.qc.cuny.edu/',
      },
      {
        'icon': CupertinoIcons.printer,
        'name': 'Printing',
        'url': 'https://qcprint.qc.cuny.edu/myprintcenter/#',
      },
      {
        'icon': CupertinoIcons.calendar,
        'name': 'Calendar',
        'url':
            'https://www.calendarwiz.com/mobile.html?crd=queenscollege&nolognavbar=1&cid[]=all#',
      },
      {
        'icon': CupertinoIcons.phone,
        'name': 'Directory',
        'url': 'https://www.qc.cuny.edu/directory/',
      },
      {
        'icon': CupertinoIcons.bus,
        'name': 'Shuttle',
        'url':
            'https://queenscollegeshuttles.com/map?showHeader=0&route=3235&silent_disable_timeout=1',
      },
      {
        'icon': CupertinoIcons.sportscourt,
        'name': 'Sports',
        'url': 'https://queensknights.com/index.aspx',
      },
    ];

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('GoKnights'),
      ),
      child: AnimationLimiter(
        child: GridView.count(
            crossAxisCount: columnCount,
            children: List.generate(
              iconList.length,
              (int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: columnCount,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: Container(
                        // margin: const EdgeInsets.all(10),
                        color: const CupertinoDynamicColor.withBrightness(
                          color: CupertinoColors.white,
                          darkColor: CupertinoColors.black,
                        ).resolveFrom(context),
                        child: CupertinoButton(
                          onPressed: () {
                            if (iconList[index]['name'] == 'Tutoring') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const MyTutoringPage(
                                        title: 'Tutoring')),
                              );
                            } else if (iconList[index]['name'] ==
                                'Counseling') {
                              _showCounselingActionSheet(context);
                            } else if (iconList[index]['name'] == 'Shuttle') {
                              _showShuttleActionSheet(context);
                            } else if (iconList[index]['name'] == 'Printing') {
                              _showPrintingActionSheet(context);
                            } else {
                              _launchURL(iconList[index]['url']);
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                iconList[index]['icon'],
                                size: 50,
                                color: const Color(0xFFE71939),
                              ),
                              // wrap text in FittedBox to prevent overflow
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  iconList[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFE71939),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}
