import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyShuttleMapPage extends StatefulWidget {
  const MyShuttleMapPage({super.key, required this.title});

  final String title;

  @override
  State<MyShuttleMapPage> createState() => _MyShuttleMapPageState();
}

class _MyShuttleMapPageState extends State<MyShuttleMapPage> {
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
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.google.com/')) {
              // open request.url in a browser
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://queenscollegeshuttles.com/map?showHeader=0&route=3235&silent_disable_timeout=1'));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(FlutterI18n.translate(context, "shuttle.shuttle-map")),
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
