import 'package:flutter/material.dart';

class MarkdownField extends StatelessWidget {
  late final TextEditingController _controller;
  final int? maxLines;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final bool autofocus;

  MarkdownField({
    String? text,
    this.onChanged,
    this.autofocus = true,
    this.maxLines,
    this.textInputAction = TextInputAction.newline,
    Key? key,
  }) : super(key: key) {
    _controller = TextEditingController(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: autofocus,
      textInputAction: textInputAction,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }
}
