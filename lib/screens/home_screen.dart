// lib/screens/home_screen.dart

import 'package:flutter/material.dart';

import '../data/exercise_library.dart';
import '../data/weekly_plan.dart';
import '../models/workout_day.dart';
import '../services/app_state.dart';
import '../services/formatters.dart';
import '../widgets/exercise_tile.dart';
import 'exercise_details_screen.dart';
import 'workout_screen.dart';

/// The main screen. It answers one question: what do I do today?
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final day = state.today;
    final theme = Theme.of(context);
    final reminder = state.reminder;

    return Scaffold(
      appBar: AppBar(title: const Text('PUMP CHUMP')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            "TODAY'S WORKOUT",
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(day.name, style: theme.textTheme.headlineMedium),
          Text(day.focus, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          if (day.isRest)
            _RestCard(next: state.nextTrainingDay)
          else ...[
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => WorkoutScreen(day: day),
                ),
              ),
              child: const Text('START WORKOUT'),
            ),
            if (state.workedOutToday)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'You already finished a workout today.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Text("Today's exercises", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final id in day.exerciseIds)
              Builder(
                builder: (context) {
                  final exercise = exerciseById(id);
                  return ExerciseTile(
                    exercise: exercise,
                    goal: state.progressFor(exercise).currentGoal,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ExerciseDetailsScreen(exercise: exercise),
                      ),
                    ),
                  );
                },
              ),
          ],
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('This week'),
                  subtitle: Text(
                    '${state.workoutsThisWeek} workouts done  ·  '
                    '${state.workoutsCompleted} total',
                  ),
                ),
                ListTile(
                  leading: Icon(
                    reminder.enabled
                        ? Icons.notifications_active
                        : Icons.notifications_off_outlined,
                  ),
                  title: const Text('Reminders'),
                  subtitle: Text(
                    reminder.enabled
                        ? 'On at ${formatTime(reminder.hour, reminder.minute)}'
                        : 'Off. Turn them on in Schedule.',
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

class _RestCard extends StatelessWidget {
  const _RestCard({required this.next});

  final WorkoutDay? next;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextDay = next;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rest day', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Recovery is part of the plan. Take it easy today.',
              style: theme.textTheme.bodyLarge,
            ),
            if (nextDay != null) ...[
              const SizedBox(height: 12),
              Text(
                'Next workout: ${weekdayName(nextDay.weekday)}  ·  ${nextDay.name}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
