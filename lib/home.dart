import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'map.dart';
import 'options.dart';
import 'dept/tutoring.dart';
import 'dept/transfer.dart';
import 'dept/directory.dart';
import 'dept/calendar.dart';
import 'dept/library.dart';
import 'dept/careers.dart';
import 'dept/advising.dart';
import 'dept/shuttle_map.dart';

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
      _TabInfo(
        FlutterI18n.translate(context, "home.discover"),
        CupertinoIcons.layers_alt,
      ),
      _TabInfo(
        FlutterI18n.translate(context, "home.map"),
        CupertinoIcons.map,
      ),
      _TabInfo(
        FlutterI18n.translate(context, "home.me"),
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

  void _showTimesheetActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(FlutterI18n.translate(context, "home.timesheet")),
        message: Text(FlutterI18n.translate(context, "timesheet.message")),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(FlutterI18n.translate(context, "button.cancel")),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://apps.qc.cuny.edu/hr_assist/hrlogon.aspx');
            },
            child: Text(FlutterI18n.translate(context, "timesheet.hr")),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://apps.qc.cuny.edu/pr_assist/prlogon.aspx');
            },
            child: Text(FlutterI18n.translate(context, "timesheet.pr")),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _launchURL(
                  'https://support.qc.cuny.edu/support/solutions/articles/15000055324');
            },
            child:
                Text(FlutterI18n.translate(context, "timesheet.how-to-access")),
          ),
        ],
      ),
    );
  }

  void _showCounselingActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(FlutterI18n.translate(context, "home.counseling")),
        message: Text(FlutterI18n.translate(context, "counseling.message")),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(FlutterI18n.translate(context, "button.cancel")),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _launchURL('mailto:CounselingServices@qc.cuny.edu');
            },
            child: Text(FlutterI18n.translate(
                context, "counseling.make-an-appointment")),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://www.qc.cuny.edu/cs/');
            },
            child: Text(FlutterI18n.translate(context, "button.learn-more")),
          ),
        ],
      ),
    );
  }

  void _showPrintingActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(FlutterI18n.translate(context, "home.printing")),
        message: Text(FlutterI18n.translate(context, "printing.message")),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(FlutterI18n.translate(context, "button.cancel")),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://qcprint.qc.cuny.edu/myprintcenter/#');
            },
            child: Text(
                FlutterI18n.translate(context, "printing.upload-documents")),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL(
                  'https://www.qc.cuny.edu/its/wp-content/uploads/sites/16/2022/08/QC-Printing-and-Copying.pdf');
            },
            child: Text(FlutterI18n.translate(context, "button.learn-more")),
          ),
        ],
      ),
    );
  }

  void _showShuttleActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(FlutterI18n.translate(context, "home.shuttle")),
        message: Text(FlutterI18n.translate(context, "shuttle.message")),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(FlutterI18n.translate(context, "button.cancel")),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyShuttleMapPage(
                      title: FlutterI18n.translate(
                          context, "shuttle.shuttle-map")),
                  title: FlutterI18n.translate(context, "shuttle.shuttle-map"),
                  fullscreenDialog: true,
                ),
              );
            },
            child:
                Text(FlutterI18n.translate(context, "shuttle.real-time-map")),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL(
                  'https://www.calendarwiz.com/mobile.html?crd=queenscollege&nolognavbar=1&cid[]=255008#');
            },
            child: Text(FlutterI18n.translate(context, "shuttle.schedule")),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchURL('https://www.qc.cuny.edu/a/shuttle/');
            },
            child: Text(FlutterI18n.translate(context, "button.learn-more")),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> iconListCurrent = [];
  final List<Map<String, dynamic>> iconList = [
    {
      'icon': CupertinoIcons.square_arrow_right,
      'name': 'admissions',
      'url': 'https://www.qc.cuny.edu/admissions/',
      'role': ['prospective'],
    },
    {
      'icon': CupertinoIcons.arrow_right_arrow_left,
      'name': 'transfer',
      'url': 'https://queensknights.com/index.aspx',
      'role': ['prospective'],
    },
    {
      'icon': CupertinoIcons.clock_fill,
      'name': 'timesheet',
      'url': 'https://www.qc.cuny.edu/a/staff/',
      'role': ['faculty'],
    },
    {
      'icon': CupertinoIcons.text_badge_checkmark,
      'name': 'advising',
      'url': 'https://www.qc.cuny.edu/aac/',
      'role': ['current', 'prospective'],
    },
    {
      'icon': CupertinoIcons.book,
      'name': 'tutoring',
      'url': 'https://www.qc.cuny.edu/academics/qclc/#tutoring',
      'role': ['current'],
    },
    {
      'icon': CupertinoIcons.rectangle_stack_fill_badge_person_crop,
      'name': 'careers',
      'url': 'https://www.qc.cuny.edu/academics/cei/',
      'role': ['current', 'prospective'],
    },
    {
      'icon': CupertinoIcons.tickets,
      'name': 'scholarships',
      'url': 'https://www.qc.cuny.edu/academics/ohs/',
      'role': ['current', 'prospective'],
    },
    {
      'icon': CupertinoIcons.chat_bubble_2,
      'name': 'counseling',
      'url': 'https://www.qc.cuny.edu/cs/',
      'role': ['current'],
    },
    {
      'icon': CupertinoIcons.bookmark,
      'name': 'library',
      'url': 'https://library.qc.cuny.edu/',
      'role': ['current', 'faculty'],
    },
    {
      'icon': CupertinoIcons.printer,
      'name': 'printing',
      'url': 'https://qcprint.qc.cuny.edu/myprintcenter/#',
      'role': ['current', 'faculty'],
    },
    {
      'icon': CupertinoIcons.calendar,
      'name': 'calendar',
      'url':
          'https://www.calendarwiz.com/mobile.html?crd=queenscollege&nolognavbar=1&cid[]=all#',
      'role': ['current', 'prospective', 'faculty'],
    },
    {
      'icon': CupertinoIcons.phone,
      'name': 'directory',
      'url': 'https://www.qc.cuny.edu/directory/',
      'role': ['current', 'prospective', 'faculty'],
    },
    {
      'icon': CupertinoIcons.bus,
      'name': 'shuttle',
      'url':
          'https://queenscollegeshuttles.com/map?showHeader=0&route=3235&silent_disable_timeout=1',
      'role': ['current', 'prospective', 'faculty'],
    },
    {
      'icon': CupertinoIcons.sportscourt,
      'name': 'sports',
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
        localizedTitle: "Printing",
      ),
      const ShortcutItem(type: 'action_shuttle', localizedTitle: "Shuttle"),
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
                            if (iconListCurrent[index]['name'] == 'transfer') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyTransferPage(
                                        title: FlutterI18n.translate(
                                            context, "home.transfer")),
                                    title: FlutterI18n.translate(
                                        context, "home.transfer")),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'tutoring') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyTutoringPage(
                                        title: FlutterI18n.translate(
                                            context, "home.tutoring")),
                                    title: FlutterI18n.translate(
                                        context, "home.tutoring")),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'directory') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyDirectoryPage(
                                        title: FlutterI18n.translate(
                                            context, "home.directory")),
                                    title: FlutterI18n.translate(
                                        context, "home.directory")),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'calendar') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyCalendarPage(
                                        title: FlutterI18n.translate(
                                            context, "home.calendar")),
                                    title: FlutterI18n.translate(
                                        context, "home.calendar")),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'library') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyLibraryPage(
                                        title: FlutterI18n.translate(
                                            context, "home.library")),
                                    title: FlutterI18n.translate(
                                        context, "home.library")),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'advising') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyAdvisingPage(
                                        title: FlutterI18n.translate(
                                            context, "home.advising")),
                                    title: FlutterI18n.translate(
                                        context, "home.advising")),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'careers') {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyCareersPage(
                                        title: FlutterI18n.translate(
                                            context, "home.careers")),
                                    title: FlutterI18n.translate(
                                        context, "home.careers")),
                              );
                            } else if (iconListCurrent[index]['name'] ==
                                'timesheet') {
                              _showTimesheetActionSheet(context);
                            } else if (iconListCurrent[index]['name'] ==
                                'counseling') {
                              _showCounselingActionSheet(context);
                            } else if (iconListCurrent[index]['name'] ==
                                'shuttle') {
                              _showShuttleActionSheet(context);
                            } else if (iconListCurrent[index]['name'] ==
                                'printing') {
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
                                  FlutterI18n.translate(context,
                                      'home.${iconListCurrent[index]['name']}'),
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
