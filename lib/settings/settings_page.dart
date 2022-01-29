import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
                onPressed: (context) =>
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Not implemented :(')),
                ),
              ),
              SettingsTile.switchTile(
                onToggle: (value) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Not implemented :(')),
                ),
                initialValue: false,
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Mode'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Relays'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.link),
                title: Text('Active Relays'),
                value: Text('x active'),
                onPressed: (context) => context.pushNamed('relays'),
              )
            ],
          )
        ],
      ),
    );
  }
}
