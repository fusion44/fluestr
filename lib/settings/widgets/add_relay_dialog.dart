import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';

class AddRelayDialog extends StatefulWidget {
  @override
  _AddRelayDialogState createState() => _AddRelayDialogState();
}

class _AddRelayDialogState extends State<AddRelayDialog> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomAlertDialog(
      content: Container(
        color: Theme.of(context).dialogBackgroundColor,
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 2,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TrText(
                'alert_dialog.websocket_url',
                style: theme.textTheme.caption,
              ),
              TextField(controller: _urlController),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, _urlController.text),
                child: TrText('alert_dialog.add'),
              ),
              TextButton(
                onPressed: () => _urlController.text = '',
                child: TrText('alert_dialog.clear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
