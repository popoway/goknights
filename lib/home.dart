import 'package:flutter/cupertino.dart';
import 'package:goknights/dept/transfer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

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

    return WillPopScope(
      // forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,) from onboarding.dart)
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: DefaultTextStyle(
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _role = Future<String>.value('current');

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

  List<Map<String, dynamic>> iconListCurrent = [];
  final List<Map<String, dynamic>> iconList = [
    {
      'icon': CupertinoIcons.arrow_right_arrow_left,
      'name': 'Transfer',
      'url': 'https://queensknights.com/index.aspx',
      'role': ['prospective'],
    },
    {
      'icon': CupertinoIcons.text_badge_checkmark,
      'name': 'Advising',
      'url': 'https://www.qc.cuny.edu/aac/',
      'role': ['current', 'prospective'],
    },
    {
      'icon': CupertinoIcons.book,
      'name': 'Tutoring',
      'url': 'https://www.qc.cuny.edu/academics/qclc/#tutoring',
      'role': ['current'],
    },
    {
      'icon': CupertinoIcons.rectangle_stack_fill_badge_person_crop,
      'name': 'Careers',
      'url': 'https://www.qc.cuny.edu/academics/cei/',
      'role': ['current', 'prospective'],
    },
    {
      'icon': CupertinoIcons.tickets,
      'name': 'Scholarships',
      'url': 'https://www.qc.cuny.edu/academics/ohs/',
      'role': ['current', 'prospective'],
    },
    {
      'icon': CupertinoIcons.chat_bubble_2,
      'name': 'Counseling',
      'url': 'https://www.qc.cuny.edu/cs/',
      'role': ['current'],
    },
    {
      'icon': CupertinoIcons.bookmark,
      'name': 'Library',
      'url': 'https://library.qc.cuny.edu/',
      'role': ['current', 'faculty'],
    },
    {
      'icon': CupertinoIcons.printer,
      'name': 'Printing',
      'url': 'https://qcprint.qc.cuny.edu/myprintcenter/#',
      'role': ['current', 'faculty'],
    },
    {
      'icon': CupertinoIcons.calendar,
      'name': 'Calendar',
      'url':
          'https://www.calendarwiz.com/mobile.html?crd=queenscollege&nolognavbar=1&cid[]=all#',
      'role': ['current', 'prospective', 'faculty'],
    },
    {
      'icon': CupertinoIcons.phone,
      'name': 'Directory',
      'url': 'https://www.qc.cuny.edu/directory/',
      'role': ['current', 'prospective', 'faculty'],
    },
    {
      'icon': CupertinoIcons.bus,
      'name': 'Shuttle',
      'url':
          'https://queenscollegeshuttles.com/map?showHeader=0&route=3235&silent_disable_timeout=1',
      'role': ['current', 'prospective', 'faculty'],
    },
    {
      'icon': CupertinoIcons.sportscourt,
      'name': 'Sports',
      'url': 'https://queensknights.com/index.aspx',
      'role': ['current', 'prospective', 'faculty'],
    },
  ];

  Future getCurrentIconList() async {
    _role.then((String result) {
      iconListCurrent = [];
      for (var i = 0; i < iconList.length; i++) {
        if (iconList[i]['role'].contains(result)) {
          iconListCurrent.add(iconList[i]);
        }
      }
    });
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // navigator pop
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  // String shortcut = 'no action set';
  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(myInterceptor);

    _role = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('role') ?? 'current';
    });
    getCurrentIconList();

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
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if landscape, show 5 icons per row; if portrait, show 3 icons per row
    final columnCount =
        MediaQuery.of(context).orientation == Orientation.landscape ? 5 : 3;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('GoKnights'),
      ),
      child: AnimationLimiter(
        child: GridView.count(
            crossAxisCount: columnCount,
            children: List.generate(
              iconListCurrent.length,
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
                            if (iconListCurrent[index]['name'] == 'Transfer') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const MyTransferPage(title: 'Transfer'),
                                    title: 'Transfer'),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'Tutoring') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const MyTutoringPage(title: 'Tutoring'),
                                    title: 'Tutoring'),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'Counseling') {
                              _showCounselingActionSheet(context);
                            } else if (iconListCurrent[index]['name'] ==
                                'Shuttle') {
                              _showShuttleActionSheet(context);
                            } else if (iconListCurrent[index]['name'] ==
                                'Printing') {
                              _showPrintingActionSheet(context);
                            } else {
                              _launchURL(iconListCurrent[index]['url']);
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                iconListCurrent[index]['icon'],
                                size: 50,
                                color: const Color(0xFFE71939),
                              ),
                              // wrap text in FittedBox to prevent overflow
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  iconListCurrent[index]['name'],
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
