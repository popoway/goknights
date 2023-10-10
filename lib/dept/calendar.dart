import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MyCalendarPage extends StatefulWidget {
  const MyCalendarPage({super.key, required this.title});

  final String title;

  @override
  State<MyCalendarPage> createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  WebViewController controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            try {
              // set .action_row style: background: linear-gradient(to bottom, #d25252 0%,#a32a2a 100%);
              controller.runJavaScript(
                  'document.getElementsByClassName("action_row")[0].style.background = "linear-gradient(to bottom, #d25252 0%,#a32a2a 100%)"');
              // set a new stylesheet which sets class "ath-container" display: none
              controller.runJavaScript(
                  'var style = document.createElement("style"); style.innerHTML = ".ath-container { display: none; }"; document.head.appendChild(style);');
            } catch (e) {
              print(e);
            }
            print('JS executed');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://www.calendarwiz.com/mobile.html?crd=queenscollege&nolognavbar=1&cid[]=all#'));

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(FlutterI18n.translate(context, "home.calendar")),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.share),
            onPressed: () async {
              Share.share(await controller.currentUrl() as String,
                  subject: 'QC Calendar from GoKnights',
                  // from the right edge of the screen
                  sharePositionOrigin: Rect.fromLTWH(
                      MediaQuery.of(context).size.width - 75, 0, 60, 70));
            },
          ),
        ),
        child: SafeArea(child: WebViewWidget(controller: controller)));
  }
}
