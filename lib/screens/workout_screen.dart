// lib/screens/workout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/exercise_library.dart';
import '../models/exercise.dart';
import '../models/workout_day.dart';
import '../models/workout_session.dart';
import '../services/app_state.dart';
import 'reward_screen.dart';

/// Walks through today's exercises one at a time:
/// see the goal -> do the exercise -> enter what you really did -> next.
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.day});

  final WorkoutDay day;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late final List<Exercise> _exercises =
      widget.day.exerciseIds.map(exerciseById).toList();
  final List<ExerciseResult> _results = [];
  final TextEditingController _controller = TextEditingController();

  int _index = 0;
  bool _finished = false;
  bool _busy = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final goal = AppScope.of(context).progressFor(_exercises.first).currentGoal;
      _controller.text = '$goal';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _step(int delta) {
    final value = int.tryParse(_controller.text.trim()) ?? 0;
    _controller.text = '${(value + delta).clamp(0, 999)}';
  }

  Future<void> _complete() async {
    final actual = int.tryParse(_controller.text.trim());
    if (actual == null || actual <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter how many you did (1 or more), or tap Skip.'),
        ),
      );
      return;
    }

    final state = AppScope.of(context);
    final exercise = _exercises[_index];
    setState(() => _busy = true);

    // The ACTUAL number is saved, even when it is above the goal.
    final update = await state.logResult(exercise, actual);
    _results.add(
      ExerciseResult(
        exerciseId: exercise.id,
        goal: update.previousGoal,
        actual: actual,
      ),
    );
    if (!mounted) return;

    if (update.goalReached) {
      if (state.celebrations) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => RewardScreen(
              exercise: exercise,
              update: update,
              actual: actual,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Goal reached! New goal: ${exercise.goalLabel(update.progress.currentGoal)}',
            ),
          ),
        );
      }
    }
    if (!mounted) return;
    setState(() => _busy = false);
    await _advance();
  }

  Future<void> _advance() async {
    final state = AppScope.of(context);
    if (_index + 1 >= _exercises.length) {
      await state.saveSession(widget.day, _results);
      if (mounted) setState(() => _finished = true);
      return;
    }
    final next = _exercises[_index + 1];
    setState(() {
      _index++;
      _controller.text = '${state.progressFor(next).currentGoal}';
    });
  }

  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End workout early?'),
        content: const Text('Exercises you already logged are saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End workout'),
          ),
        ],
      ),
    );
    if (leave != true || !mounted) return;
    await AppScope.of(context).saveSession(widget.day, _results);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      return _SummaryView(day: widget.day, results: _results);
    }

    final state = AppScope.of(context);
    final exercise = _exercises[_index];
    final progress = state.progressFor(exercise);
    final theme = Theme.of(context);
    final step = exercise.type == ExerciseType.time ? 5 : 1;

    return PopScope(
      canPop: _results.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('${_index + 1} of ${_exercises.length}')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _index / _exercises.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          exercise.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text(
                          exercise.region.label,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'GOAL',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 3,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${progress.currentGoal}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          exercise.perSide
                              ? '${exercise.unit} each side'
                              : exercise.unit,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Do ${exercise.sets} sets. Enter your best set below.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: ExpansionTile(
                            key: ValueKey(exercise.id),
                            initiallyExpanded: progress.timesLogged == 0,
                            shape: const Border(),
                            collapsedShape: const Border(),
                            title: const Text('How to do it'),
                            childrenPadding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.instructions,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Move with control. Stop if something hurts.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (exercise.note != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  exercise.note!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'WHAT DID YOU ACTUALLY DO?',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        _RepStepper(
                          controller: _controller,
                          step: step,
                          onStep: _step,
                        ),
                      ],
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: _busy ? null : _complete,
                  child: const Text('COMPLETE'),
                ),
                TextButton(
                  onPressed: _busy ? null : _advance,
                  child: const Text('Skip this exercise'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Big number box with minus and plus buttons.
class _RepStepper extends StatelessWidget {
  const _RepStepper({
    required this.controller,
    required this.step,
    required this.onStep,
  });

  final TextEditingController controller;
  final int step;
  final void Function(int delta) onStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filledTonal(
          iconSize: 32,
          onPressed: () => onStep(-step),
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 130,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        IconButton.filledTonal(
          iconSize: 32,
          onPressed: () => onStep(step),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

/// Shown after the last exercise.
class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.day, required this.results});

  final WorkoutDay day;
  final List<ExerciseResult> results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKOUT COMPLETE'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                results.isEmpty ? 'No exercises logged.' : 'Nice work!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              Text(
                day.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final result in results)
                      Card(
                        child: ListTile(
                          title: Text(
                            findExercise(result.exerciseId)?.name ??
                                result.exerciseId,
                          ),
                          subtitle: Text('Goal was ${result.goal}'),
                          trailing: Text(
                            '${result.actual}',
                            style: theme.textTheme.titleLarge,
                          ),
                          leading: Icon(
                            result.reachedGoal
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('DONE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
