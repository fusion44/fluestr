import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../pedantic.dart';
import '../constants.dart';
import '../models/credentials.dart';
import 'onboarding/onboarding_0.dart';
import 'onboarding/onboarding_1.dart';
import 'onboarding/onboarding_2.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;
  Box _box;
  Credentials _credentials;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  void _openBox() async {
    _box = await Hive.openBox(prefBoxNameSettings);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 750),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              Icon(Icons.account_balance_outlined, size: 96),
              Text(
                'FLUESTR',
                textAlign: TextAlign.center,
                style: theme.textTheme.headline2,
              ),
              SizedBox(height: 40),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentStep == 0) {
      return OnboardingPage0(onFinish: _step0Results);
    } else if (_currentStep == 1) {
      return OnboardingPage1(
        _credentials,
        onFinish: _step1Results,
      );
    } else if (_currentStep == 2) {
      return OnboardingPage2(onFinish: _step2Results);
    } else {
      return Center(child: Text('Unknown step $_currentStep'));
    }
  }

  void _step0Results(Credentials creds) {
    _box.put(prefCredentials, creds);

    setState(() {
      _credentials = creds;
      _currentStep = 1;
    });
  }

  void _step1Results() {
    setState(() {
      _currentStep = 2;
    });
  }

  void _step2Results() {
    _box.put(prefOnboardingFinished, true);
    unawaited(Get.offAndToNamed(routeSplash));
  }
}
