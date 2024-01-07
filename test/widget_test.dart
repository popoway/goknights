// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goknights/onboarding.dart';

void main() {
  group('UI TESTS', () {
    Widget makeTesteableWidget({required Widget child}) {
      return CupertinoApp(
          title: 'GoKnights',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(
                  useCountryCode: false,
                  fallbackFile: 'en',
                  basePath: 'assets/flutter_i18n'),
              missingTranslationHandler: (key, locale) {
                print(
                    "--- Missing Key: $key, languageCode: ${locale?.languageCode}");
              },
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('es'), // Spanish
            Locale('zh'), // Chinese
            Locale('he'), // Hebrew
            // Locale('it'), // Italian
            // Locale('ru'), // Russian
          ],
          localeListResolutionCallback: (allLocales, supportedLocales) {
            final locale = allLocales?.first.languageCode;
            if (locale == 'en') {
              return const Locale('en', 'US');
            }
            if (locale == 'es') {
              return const Locale('es', 'ES');
            }
            if (locale == 'zh') {
              return const Locale('zh', 'CN');
            }
            if (locale == 'he') {
              return const Locale('he', 'IL');
            }
            // The default locale
            return const Locale('en', 'US');
          },
          builder: FlutterI18n.rootAppBuilder(),
          home: child);
    }

    testWidgets('Onboarding page', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const OnboardingPage(),
      );

      await tester.pumpWidget(widget);
    });
  });
}
