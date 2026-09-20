// lib/features/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/profile_provider.dart';
import '../../domain/enums.dart';

const _focusChoices = [
  SkillCategory.mechanics,
  SkillCategory.shooting,
  SkillCategory.defense,
  SkillCategory.aerials,
  SkillCategory.ballControl,
  SkillCategory.gameSense,
];

/// Shown once, before the player has set anything up.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  Stage _rank = Stage.beginner;
  GameMode _mode = GameMode.all;
  final Set<SkillCategory> _focus = {};

  void _finish() {
    final notifier = ref.read(profileProvider.notifier);
    notifier.save(
      ref.read(profileProvider).copyWith(
            rank: _rank,
            mode: _mode,
            focus: {..._focus},
            onboarded: true,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SingleChildScrollView(child: _body(theme))),
              FilledButton(
                onPressed: _step == 3
                    ? _finish
                    : () => setState(() => _step++),
                child: Text(switch (_step) {
                  0 => 'Get started',
                  3 => 'Build my roadmap',
                  _ => 'Next',
                }),
              ),
              if (_step > 0)
                TextButton(
                  onPressed: () => setState(() => _step--),
                  child: const Text('Back'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(ThemeData theme) {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text('Welcome to RLRM.', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Build your skills one step at a time.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'RLRM is an unofficial fan project. It works fully offline and '
              'keeps everything on your device.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      case 1:
        return _question(
          theme,
          'What is your current rank?',
          [
            for (final s in Stage.values)
              ChoiceChip(
                label: Text(s.label),
                selected: _rank == s,
                onSelected: (_) => setState(() => _rank = s),
              ),
          ],
          'This only decides where we start. Nothing is hidden, and you can '
          'change it later.',
        );
      case 2:
        return _question(
          theme,
          'What mode do you mainly play?',
          [
            for (final m in GameMode.values)
              ChoiceChip(
                label: Text(m.label),
                selected: _mode == m,
                onSelected: (_) => setState(() => _mode = m),
              ),
          ],
          'Sessions and recommendations lean toward this mode.',
        );
      default:
        return _question(
          theme,
          'What do you want to improve?',
          [
            ChoiceChip(
              label: const Text('Everything'),
              selected: _focus.isEmpty,
              onSelected: (_) => setState(_focus.clear),
            ),
            for (final c in _focusChoices)
              FilterChip(
                label: Text(c.label),
                selected: _focus.contains(c),
                onSelected: (on) => setState(() {
                  if (on) {
                    _focus.add(c);
                  } else {
                    _focus.remove(c);
                  }
                }),
              ),
          ],
          'Pick as many as you like.',
        );
    }
  }

  Widget _question(
    ThemeData theme,
    String title,
    List<Widget> choices,
    String note,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: choices),
        const SizedBox(height: 16),
        Text(note, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}