import '../../common/widgets/contact_list_item.dart';

import '../blocs/contacts/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is ContactsUpdate) {
          return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, i) =>
                  ContactListItem(state.contacts.values.elementAt(i)));
        }
        return Container();
      },
    );
  }
}
