import 'package:flutter/material.dart';

import '../../utils.dart';

class TrText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextOverflow overflow;
  final bool softWrap;
  final TextAlign textAlign;
  final bool selectable;

  const TrText(
    this.text, {
    Key key,
    this.style,
    this.overflow,
    this.softWrap,
    this.textAlign,
    this.selectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectable
        ? SelectableText(
            tr(context, text),
            style: style,
            textAlign: textAlign,
          )
        : Text(
            tr(context, text),
            style: style,
            overflow: overflow,
            softWrap: softWrap,
            textAlign: textAlign,
          );
  }
}
