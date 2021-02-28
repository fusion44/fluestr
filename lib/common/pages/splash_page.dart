import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../pedantic.dart';
import '../constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // var prefs = await SharedPreferences.getInstance();
      // var code = prefs.getString('EN');
      // await FlutterI18n.refresh(context, Locale(code == null ?? 'en'));
      await FlutterI18n.refresh(context, Locale('en'));
    });

    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    final box = await Hive.openBox(prefBoxNameSettings);
    final onBoardingFinished = box.get(
      prefOnboardingFinished,
      defaultValue: false,
    );
    if (onBoardingFinished) {
      unawaited(Get.offAndToNamed(routeHome));
    } else {
      unawaited(Get.offAndToNamed(routeOnboarding));
    }
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
