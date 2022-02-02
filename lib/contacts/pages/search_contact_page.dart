import 'package:fluestr/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/widgets/contact_list_item.dart';
import '../../common/widgets/text_event.dart';
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
    return Scaffold(
      appBar: AppBar(title: TrText('contacts.search_contacts_title')),
      body: BlocBuilder<SearchContactBloc, SearchContactState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is SearchContactInitial) {
            return Column(
              children: [
                TextField(controller: _searchController),
                ElevatedButton.icon(
                  onPressed: () {
                    _bloc.add(SearchContactByPubKey(_searchController.text));
                  },
                  icon: Icon(Icons.search),
                  label: TrText('contacts.search_action'),
                ),
                SizedBox(height: 16),
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
        },
      ),
    );
  }
}
