import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';

class FeedListEmpty extends StatelessWidget {
  const FeedListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.feed_rounded, size: 80, color: Colors.grey),
        SizedBox(height: 8.0),
        TrText(
          'feed.feed_list_empty1',
          style: theme.textTheme.headline5,
        ),
        TrText('feed.feed_list_empty2')
      ],
    );
  }
}
