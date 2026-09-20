// lib/features/training/training_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/curriculum_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/training_pack_model.dart';
import 'pack_card.dart';
import 'session_screen.dart';

/// The order the brief asks for. Each pack sits under its first category.
const _sectionOrder = [
  SkillCategory.shooting,
  SkillCategory.ballControl,
  SkillCategory.defense,
  SkillCategory.aerials,
  SkillCategory.wallPlay,
  SkillCategory.recoveries,
  SkillCategory.mechanics,
  SkillCategory.kickoffs,
];

class TrainingScreen extends ConsumerWidget {
  /// Packs that have not been checked in-game are shown while developing, and
  /// hidden in release builds.
  const TrainingScreen({super.key, this.showUnverified = !kReleaseMode});

  final bool showUnverified;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculum = ref.watch(curriculumProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Could not load the training packs: $error'),
        ),
        data: (data) => _PackList(data, showUnverified: showUnverified),
      ),
    );
  }
}

class _PackList extends StatelessWidget {
  const _PackList(this.curriculum, {required this.showUnverified});

  final CurriculumModel curriculum;
  final bool showUnverified;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shown = [
      for (final p in curriculum.trainingPacks)
        if (p.status == PackStatus.active ||
            (showUnverified && p.status == PackStatus.needsVerification))
          p,
    ]..sort((a, b) => a.difficulty.index.compareTo(b.difficulty.index));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Plan a session', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'We pick what to practice, for how long, and why.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (label, minutes) in const [
                    ('Quick · 10 min', 10),
                    ('Standard · 30 min', 30),
                    ('Long · 60 min', 60),
                  ])
                    FilledButton.tonal(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SessionScreen(
                            minutes: minutes,
                            showUnverified: showUnverified,
                          ),
                        ),
                      ),
                      child: Text(label),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Text(
            'Copy a code, open Rocket League, go to Training, then Custom, and '
            'search for the code. This app cannot open the game for you.\n\n'
            'Packs are made by community creators and are listed with their '
            'credit. Codes come from official Rocket League news posts from '
            '2019 to 2020, and creators can remove packs, so a code may not '
            'load.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        for (final category in _sectionOrder)
          ..._section(theme, category, [
            for (final p in shown)
              if (p.categories.first == category) p,
          ]),
      ],
    );
  }

  List<Widget> _section(
    ThemeData theme,
    SkillCategory category,
    List<TrainingPackModel> packs,
  ) {
    if (packs.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(category.label.toUpperCase(),
            style: theme.textTheme.titleMedium),
      ),
      for (final pack in packs)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PackCard(pack: pack, curriculum: curriculum),
        ),
    ];
  }
}