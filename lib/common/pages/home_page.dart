import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../contacts/pages/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feed/feed_page.dart';
import '../../messages/messages_page.dart';
import '../../settings/settings_page.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final iconList = <IconData>[
    Icons.dynamic_feed,
    Icons.chat,
    Icons.contacts,
    Icons.settings,
  ];
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0;

  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_bottomNavIndex == 0) {
      child = FeedPage();
    } else if (_bottomNavIndex == 1) {
      child = MessagesPage();
    } else if (_bottomNavIndex == 2) {
      child = ContactsPage();
    } else {
      child = SettingsPage();
    }

    return Scaffold(
      body: SafeArea(child: child),
      floatingActionButton: _bottomNavIndex == 2
          ? FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () => context.pushNamed('search-contact'),
            )
          : null,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        backgroundColor: fluestrBackgroundCard,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
