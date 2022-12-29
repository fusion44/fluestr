import 'package:fluestr/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await FlutterI18n.refresh(context, Locale('en'));
    });

    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    final pref = await getPreferences();

    if (pref.onboardingFinished) {
      context.goNamed('home');
      return;
    }

    if (!pref.currentlyOnboarding) {
      await setPreferences(pref.copyWith(currentlyOnboarding: true));
      context.goNamed('onboarding');
      return;
    }

    if (pref.currentlyOnboarding) {
      context.goNamed('onboarding');
      return;
    }

    throw StateError('Invalid state when determining startup state!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Text('FLUESTR'),
        ),
      ),
    );
  }
}
