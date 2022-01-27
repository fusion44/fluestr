import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class OnboardingPage2 extends StatefulWidget {
  final Function()? onFinish;

  const OnboardingPage2({Key? key, this.onFinish}) : super(key: key);

  @override
  _OnboardingPage2State createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onFinish,
      child: TrText('onboarding.finish'),
    );
  }
}
