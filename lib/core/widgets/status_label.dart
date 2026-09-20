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

  static Color colorFor(SkillStatus status) => switch (status) {
        SkillStatus.locked => const Color(0xFF9AA4B5),
        SkillStatus.notStarted => const Color(0xFFD5DAE5),
        SkillStatus.practicing => const Color(0xFFFFB84D),
        SkillStatus.consistent => const Color(0xFF5BE38A),
        SkillStatus.mastered => const Color(0xFFB4A9FF),
        SkillStatus.maintenanceRecommended => const Color(0xFF6EC8FF),
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconFor(status), size: 18, color: colorFor(status)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(status.label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}