import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyDirectoryPage extends StatefulWidget {
  const MyDirectoryPage({super.key, required this.title});

  final String title;

  @override
  State<MyDirectoryPage> createState() => _MyDirectoryPageState();
}

class _MyDirectoryPageState extends State<MyDirectoryPage> {
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
              controller.runJavaScript(
                  'var header = document.getElementsByTagName("header")[0]');
              controller.runJavaScript('header.parentNode.removeChild(header)');
              controller.runJavaScript(
                  'var section = document.getElementsByClassName("et_pb_section")[0]');
              controller.runJavaScript('section.style.padding = "0"');
              // remove element which has class "freshwidget-theme"
              controller.runJavaScript(
                  'var freshwidget = document.getElementsByClassName("freshwidget-theme")[0]');
              controller.runJavaScript(
                  'freshwidget.parentNode.removeChild(freshwidget)');
              // set width of <input> to 100vw
              // controller.runJavaScript(
              //     'var input = document.getElementsByTagName("input")[4]');
              // controller.runJavaScript('input.style.width = "100vw"');
              // data table setup
              controller.runJavaScript(
                  'var responsiveExpander = document.getElementsByClassName("responsiveExpander")');
              controller.runJavaScript(
                  'for (var i = 0; i < responsiveExpander.length; i++) {responsiveExpander[i].style.display = "none"}');
              controller.runJavaScript(
                  'var table = \$.fn.dataTable.tables({api: true});');
              controller.runJavaScript('table.column(9).visible(false);');
              controller.runJavaScript('table.column(7).visible(false);');
              controller.runJavaScript('table.column(1).visible(false);');
              // table element style width auto
              controller.runJavaScript(
                  'var tableElement = document.getElementsByTagName("table")[0]');
              controller.runJavaScript('tableElement.style.width = "auto"');
              controller.runJavaScript(
                  'document.getElementsByClassName("et_pb_module_inner")[1].parentNode.removeChild(document.getElementsByClassName("et_pb_module_inner")[1]);');
              // remove footer
              controller.runJavaScript(
                  'var footer = document.getElementsByTagName("footer")[0]');
              controller.runJavaScript('footer.parentNode.removeChild(footer)');
            } catch (e) {
              print(e);
            }
            print('JS executed');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url
                .startsWith('https://support.qc.cuny.edu/support/catalog')) {
              // open request.url in a browser
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.qc.cuny.edu/directory/'));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(FlutterI18n.translate(context, "home.directory")),
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
