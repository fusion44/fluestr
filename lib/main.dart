import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common/constants.dart';
import 'common/models/credentials.dart';
import 'common/models/relay.dart';
import 'common/pages/edit_relays_page.dart';
import 'common/pages/home_page.dart';
import 'common/pages/onboarding.dart';
import 'common/pages/splash_page.dart';
import 'common/contacts_repository.dart';
import 'common/relay_repository.dart';
import 'contacts/blocs/contacts/contacts_bloc.dart';
import 'contacts/pages/search_contact_page.dart';

late final RelayRepository _relayRepo;
late final ContactsRepository _contactsRepo;
late final ContactsBloc _contactsBloc;

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
        builder: (context, state) => RepositoryProvider.value(
          value: _relayRepo,
          child: BlocProvider.value(
            value: _contactsBloc,
            child: HomePage(),
          ),
        ),
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
      GoRoute(
        path: '/relays',
        name: 'relays',
        builder: (context, state) => RepositoryProvider.value(
          value: _relayRepo,
          child: EditRelaysPage(),
        ),
      ),
      GoRoute(
        path: '/search-contact',
        name: 'search-contact',
        builder: (context, state) => RepositoryProvider.value(
          value: _relayRepo,
          child: SearchContactPage(),
        ),
      )
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(state.error.toString()))),
  );

  await _initRepo(box);

  runApp(MyApp(_router));
}

Future<void> _initRepo(Box box) async {
  _relayRepo = RelayRepository();
  await _relayRepo.init();

  _contactsRepo = ContactsRepository(_relayRepo);
  _contactsBloc = ContactsBloc(_contactsRepo);
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
        if (deviceLocale != null) return _checkLocaleSetting(deviceLocale);
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
  Hive.registerAdapter(RelayAdapter());
}
