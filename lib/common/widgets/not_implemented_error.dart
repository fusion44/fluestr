import 'package:flutter/material.dart';

import 'widgets.dart';

class NotImplementedError extends StatelessWidget {
  const NotImplementedError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.handyman_sharp, size: 80, color: Colors.grey),
          SizedBox(height: 8.0),
          TrText('not_implemented_yet', style: theme.textTheme.headline5),
        ],
      ),
    );
  }
}
