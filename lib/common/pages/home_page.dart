import 'package:flutter/material.dart';

import '../../feed/feed_page.dart';
import '../../messages/messages_page.dart';
import '../../settings/settings_page.dart';
import '../constants.dart';
import '../widgets/tabbar/tab_bar.dart';

enum _FABState {
  transitionIn,
  transition,
  transitionOut,
  normal,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fluestrBackground,
        elevation: 0,
        titleSpacing: 0,
        title: _getTabBar(),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          FeedPage(),
          MessagesPage(),
          SettingsPage(),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _getTabBar() {
    var tabs = <TabData>[];
    tabs.add(TabData('Shitposts', Icons.dynamic_feed));
    tabs.add(TabData('Shitmessages', Icons.chat));
    tabs.add(TabData('Settings', Icons.settings));

    return FluestrManyTabBar(controller: _controller, tabs: tabs);
  }

  Widget _buildFAB() {
    return AnimatedBuilder(
      animation: _controller.animation,
      builder: (context, child) {
        var animState = _controller.animation.value;
        if (animState == 0) {
          return _buildFab(
            FeedPage.fabIcon,
            onPressed: () {
              FeedPage.fabCallback(context);
            },
          );
        } else if (animState > 0 && animState < 1) {
          if (_controller.animation.status == AnimationStatus.forward) {
            return Stack(
              children: <Widget>[
                _buildFab(FeedPage.fabIcon),
                _buildFab(
                  MessagesPage.fabIcon,
                  state: _FABState.transition,
                  animState: animState,
                ),
              ],
            );
          } else if (_controller.animation.status == AnimationStatus.reverse) {
            return Stack(
              children: <Widget>[
                _buildFab(FeedPage.fabIcon),
                _buildFab(
                  MessagesPage.fabIcon,
                  state: _FABState.transition,
                  animState: animState,
                ),
              ],
            );
          }
        } else if (animState == 1) {
          return _buildFab(
            MessagesPage.fabIcon,
            onPressed: () {
              MessagesPage.fabCallback(context);
            },
          );
        } else if (animState > 1 && animState < 2) {
          var state = 1 - (animState - 1);
          return _buildFab(
            MessagesPage.fabIcon,
            state: _FABState.transitionIn,
            animState: state,
          );
        }
        return Container();
      },
    );
  }

  Widget _buildFab(
    Widget icon, {
    _FABState state = _FABState.normal,
    double animState,
    Function onPressed,
  }) {
    switch (state) {
      case _FABState.transitionIn:
      case _FABState.transitionOut:
        return Transform.scale(
          scale: animState,
          child: Opacity(
            opacity: animState,
            child: FloatingActionButton(
              child: icon,
              onPressed: onPressed,
            ),
          ),
        );
      case _FABState.transition:
        return Opacity(
          opacity: animState,
          child: FloatingActionButton(
            onPressed: onPressed,
            child: icon,
          ),
        );
      case _FABState.normal:
        return FloatingActionButton(
          child: icon,
          onPressed: onPressed,
        );
      default:
        return Container();
    }
  }
}
