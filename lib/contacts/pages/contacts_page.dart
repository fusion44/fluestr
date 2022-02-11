import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../common/constants.dart';
import '../../common/widgets/contact_list_item.dart';
import '../blocs/contacts/contacts_bloc.dart';
import '../widgets/widgets.dart';

class ContactsPage extends StatefulWidget {
  final Function onTapContactEmptyWidget;

  const ContactsPage(this.onTapContactEmptyWidget, {Key? key})
      : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is ContactsInitial) {
          return Center(child: SpinKitRipple(color: fluestrBlue200, size: 150));
        } else if (state is ContactsListEmpty) {
          return Center(
            child: ContactListEmpty(onTap: widget.onTapContactEmptyWidget),
          );
        } else if (state is ContactsUpdate) {
          return ListView.builder(
            itemCount: state.contacts.length,
            itemBuilder: (context, i) => ContactListItem(
              state.contacts.values.elementAt(i),
            ),
          );
        } else {
          return Center(child: Text('Unknown state: $state'));
        }
      },
    );
  }
}
