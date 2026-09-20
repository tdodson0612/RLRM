// lib/features/roadmap/roadmap_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_label.dart';
import '../../data/curriculum_repository.dart';
import '../../data/profile_provider.dart';
import '../../data/progress_provider.dart';
import '../../domain/enums.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/progress_model.dart';
import '../../domain/models/skill_model.dart';
import '../../domain/progress_logic.dart';
import '../search/search_screen.dart';
import '../skills/skill_detail_screen.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculum = ref.watch(curriculumProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadmap'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
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

class _StageList extends ConsumerWidget {
  const _StageList({required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = ref.watch(progressProvider);
    final rank = ref.watch(profileProvider.select((p) => p.rank));
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
              curriculum: curriculum,
              progress: progress,
              rank: rank,
            ),
          ),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.stage,
    required this.curriculum,
    required this.progress,
    required this.rank,
  });

  final Stage stage;
  final CurriculumModel curriculum;
  final Map<String, ProgressModel> progress;
  final Stage rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skills = curriculum.skillsIn(stage);
    final now = DateTime.now();
    final done = skills
        .where((s) => ProgressLogic.isDone(ProgressLogic.statusOf(progress, s.id)))
        .length;
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(stage.label.toUpperCase(), style: theme.textTheme.titleMedium),
        subtitle: Text('$done of ${skills.length} done'),
        children: [
          for (final skill in skills)
            ListTile(
              title: Text(skill.name),
              subtitle: Text(
                '${skill.category.label} · ${skill.estimatedMinutes} min'
                '${skill.optional ? ' · Optional' : ''}',
              ),
              trailing: StatusLabel(_statusFor(skill, now)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => SkillDetailScreen(skill: skill),
                ),
              ),
            ),
        ],
      ),
    );
  }

  SkillStatus _statusFor(SkillModel skill, DateTime now) =>
      ProgressLogic.displayStatus(
        skill: skill,
        progress: progress[skill.id],
        prerequisitesMet:
            ProgressLogic.prerequisitesMet(skill, curriculum, progress, rank),
        now: now,
      );
}