import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

// source: https://github.com/flutter/flutter/issues/81725#issuecomment-1013930010
class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      var lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return SizedBox(
      width:
          MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width,
      child: HighlightView(
        element.textContent,
        language: language,
        theme: atomOneDarkTheme,
        padding: const EdgeInsets.all(8),
        textStyle: TextStyle(fontFamily: 'RobotoMono'),
      ),
    );
  }
}
