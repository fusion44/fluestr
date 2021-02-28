import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common/constants.dart';
import 'common/models/credentials.dart';
import 'common/pages/home_page.dart';
import 'common/pages/onboarding.dart';
import 'common/pages/splash_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  _registerHiveAdapters();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var delegates = _buildLocalizationDelegates();
    return GetMaterialApp(
      theme: ThemeData.dark(),
      initialRoute: routeSplash,
      getPages: [
        GetPage(name: routeSplash, page: () => SplashPage()),
        GetPage(name: routeOnboarding, page: () => OnboardingPage()),
        GetPage(name: routeHome, page: () => HomePage()),
      ],
      localizationsDelegates: delegates,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return _checkLocaleSetting(deviceLocale);
      },
    );
  }

  Locale _checkLocaleSetting(Locale deviceLocale) {
    // get  langCode from Settings Hive Box
    var langCode = 'en';
    if (langCode == null) {
      return deviceLocale;
    } else {
      return Locale(langCode);
    }
  }

  List<LocalizationsDelegate<dynamic>> _buildLocalizationDelegates() {
    var delegates = <LocalizationsDelegate<dynamic>>[];

    delegates.addAll([
      FlutterI18nDelegate(
        translationLoader: FileTranslationLoader(
          useCountryCode: false,
          fallbackFile: 'en',
          basePath: 'assets/i18n',
        ),
      ),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ]);
    return delegates;
  }
}

void _registerHiveAdapters() {
  Hive.registerAdapter(CredentialsAdapter());
}
