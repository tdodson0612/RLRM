// lib/features/settings/settings_screen.dart

import 'package:flutter/material.dart';

import '../../core/legal/legal_text.dart';
import '../../core/widgets/app_card.dart';
import 'about_screen.dart';

/// Settings hub. Profile, controller bindings and the theme toggle join it in
/// later stages.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('About & legal'),
                  subtitle: const Text('Unofficial-project notice and privacy'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AboutScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Open-source licenses'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: LegalText.appName,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}