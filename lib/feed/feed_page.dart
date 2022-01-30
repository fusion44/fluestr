import '../contacts/blocs/contacts/contacts_bloc.dart';
import '../contacts/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../common/constants.dart';
import '../common/models/event.dart';
import 'feed_list_bloc/feed_list_bloc.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _searchPeerController = TextEditingController();
  late final FeedListBloc _bloc;
  @override
  void initState() {
    _bloc = FeedListBloc(RepositoryProvider.of(context));
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    _searchPeerController.dispose();
    await _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is FeedListInitial) {
          return _buildLoadingUI();
        } else if (state is FeedListLoaded) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              // TODO: improve the FeedListBloc to avoid this inefficiency
              final e = state.events.reversed.toList()[index];
              if (e.kind == 1) return Divider();
              return Container();
            },
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              // TODO: improve the FeedListBloc to avoid this inefficiency
              final e = state.events.reversed.toList()[index];
              if (e.kind == 1) return _buildPostTile(e, theme);
              return Container();
            },
          );
        }
        return Text('Unknown State $state');
      },
    );
  }

  Widget _buildLoadingUI() {
    return Center(child: SpinKitRipple(color: fluestrBlue200, size: 150));
  }

  Widget _buildPostTile(Event e, ThemeData theme) {
    return ListTile(
      leading: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsUpdate &&
              state.contacts.keys.contains(e.pubkey)) {
            final p = state.contacts[e.pubkey]!;
            if (p.profile.picture.isNotEmpty) {
              return ProfileAvatar(url: p.profile.picture);
            } else if (p.profile.name.isNotEmpty) {
              return ProfileAvatar(name: p.profile.name);
            }
          }
          return ProfileAvatar(name: e.pubkey);
        },
      ),
      dense: false,
      title: Stack(
        children: [
          Text(
            e.pubkey.replaceRange(3, e.pubkey.length - 4, '...'),
            style: theme.textTheme.caption,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 4.0),
            child: Text(e.content),
          ),
        ],
      ),
      subtitle: Text(timeago.format(e.createdAtDt)),
    );
  }
}
