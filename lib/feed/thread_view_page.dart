import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../common/widgets/text_event.dart';
import 'cubits/thread_view/thread_view_cubit.dart';

class ThreadViewPage extends StatelessWidget {
  final String? eventId;

  const ThreadViewPage(this.eventId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (eventId == null || eventId!.isEmpty) {
      return Center(child: Text('Error'));
    }

    return BlocBuilder<ThreadViewCubit, ThreadViewState>(
      bloc: ThreadViewCubit(eventId!, RepositoryProvider.of(context)),
      builder: (context, state) {
        Widget child;
        if (state is ThreadViewInitial) {
          child =
              Center(child: SpinKitRipple(color: fluestrBlue200, size: 150));
        } else if (state is ThreadLoaded) {
          child = Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                final e = state.events.reversed.toList()[index];
                if (e.kind == 1) return Divider();
                return Container();
              },
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final e = state.events.reversed.toList()[index];
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
        } else {
          child = Center(child: Text('Unknown state: $state'));
        }

        return Scaffold(
          appBar: AppBar(title: Text('Thread')),
          body: child,
        );
      },
    );
  }
}
