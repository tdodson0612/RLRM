// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';

import '../services/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.celebration_outlined),
            title: const Text('Celebration effects'),
            subtitle: const Text(
              'Confetti and a buzz when you reach a new goal',
            ),
            value: state.celebrations,
            onChanged: state.setCelebrations,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.trending_up),
            title: Text('How goals work'),
            subtitle: Text(
              'Every exercise starts at a small goal. When you reach it, the goal goes up one step '
              '(+5 reps, or +5 seconds for timed exercises). '
              'Your real number is always saved, even if you beat the goal.',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.health_and_safety_outlined),
            title: Text('Stay safe'),
            subtitle: Text(
              'Pump Chump is not medical advice. Move with control, stop if something hurts, '
              'and check with a doctor first if you have a health concern.',
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            title: Text(
              'Reset all data',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: const Text('Deletes goals, history, and reminders'),
            onTap: () => _confirmReset(context, state),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('Pump Chump 1.0.0', style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, AppState state) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text(
          'This deletes your goals, personal bests, workout history, and reminders. '
          'It cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) await state.resetAll();
  }
}
