// lib/core/widgets/stage_placeholder.dart

import 'package:flutter/material.dart';

import 'app_card.dart';

/// Temporary body for a tab whose real screen is built in a later stage.
/// It states what is coming and never shows fake data.
class StagePlaceholder extends StatelessWidget {
  const StagePlaceholder({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.stage,
  });

  final String title;
  final IconData icon;
  final String description;
  final int stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(icon, size: 36, color: theme.colorScheme.primary),
              title: Text(title, style: theme.textTheme.titleLarge),
              subtitle: Text('$description\n\nBuilt in Stage $stage.'),
            ),
          ),
        ],
      ),
    );
  }
}