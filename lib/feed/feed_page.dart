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
      leading: CircleAvatar(
        backgroundColor: fluestrBlue200,
        child: Icon(Icons.person),
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
