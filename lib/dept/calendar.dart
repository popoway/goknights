import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          onPageStarted: (String url) {},
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Calendar'),
      ),
      child: SafeArea(child: WebViewWidget(controller: controller)),
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
