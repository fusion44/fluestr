import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../common/contacts_repository.dart';
import '../common/widgets/text_event.dart';
import '../contacts/blocs/contacts/contacts_bloc.dart';
import 'cubits/feed_list/feed_list_cubit.dart';
import 'widgets/widgets.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _searchPeerController = TextEditingController();
  late final FeedListCubit _bloc;
  bool _loadingTimeOver = false;

  @override
  void initState() {
    var contacts = RepositoryProvider.of<ContactsRepository>(context).contacts;
    _bloc = FeedListCubit(RepositoryProvider.of(context), contacts);

    BlocListener<FeedListCubit, FeedListState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is FeedListLoaded) _loadingTimeOver = true;
      },
    );

    _waitForData();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    _searchPeerController.dispose();
    await _bloc.dispose();
  }

  Future<void> _waitForData() async {
    // Even if the user does have contacts, we might never receive any text
    // notes from his contacts. We wait for two seconds under the assumption
    // that we'd have received something from a relay to show to the user.
    // If not we'll show a message to the user.
    await Future.delayed(Duration(seconds: 2));
    if (mounted && !_loadingTimeOver) setState(() => _loadingTimeOver = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _buildContactsBloc(context, theme);
  }

  Widget _buildContactsBloc(BuildContext context, ThemeData theme) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is ContactsInitial || state is ContactsListEmpty) {
          return _buildEventListEmptyWidget();
        }
        return _buildFeedBloc();
      },
    );
  }

  Widget _buildFeedBloc() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is FeedListInitial) {
          if (_loadingTimeOver) {
            return _buildEventListEmptyWidget();
          }
          return _buildLoadingUI();
        } else if (state is FeedListLoaded) {
          if (_loadingTimeOver && state.events.isEmpty) {
            return _buildEventListEmptyWidget();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                final e = state.events[index];
                if (e.kind == 1) return Divider();
                return Container();
              },
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final e = state.events[index];
                if (e.kind == 1) {
                  return TextEvent(
                    e,
                    onTap: (id) => context.push('/event/$id'),
                  );
                }
                return Container();
              },
            ),
          );
        }
        return Text('Unknown State $state');
      },
    );
  }

  Widget _buildLoadingUI() {
    return Center(child: SpinKitRipple(color: fluestrBlue200, size: 150));
  }

  Widget _buildEventListEmptyWidget() {
    return Center(child: FeedListEmpty());
  }
}
