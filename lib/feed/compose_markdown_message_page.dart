import 'dart:convert';

import '../common/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../common/relay_repository.dart';
import 'markdown/markdown_editor.dart';
import 'markdown/markdown_preview.dart';
import 'markdown/text_editor.dart';

class ComposeMarkdownMessagePage extends StatefulWidget {
  const ComposeMarkdownMessagePage({Key? key}) : super(key: key);

  @override
  _ComposeMarkdownMessagePageState createState() =>
      _ComposeMarkdownMessagePageState();
}

class _ComposeMarkdownMessagePageState
    extends State<ComposeMarkdownMessagePage> {
  bool _inPreview = false;
  bool _isMarkdown = true;
  bool _textIsEmpty = true;
  String _currentText = '';
  late final RelayRepository _relayRepo;

  @override
  void initState() {
    _relayRepo = RepositoryProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isMarkdown
            ? _inPreview
                ? Text('compose_message.markdown_preview_short',
                    overflow: TextOverflow.ellipsis)
                : Text('compose_message.markdown_message_short',
                    overflow: TextOverflow.ellipsis)
            : Text('compose_message.text_message_short',
                overflow: TextOverflow.ellipsis),
        actions: [
          if (_isMarkdown)
            IconButton(
              onPressed: () => setState(() => _inPreview = !_inPreview),
              icon: Icon(
                Icons.preview,
                color: _inPreview ? Colors.red : null,
              ),
            ),
          if (!_inPreview)
            IconButton(
              onPressed: () => setState(() => _isMarkdown = !_isMarkdown),
              icon: _isMarkdown
                  ? Icon(MdiIcons.languageMarkdown)
                  : Icon(MdiIcons.text),
            ),
        ],
      ),
      floatingActionButton: _textIsEmpty
          ? null
          : FloatingActionButton(
              child: Icon(Icons.send),
              onPressed: _sendMessage,
            ),
      body: _inPreview
          ? MarkdownPreview(_currentText)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: _isMarkdown
                      ? MarkdownField(text: _currentText, onChanged: _onChanged)
                      : TextEditor(text: _currentText, onChanged: _onChanged)),
            ),
    );
  }

  Future<void> _sendMessage() async {
    final box = await Hive.openBox(prefBoxNameSettings);
    final evt = await Event.kind1(box.get(prefCredentials), _currentText);

    // TODO: find bug where verification goes wrong
    _relayRepo.trySendRaw(
      jsonEncode(['EVENT', evt.toMap()]),
    );

    context.pop();
  }

  void _onChanged(String value) {
    if (value.isEmpty) setState(() => _textIsEmpty = true);
    if (value.isNotEmpty && value.length == 1 && _textIsEmpty) {
      setState(() => _textIsEmpty = false);
    }

    _currentText = value;
  }
}
