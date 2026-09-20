// lib/features/settings/controls_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/control_bindings_provider.dart';
import '../../domain/controls/control_bindings.dart';

/// Lessons say [Boost]. This screen decides which button that shows as.
class ControlsScreen extends ConsumerWidget {
  const ControlsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bindings = ref.watch(controlBindingsProvider);
    final notifier = ref.read(bindingsStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Controls')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Set the button you use for each action. Lessons will show your '
            'buttons instead of the defaults (PlayStation).',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final action in ControlAction.values)
                  ListTile(
                    title: Text(action.label),
                    subtitle: Text(bindings.buttonFor(action)),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () async {
                      final button = await showDialog<String>(
                        context: context,
                        builder: (_) => _ButtonDialog(
                          action: action,
                          current: bindings.buttonFor(action),
                        ),
                      );
                      if (button != null && button.trim().isNotEmpty) {
                        notifier.rebind(action, button.trim());
                      }
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              for (final action in ControlAction.values) {
                notifier.reset(action);
              }
            },
            child: const Text('Reset all to PlayStation defaults'),
          ),
        ],
      ),
    );
  }
}

class _ButtonDialog extends StatefulWidget {
  const _ButtonDialog({required this.action, required this.current});

  final ControlAction action;
  final String current;

  @override
  State<_ButtonDialog> createState() => _ButtonDialogState();
}

class _ButtonDialogState extends State<_ButtonDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.current);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Button for ${widget.action.label}'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'For example R1 or Circle'),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}