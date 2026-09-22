// lib/screens/exercise_details_screen.dart

import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../services/app_state.dart';

/// Everything about one exercise: how to do it, what it trains,
/// your current goal, and your personal best.
class ExerciseDetailsScreen extends StatelessWidget {
  const ExerciseDetailsScreen({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = AppScope.of(context).progressFor(exercise);

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(exercise.region.label)),
              Chip(
                label: Text(
                  exercise.difficulty == Difficulty.beginner
                      ? 'Beginner'
                      : 'Intermediate',
                ),
              ),
              Chip(
                label: Text(
                  exercise.type == ExerciseType.time ? 'Timed' : 'Reps',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'CURRENT GOAL',
                  value: exercise.goalLabel(progress.currentGoal),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'PERSONAL BEST',
                  value: progress.personalBest == 0
                      ? 'Not yet'
                      : '${progress.personalBest} ${exercise.unit}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _Section(title: 'Target muscles', body: exercise.targetMuscles),
          _Section(title: 'How to do it', body: exercise.instructions),
          _Section(
            title: 'Sets',
            body:
                'Do ${exercise.sets} sets. Enter your best set when you log it.',
          ),
          if (exercise.note != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(exercise.note!, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Move with control and keep good form. Stop if something hurts, '
            'and only move up when the current goal feels solid.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(value, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
