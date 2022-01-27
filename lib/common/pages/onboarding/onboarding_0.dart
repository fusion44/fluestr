import 'dart:async';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip340/bip340.dart' as bip340;
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart' as hex;

import '../../../utils.dart';
import '../../models/credentials.dart';
import '../../widgets/widgets.dart';

class OnboardingPage0 extends StatefulWidget {
  final Function(Credentials) onFinish;

  const OnboardingPage0({Key? key, required this.onFinish}) : super(key: key);

  @override
  _OnboardingPage0State createState() => _OnboardingPage0State();
}

class _OnboardingPage0State extends State<OnboardingPage0> {
  final _inputCtrl = TextEditingController();
  bool _keyInputValid = false;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _inputCtrl.addListener(() {
      _checkSeedInput();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Column(children: [
        Center(
          child: TrText(
            'onboarding.welcome_message',
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
            selectable: true,
          ),
        ),
        _buildInputStack(),
        SizedBox(height: 24.0),
        _buildControlRowStep0(),
      ]),
    );
  }

  Row _buildControlRowStep0() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _showClearButton
              ? () {
                  setState(() {
                    _inputCtrl.clear();
                    _keyInputValid = false;
                  });
                }
              : () async {
                  final clipboardData = await Clipboard.getData('text/plain');
                  if (clipboardData != null && clipboardData.text != null) {
                    _inputCtrl.text = clipboardData.text!.replaceAll('\n', '');
                  }
                },
          icon: Icon(Icons.paste),
          label: _showClearButton
              ? TrText('alert_dialog.clear')
              : TrText('paste_from_clipboard'),
        ),
        SizedBox(width: 8.0),
        _keyInputValid
            ? ElevatedButton.icon(
                onPressed: () => _onNextClick(),
                icon: Icon(Icons.refresh_outlined),
                label: TrText('onboarding.next_step'),
              )
            : ElevatedButton.icon(
                onPressed: () => _inputCtrl.text = bip39.generateMnemonic(),
                icon: Icon(Icons.refresh_outlined),
                label: TrText('onboarding.generate_seed'),
              )
      ],
    );
  }

  Widget _buildInputStack() {
    return Stack(
      alignment: Alignment.center,
      children: [
        TextField(
          controller: _inputCtrl,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: tr(
              context,
              'onboarding.help_text_enter_mnemonic_or_seed',
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _keyInputValid
                ? Icon(Icons.check, color: Colors.greenAccent)
                : Icon(Icons.close, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  void _checkSeedInput() {
    final t = _inputCtrl.text;
    if (t.isEmpty) {
      // decide whether to show clear or paste button
      setState(() {
        _showClearButton = false;
      });
      return;
    } else {
      if (t.length == 64 && !t.contains(' ')) {
        // private key
        _keyInputValid = true;
      } else {
        final spl = t.split(' ');
        if (spl.length == 12) {
          _keyInputValid = bip39.validateMnemonic(t);
        }
      }

      setState(() {
        _showClearButton = true;
      });
    }
  }

  void _onNextClick() async {
    if (_inputCtrl.text.contains(' ')) {
      widget.onFinish(await _genKeysFromMnemonic());
    } else {
      final pubKey = bip340.getPublicKey(_inputCtrl.text);
      widget.onFinish(Credentials('', _inputCtrl.text, pubKey));
    }
  }

  FutureOr<Credentials> _genKeysFromMnemonic() async {
    final seed = bip39.mnemonicToSeed(_inputCtrl.text);
    final root = bip32.BIP32.fromSeed(seed);
    final privKey = hex.HEX.encode(root.privateKey!.toList());
    final pubKey = bip340.getPublicKey(privKey);
    return Credentials(_inputCtrl.text, privKey, pubKey);
  }
}
