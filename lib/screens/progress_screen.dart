// lib/screens/progress_screen.dart

import 'package:flutter/material.dart';

import '../data/exercise_library.dart';
import '../models/exercise.dart';
import '../models/workout_session.dart';
import '../services/app_state.dart';
import '../services/formatters.dart';
import '../widgets/exercise_tile.dart';
import 'exercise_details_screen.dart';

/// Goals, personal bests, and workout history.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final history = state.history;

    return Scaffold(
      appBar: AppBar(title: const Text('PROGRESS')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: _BigStat(
                  value: '${state.workoutsCompleted}',
                  label: 'Workouts done',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BigStat(
                  value: '${state.workoutsThisWeek}',
                  label: 'This week',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Exercise goals', style: theme.textTheme.titleLarge),
          for (final region in BodyRegion.values)
            if (exercisesForRegion(region).isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  region.label.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              for (final exercise in exercisesForRegion(region))
                ExerciseTile(
                  exercise: exercise,
                  goal: state.progressFor(exercise).currentGoal,
                  personalBest: state.progressFor(exercise).personalBest,
                  showRegion: false,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ExerciseDetailsScreen(exercise: exercise),
                    ),
                  ),
                ),
            ],
          const SizedBox(height: 24),
          Text('Workout history', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          if (history.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No workouts yet. Finish your first workout and it will show up here.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            )
          else
            for (final session in history.take(30)) _SessionTile(session: session),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 44,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final count = session.results.length;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          session.planName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${formatDate(session.date)}  ·  $count exercise${count == 1 ? '' : 's'}',
        ),
        children: [
          for (final result in session.results)
            ListTile(
              dense: true,
              leading: Icon(
                result.reachedGoal ? Icons.check_circle : Icons.circle_outlined,
                size: 20,
              ),
              title: Text(findExercise(result.exerciseId)?.name ?? result.exerciseId),
              trailing: Text('${result.actual}  (goal ${result.goal})'),
            ),
        ],
      ),
    );
  }
}
