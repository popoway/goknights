import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 3
                  : 2,
              child: Container(),
            ),
            Expanded(
              flex: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 6
                  : 10,
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Image border
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(48), // Image radius
                      child: Image.asset('assets/icon/icon.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Text(_packageInfo.appName,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navLargeTitleTextStyle),
                  // text display app version
                  Text(
                      'Version: ${_packageInfo.version} (${_packageInfo.buildNumber})',
                      style: TextStyle(
                          color: const CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.black,
                            darkColor: CupertinoColors.white,
                          ).resolveFrom(context),
                          fontSize: 12)),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text('Copyright © 2023 Ming Lei.',
                        style: TextStyle(
                            color: const CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.black,
                              darkColor: CupertinoColors.white,
                            ).resolveFrom(context),
                            fontSize: 16)),
                  ),
                  CupertinoButton(
                    child: const Text(FlutterI18n.translate(context, "aboutapp.privacy-policy")),
                    onPressed: () => _launchURL(
                        'https://github.com/popoway/goknights/blob/main/PRIVACY.md'),
                  ),
                  CupertinoButton(
                    child: const Text(FlutterI18n.translate(context, "aboutapp.open-source-licenses")),
                    // Displays a LicensePage onClick
                    onPressed: () => showLicensePage(
                      context: context,
                      applicationName: _packageInfo.appName,
                      applicationVersion:
                          '${_packageInfo.version} (${_packageInfo.buildNumber})',
                      applicationIcon: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(24), // Image radius
                          child: Image.asset('assets/icon/icon.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                      applicationLegalese: 'GNU General Public License v3.0',
                    ),
                  ),
                  CupertinoButton(
                    child: const Text(FlutterI18n.translate(context, "aboutapp.disclaimer")),
                    onPressed: () => _launchURL(
                        'https://github.com/popoway/goknights#disclaimer'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 3
                  : 0,
              child: Align(
                // alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Made with ❤️ in Queens, NY',
                      style: TextStyle(
                          color: const CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.placeholderText,
                            darkColor: Color.fromARGB(100, 199, 199, 205),
                          ).resolveFrom(context),
                          fontSize: 10)),
                ), //Your widget here,
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}
