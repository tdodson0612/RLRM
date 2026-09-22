// lib/screens/reward_screen.dart

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/exercise.dart';
import '../models/exercise_progress.dart';

/// The "GOOD JOB!" celebration shown when the user reaches a goal.
class RewardScreen extends StatefulWidget {
  const RewardScreen({
    super.key,
    required this.exercise,
    required this.update,
    required this.actual,
  });

  final Exercise exercise;
  final GoalUpdate update;

  /// What the user really did. Shown as-is, never replaced by the goal.
  final int actual;

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _confetti.play();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final exercise = widget.exercise;
    final update = widget.update;
    final over = widget.actual - update.previousGoal;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.5, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: Text(
                      '🎉 GOOD JOB! 🎉',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'NEW GOAL UNLOCKED',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    exercise.goalLabel(update.progress.currentGoal).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  Text(
                    exercise.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    over > 0
                        ? 'You did ${widget.actual}, which is $over over your goal!'
                        : 'You hit ${widget.actual}.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  if (update.newPersonalBest) ...[
                    const SizedBox(height: 12),
                    const Center(
                      child: Chip(
                        avatar: Icon(Icons.emoji_events),
                        label: Text('NEW PERSONAL BEST'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('CONTINUE'),
                  ),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.2,
            colors: [
              scheme.primary,
              scheme.secondary,
              scheme.tertiary,
              Colors.amber,
            ],
          ),
        ],
      ),
    );
  }
}
