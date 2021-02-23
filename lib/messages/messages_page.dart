import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../common/constants.dart';

class MessagesPage extends StatefulWidget {
  static final Widget fabIcon = Icon(Icons.add);
  static final Function fabCallback = (
    context,
  ) async {};

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoadingUI();
  }

  Widget _buildLoadingUI() {
    return Center(child: SpinKitRipple(color: fluestrBlue200, size: 150));
  }
}
