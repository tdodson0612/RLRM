// lib/widgets/exercise_tile.dart

import 'package:flutter/material.dart';

import '../models/exercise.dart';

/// One row in an exercise list: name, goal, and (optionally) personal best.
class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.goal,
    this.personalBest,
    this.showRegion = true,
    this.onTap,
  });

  final Exercise exercise;
  final int goal;

  /// null = do not show. 0 = show "Not logged yet".
  final int? personalBest;
  final bool showRegion;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (showRegion) exercise.region.label,
      'Goal: ${exercise.goalLabel(goal)}',
      if (personalBest != null)
        personalBest == 0
            ? 'Not logged yet'
            : 'Best: $personalBest ${exercise.unit}',
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        subtitle: Text(parts.join('  ·  ')),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
