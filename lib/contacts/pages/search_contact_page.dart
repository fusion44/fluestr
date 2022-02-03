import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/contact_list_item.dart';
import '../../common/widgets/text_event.dart';
import '../../common/widgets/widgets.dart';
import '../blocs/contacts/contacts_bloc.dart';
import '../blocs/search_contact/search_contact_bloc.dart';

class SearchContactPage extends StatefulWidget {
  const SearchContactPage({Key? key}) : super(key: key);

  @override
  _SearchContactPageState createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  late final SearchContactBloc _bloc;
  final _searchController = TextEditingController();

  @override
  void initState() {
    _bloc = SearchContactBloc(RepositoryProvider.of(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SearchContactBloc, SearchContactState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: TrText('contacts.search_contacts_title')),
          floatingActionButton: state is ContactInfoFoundState
              ? FloatingActionButton(
                  onPressed: () {
                    final bloc = BlocProvider.of<ContactsBloc>(context);
                    bloc.add(FollowContact(state.contact));
                    context.pop();
                  },
                  child: Icon(Icons.person_add),
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: _buildBody(theme, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(ThemeData theme, SearchContactState state) {
    if (state is SearchContactInitial) {
      return Column(
        children: [
          TextField(controller: _searchController),
          SizedBox(height: 8.0),
          ElevatedButton.icon(
            onPressed: () {
              _bloc.add(SearchContactByPubKey(_searchController.text));
            },
            icon: Icon(Icons.search),
            label: TrText('contacts.search_action'),
          ),
        ],
      );
    } else if (state is ContactInfoFoundState) {
      return Column(children: [
        TrText(
          'contacts.search_display_profile_header',
          style: theme.textTheme.headline5,
        ),
        ContactListItem(state.contact),
        TrText(
          'contacts.search_preview_posts',
          style: theme.textTheme.headline5,
        ),
        SizedBox(height: 8),
        ...[
          for (final e in state.events) ...[
            TextEvent(e, contact: state.contact),
            Divider()
          ]
        ],
      ]);
    } else {
      return Center(child: Text('Unknown state: $state'));
    }
  }
}
