import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/widgets.dart';

class ContactListEmpty extends StatelessWidget {
  final Function? onTap;

  const ContactListEmpty({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () =>
          onTap != null ? onTap!() : context.pushNamed('search-contact'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 8.0),
          TrText(
            'contacts.contact_list_empty',
            style: theme.textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
