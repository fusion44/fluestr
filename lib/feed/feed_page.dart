import '../common/widgets/text_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../common/constants.dart';
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
              if (e.kind == 1) return TextEvent(e);
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
}
