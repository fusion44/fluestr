import 'package:fluestr/common/models/contact.dart';
import 'package:fluestr/common/models/preferences.dart';
import 'package:fluestr/common/models/relay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

import 'common/contacts_repository.dart';
import 'common/pages/home_page.dart';
import 'common/pages/onboarding.dart';
import 'common/pages/splash_page.dart';
import 'common/relay_repository.dart';
import 'contacts/blocs/contacts/contacts_bloc.dart';
import 'contacts/pages/search_contact_page.dart';
import 'feed/compose_markdown_message_page.dart';
import 'feed/thread_view_page.dart';
import 'settings/edit_relays_page.dart';

late final RelayRepository _relayRepo;
late final ContactsRepository _contactsRepo;
late final ContactsBloc _contactsBloc;

const dbPath = '/home/f44/dev/stuff/nostr/fluestr';
const defaultSchemas = [PreferencesSchema, ContactSchema, RelaySchema];

Future<void> main() async {
  await Isar.open(defaultSchemas, directory: dbPath);

  final _router = GoRouter(
    redirect: (state) {
      if (state.location == '/splash') return null;
      return null;
    },
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: _contactsRepo),
            RepositoryProvider.value(value: _relayRepo),
          ],
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
        builder: (context, state) => BlocProvider(
          create: (context) => _contactsBloc,
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: _contactsRepo),
              RepositoryProvider.value(value: _relayRepo),
            ],
            child: SearchContactPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/compose-message',
        name: 'compose-message',
        builder: (context, state) => BlocProvider.value(
          value: _contactsBloc,
          child: RepositoryProvider.value(
            value: _relayRepo,
            child: ComposeMarkdownMessagePage(),
          ),
        ),
      ),
      GoRoute(
        path: '/event/:event_id',
        name: 'event',
        builder: (context, state) => BlocProvider.value(
          value: _contactsBloc,
          child: RepositoryProvider.value(
            value: _relayRepo,
            child: ThreadViewPage(state.params['event_id']),
          ),
        ),
      )
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(state.error.toString()))),
  );

  await _initRepo();

  runApp(MyApp(_router));
}

Future<void> _initRepo() async {
  _relayRepo = RelayRepository();
  await _relayRepo.init();
  _contactsRepo = ContactsRepository(_relayRepo);
  await _contactsRepo.init();
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
        if (deviceLocale != null) return deviceLocale;
        return null;
      },
    );
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
