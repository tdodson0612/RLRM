// lib/screens/schedule_screen.dart

import 'package:flutter/material.dart';

import '../data/weekly_plan.dart';
import '../models/reminder_settings.dart';
import '../services/app_state.dart';
import '../services/formatters.dart';

/// Pick your workout time, which days to be reminded, and the message.
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final reminder = state.reminder;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('SCHEDULE')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SwitchListTile(
            title: const Text('Workout reminders'),
            subtitle: Text(reminder.enabled ? 'On' : 'Off'),
            value: reminder.enabled,
            onChanged: (value) => _toggle(context, state, reminder, value),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Workout time'),
            subtitle: Text(formatTime(reminder.hour, reminder.minute)),
            onTap: () => _pickTime(context, state, reminder),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('Remind me on', style: theme.textTheme.titleLarge),
          ),
          for (final day in weeklyPlan)
            CheckboxListTile(
              value: reminder.weekdays.contains(day.weekday),
              title: Text(weekdayName(day.weekday)),
              subtitle: Text(
                day.isRest ? 'Rest day' : '${day.name}  ·  ${day.focus}',
              ),
              onChanged: (value) =>
                  _toggleDay(state, reminder, day.weekday, value ?? false),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Notification text'),
            subtitle: Text('${reminder.title}\n${reminder.message}'),
            isThreeLine: true,
            onTap: () => _editText(context, state, reminder),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Send a test notification'),
            onTap: state.sendTestNotification,
          ),
        ],
      ),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    AppState state,
    ReminderSettings reminder,
    bool value,
  ) async {
    final allowed = await state.updateReminder(reminder.copyWith(enabled: value));
    if (!allowed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notifications are blocked. Allow them for Pump Chump in your phone settings.',
          ),
        ),
      );
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    AppState state,
    ReminderSettings reminder,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminder.hour, minute: reminder.minute),
    );
    if (picked == null) return;
    await state.updateReminder(
      reminder.copyWith(hour: picked.hour, minute: picked.minute),
    );
  }

  Future<void> _toggleDay(
    AppState state,
    ReminderSettings reminder,
    int weekday,
    bool selected,
  ) async {
    final days = {...reminder.weekdays};
    if (selected) {
      days.add(weekday);
    } else {
      days.remove(weekday);
    }
    await state.updateReminder(reminder.copyWith(weekdays: days));
  }

  Future<void> _editText(
    BuildContext context,
    AppState state,
    ReminderSettings reminder,
  ) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _EditTextDialog(
        title: reminder.title,
        message: reminder.message,
      ),
    );
    if (result == null) return;
    await state.updateReminder(
      reminder.copyWith(title: result.$1, message: result.$2),
    );
  }
}

class _EditTextDialog extends StatefulWidget {
  const _EditTextDialog({required this.title, required this.message});

  final String title;
  final String message;

  @override
  State<_EditTextDialog> createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<_EditTextDialog> {
  late final TextEditingController _title =
      TextEditingController(text: widget.title);
  late final TextEditingController _message =
      TextEditingController(text: widget.message);

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notification text'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _message,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final title = _title.text.trim();
            final message = _message.text.trim();
            if (title.isEmpty || message.isEmpty) return;
            Navigator.pop(context, (title, message));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
