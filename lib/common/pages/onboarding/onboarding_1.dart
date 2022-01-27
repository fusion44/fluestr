import 'package:flutter/material.dart';

import '../../models/credentials.dart';
import '../../widgets/widgets.dart';

class OnboardingPage1 extends StatefulWidget {
  final Credentials credentials;
  final Function() onFinish;

  const OnboardingPage1(this.credentials, {Key? key, required this.onFinish})
      : super(key: key);

  @override
  _OnboardingPage1State createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1> {
  bool _privKeyOnly = false;

  @override
  void initState() {
    if (widget.credentials.mnemonic.isEmpty) {
      _privKeyOnly = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        if (!_privKeyOnly)
          _buildHeaderRow(
            theme,
            'onboarding.your_mnemonic_help_text',
            Icons.edit,
          ),
        if (!_privKeyOnly)
          SelectableText(
            widget.credentials.mnemonic,
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        SizedBox(height: 8.0),
        _buildHeaderRow(
          theme,
          'onboarding.your_private_key_help_text',
          Icons.security_rounded,
        ),
        SelectableText(widget.credentials.privKey),
        SizedBox(height: 8.0),
        _buildHeaderRow(
          theme,
          'onboarding.your_public_key_help_text',
          Icons.public_sharp,
        ),
        SelectableText(widget.credentials.pubKey),
        SizedBox(height: 8.0),
        TrText(
          'onboarding.reminder_make_sure_to_write_down_seed',
          style: theme.textTheme.headline6!
              .copyWith(color: Colors.redAccent, fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.0),
        ElevatedButton(
          onPressed: widget.onFinish,
          child: TrText('onboarding.next_step'),
        )
      ],
    );
  }

  Widget _buildHeaderRow(ThemeData theme, String textId, [IconData? icon]) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(width: 8),
          TrText(textId, style: theme.textTheme.headline6),
        ],
      ),
    );
  }
}
