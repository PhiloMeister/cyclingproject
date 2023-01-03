import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../theme/constants.dart';
import '../utils/snackbar.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(color: kTextColor),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SettingsList(
            sections: [
              SettingsSection(
                title: const Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    onPressed: (value) {
                      Utils.showSnackBar("English");
                    },
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    value: const Text('English'),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      Utils.showSnackBar("Test");
                    },
                    initialValue: true,
                    leading: const Icon(Icons.format_paint),
                    title: const Text('Enable custom theme'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Notification'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    value: const Text('English'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
