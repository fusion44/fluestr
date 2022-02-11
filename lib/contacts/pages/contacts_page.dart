import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../common/constants.dart';
import '../../common/widgets/contact_list_item.dart';
import '../../common/widgets/widgets.dart';
import '../blocs/contacts/contacts_bloc.dart';

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
    final theme = Theme.of(context);
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is ContactsInitial) {
          return Center(child: SpinKitRipple(color: fluestrBlue200, size: 150));
        } else if (state is ContactsListEmpty) {
          return _buildContactListEmptyWidget(theme);
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

  Widget _buildContactListEmptyWidget(ThemeData theme) => Center(
        child: InkWell(
          onTap: () => widget.onTapContactEmptyWidget(),
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
        ),
      );
}
