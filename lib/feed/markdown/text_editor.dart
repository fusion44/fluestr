import 'package:flutter/material.dart';

class TextEditor extends StatelessWidget {
  final bool autofocus;
  final int? maxLines;
  late final TextEditingController _controller;
  late final Function(String)? onChanged;

  TextEditor({
    Key? key,
    String? text,
    this.onChanged,
    this.maxLines,
    this.autofocus = true,
  }) : super(key: key) {
    _controller = TextEditingController(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: maxLines,
      onChanged: onChanged,
      autofocus: autofocus,
    );
  }
}
