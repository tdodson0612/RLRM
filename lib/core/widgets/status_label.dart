// lib/core/widgets/status_label.dart

import 'package:flutter/material.dart';

import '../../domain/enums.dart';

/// A skill status shown as an icon and words, so it never relies on color.
class StatusLabel extends StatelessWidget {
  const StatusLabel(this.status, {super.key});

  final SkillStatus status;

  static IconData iconFor(SkillStatus status) => switch (status) {
        SkillStatus.locked => Icons.lock_outline,
        SkillStatus.notStarted => Icons.radio_button_unchecked,
        SkillStatus.practicing => Icons.timelapse,
        SkillStatus.consistent => Icons.check_circle_outline,
        SkillStatus.mastered => Icons.emoji_events_outlined,
        SkillStatus.maintenanceRecommended => Icons.autorenew,
      };

  /// Pale colors on dark panels, deeper ones on light panels. Both keep at
  /// least 3:1 contrast, and the words carry the meaning anyway.
  static Color colorFor(SkillStatus status, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (status) {
      SkillStatus.locked =>
        dark ? const Color(0xFF9AA4B5) : const Color(0xFF5B6475),
      SkillStatus.notStarted =>
        dark ? const Color(0xFFD5DAE5) : const Color(0xFF4A5165),
      SkillStatus.practicing =>
        dark ? const Color(0xFFFFB84D) : const Color(0xFF8F5400),
      SkillStatus.consistent =>
        dark ? const Color(0xFF5BE38A) : const Color(0xFF17703C),
      SkillStatus.mastered =>
        dark ? const Color(0xFFB4A9FF) : const Color(0xFF5138C4),
      SkillStatus.maintenanceRecommended =>
        dark ? const Color(0xFF6EC8FF) : const Color(0xFF0A628F),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconFor(status),
          size: 18,
          color: colorFor(status, Theme.of(context).brightness),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(status.label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}