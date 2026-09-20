// lib/features/roadmap/roadmap_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/curriculum_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/skill_model.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculum = ref.watch(curriculumProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Roadmap')),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Could not load the curriculum: $error'),
        ),
        data: (data) => _StageList(curriculum: data),
      ),
    );
  }
}

class _StageList extends StatelessWidget {
  const _StageList({required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Beginner → SSL', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          '${curriculum.skills.length} skills. Open any stage. Nothing is locked.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final stage in Stage.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _StageCard(
              stage: stage,
              skills: curriculum.skillsIn(stage),
            ),
          ),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({required this.stage, required this.skills});

  final Stage stage;
  final List<SkillModel> skills;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(stage.label.toUpperCase(), style: theme.textTheme.titleMedium),
        subtitle: Text('${skills.length} skills'),
        children: [
          for (final skill in skills)
            ListTile(
              title: Text(skill.name),
              subtitle: Text(
                '${skill.category.label} · ${skill.estimatedMinutes} min',
              ),
              trailing: skill.optional ? const Text('Optional') : null,
            ),
        ],
      ),
    );
  }
}