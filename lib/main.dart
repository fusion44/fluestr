import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
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

  final box = await Hive.openBox(prefBoxNameSettings);

  final _router = GoRouter(
    redirect: (state) {
      if (state.location == '/splash') return null;

      final onBoardingFinished = box.get(
        prefOnboardingFinished,
        defaultValue: false,
      );

      if (!onBoardingFinished) {
        final currentlyOnboarding = box.get(
          prefCurrentlyOnboarding,
          defaultValue: false,
        );
        if (!currentlyOnboarding) return '/onboarding';
      }
      return null;
    },
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) {
          return Scaffold(body: OnboardingPage());
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(state.error.toString()))),
  );

  runApp(MyApp(_router));
}

class MyApp extends StatelessWidget {
  final GoRouter _router;

  MyApp(this._router);

  @override
  Widget build(BuildContext context) {
    var delegates = _buildLocalizationDelegates();
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      theme: ThemeData.dark(),
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
