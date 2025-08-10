import 'package:flutter/material.dart';

/// Settings page where users can adjust application preferences such as income
/// frequency, savings slider and notification options. Currently displays
/// placeholder toggles and selectors.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Einkommensfrequenz'),
            subtitle: const Text('Monatlich'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // TODO: implement frequency selection
            },
          ),
          SwitchListTile(
            title: const Text('Push‑Benachrichtigungen'),
            value: true,
            onChanged: (val) {
              // TODO: toggle push notifications
            },
          ),
          ListTile(
            title: const Text('Spar‑Schieberegler'),
            subtitle: Slider(
              value: 0.5,
              onChanged: (double value) {
                // TODO: update savings slider
              },
            ),
          ),
          ListTile(
            title: const Text('Sprache'),
            subtitle: const Text('Deutsch'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // TODO: implement language selection
            },
          ),
        ],
      ),
    );
  }
}