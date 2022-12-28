import 'package:fluestr/common/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../common/widgets/contact_list_item.dart';
import '../../common/widgets/text_event.dart';
import '../../common/widgets/widgets.dart';
import '../../utils.dart';
import '../blocs/edit_contact/edit_contact_bloc.dart';
import '../blocs/search_contact/search_contact_bloc.dart';

class SearchContactPage extends StatefulWidget {
  const SearchContactPage({Key? key}) : super(key: key);

  @override
  _SearchContactPageState createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage>
    with SingleTickerProviderStateMixin {
  late final SearchContactBloc _bloc;
  final _searchController = TextEditingController();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _bloc = SearchContactBloc(
      RepositoryProvider.of(context),
      RepositoryProvider.of(context),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    _tabController.dispose();
    await _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SearchContactBloc, SearchContactState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: TrText('contacts.search_contacts_title')),
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: _buildBody(theme, state, context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ThemeData theme, SearchContactState state, context) {
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
    }

    if (state is SearchingContactState) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is ContactInfoFoundState) {
      final c = state.contact;
      return Container(
        constraints: BoxConstraints(maxWidth: defaultMaxMainColumnWidth),
        child: Column(
          children: [
            BlocProvider(
              create: (context) =>
                  EditContactBloc(RepositoryProvider.of(context), c),
              child: DisplayContactHeader(contact: c),
            ),
            ..._buildTabBar(theme, state),
          ],
        ),
      );
    } else if (state is ContactInfoNotFoundState) {
      return Center(child: TrText('contacts.search_no_contact_found'));
    } else if (state is FindContactInfoErrorState) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 24),
            Icon(Icons.error, size: 48),
            SizedBox(height: 8),
            Text(state.error),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _bloc.add(
                SearchContactByPubKey(_searchController.text),
              ),
              child: TrText('contacts.retry_search'),
            ),
          ],
        ),
      );
    }

    return Center(child: Text('Unknown state: $state'));
  }

  List<Widget> _buildTabBar(ThemeData theme, ContactInfoFoundState state) {
    final c = state.contact;
    final cRes = state.contactResult;
    final tRes = state.textResult;
    final events = state.textResult.result;

    if (events.isEmpty && state.fetchingEvents) {
      return [
        Text(
          'Found the contact, fetching events...',
          style: theme.textTheme.headline6,
        ),
        SizedBox(height: 8),
        CircularProgressIndicator(),
      ];
    }
    if (events.isEmpty && !state.fetchingEvents) {
      return [TrText('contacts.search_no_posts_found')];
    }
    if (events.isNotEmpty) {
      return [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: tr(context, 'recent_posts')),
            Tab(text: tr(context, 'contacts.recommended_relays')),
            Tab(text: tr(context, 'query_info'))
          ],
        ),
        SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.separated(
                itemCount: events.length,
                itemBuilder: (context, index) =>
                    TextEvent(events[index], contact: c),
                separatorBuilder: (context, index) => Divider(),
              ),
              ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Relay $index'),
                  );
                },
              ),
              ListView.builder(
                itemCount: 4,
                itemBuilder: ((context, index) =>
                    _buildQueryInfoItem(index, theme, cRes, tRes)),
              ),
            ],
          ),
        ),
      ];
    }

    return [Text('Unknown state: $state')];
  }

  Widget _buildQueryInfoItem(int index, theme, cRes, tRes) {
    final style = theme.textTheme.headline5;
    if (index == 0) return Text('Some debug info:', style: style);
    if (index == 1) return Text('Contact res: ${jsonify(cRes.toJson(), true)}');
    if (index == 2) return Divider();
    if (index == 3) return Text('Text res: ${jsonify(tRes.toJson(), true)}');

    return Text('Unknown index $index');
  }
}

class DisplayContactHeader extends StatelessWidget {
  const DisplayContactHeader({Key? key, required this.contact})
      : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TrText(
              'contacts.search_display_profile_header',
              style: theme.textTheme.headline5,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildFollowButton(context),
            ),
          ],
        ),
        ContactListItem(contact),
      ],
    );
  }

  Widget _buildFollowButton(BuildContext c) {
    return BlocBuilder<EditContactBloc, EditContactState>(
      builder: (context, state) {
        if (state is EditContactUpdate) {
          return AnimatedButton(
            height: 32,
            width: 170,
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
            borderRadius: 20,
            backgroundColor: Colors.white,
            selectedBackgroundColor: Colors.black,
            selectedTextColor: Colors.white,
            borderColor: Colors.blueGrey,
            isSelected: state.contact.following,
            text: state.contact.following
                ? tr(c, 'contacts.unfollow').toUpperCase()
                : tr(c, 'contacts.follow').toUpperCase(),
            onPress: () {
              final bloc = BlocProvider.of<EditContactBloc>(c);
              bloc.add(ToggleFollowStatus());
            },
          );
        }

        return Center(child: Text('Unknown state: $state'));
      },
    );
  }
}
