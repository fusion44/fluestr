import 'package:flutter/material.dart';

import 'tab.dart';
import 'tab_data.dart';

class FluestrManyTabBar extends StatefulWidget {
  final TabController controller;
  final List<TabData> tabs;

  const FluestrManyTabBar({
    Key key,
    @required this.tabs,
    @required this.controller,
  }) : super(key: key);

  @override
  _FluestrManyTabBarState createState() => _FluestrManyTabBarState();
}

class _FluestrManyTabBarState extends State<FluestrManyTabBar>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    widget.controller.addListener(() {
      setState(() {
        selectedIndex = widget.controller.index;
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = widget.tabs.map((data) {
      var selected = widget.tabs.indexOf(data) == selectedIndex;
      return FluestrManyTab(
        index: widget.tabs.indexOf(data),
        onTap: _onChangeTab,
        labelText: data.title,
        iconData: data.iconData,
        selected: selected,
        controller: widget.controller,
      );
    }).toList(growable: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: tabs,
    );
  }

  void _onChangeTab(int index) {
    widget.controller.animateTo(index);
    setState(() {
      selectedIndex = index;
    });
  }
}
