// lib/features/progress/progress_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_label.dart';
import '../../data/curriculum_repository.dart';
import '../../data/progress_provider.dart';
import '../../domain/enums.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/progress_model.dart';
import '../../domain/models/skill_model.dart';
import '../../domain/progress_logic.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculum = ref.watch(curriculumProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Could not load progress: $error'),
        ),
        data: (data) => _Body(curriculum: data),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = ref.watch(progressProvider);
    final log = ref.watch(practiceLogProvider);

    bool done(SkillModel s) =>
        ProgressLogic.isDone(ProgressLogic.statusOf(progress, s.id));
    final total = curriculum.skills.length;
    final finished = curriculum.skills.where(done).length;
    final percent = total == 0 ? 0.0 : finished / total;

    final week = log.where(
      (e) => DateTime.now().difference(e.date).inDays < 7,
    );
    final weekMinutes = week.fold<int>(0, (sum, e) => sum + e.minutes);

    final recent = [
      for (final p in progress.values)
        if (p.lastPracticed != null) p,
    ]..sort((a, b) => b.lastPracticed!.compareTo(a.lastPracticed!));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${(percent * 100).round()}%',
                  style: theme.textTheme.headlineSmall),
              Text('$finished of $total skills consistent or mastered'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: percent, minHeight: 8),
            ],
          ),
        ),
        const _Heading('By status'),
        AppCard(
          child: Column(
            children: [
              for (final status in const [
                SkillStatus.notStarted,
                SkillStatus.practicing,
                SkillStatus.consistent,
                SkillStatus.mastered,
                SkillStatus.maintenanceRecommended,
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: StatusLabel(status)),
                      Text('${_count(status, progress)}'),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const _Heading('By stage'),
        AppCard(
          child: Column(
            children: [
              for (final stage in Stage.values)
                _Bar(
                  label: stage.label,
                  finished: curriculum.skillsIn(stage).where(done).length,
                  total: curriculum.skillsIn(stage).length,
                ),
            ],
          ),
        ),
        const _Heading('By category'),
        AppCard(
          child: Column(
            children: [
              for (final category in SkillCategory.values)
                _Bar(
                  label: category.label,
                  finished: [
                    for (final s in curriculum.skills)
                      if (s.category == category && done(s)) s,
                  ].length,
                  total: curriculum.skills
                      .where((s) => s.category == category)
                      .length,
                ),
            ],
          ),
        ),
        const _Heading('Practice'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This week: $weekMinutes minutes in ${week.length} sessions'),
              const SizedBox(height: 8),
              if (recent.isEmpty)
                const Text('Nothing practiced yet. Start with a session.')
              else
                for (final p in recent.take(5))
                  Text(
                    '${curriculum.skillById(p.skillId)?.name ?? p.skillId} · '
                    '${p.lastPracticed!.month}/${p.lastPracticed!.day}',
                  ),
            ],
          ),
        ),
      ],
    );
  }

  int _count(SkillStatus status, Map<String, ProgressModel> progress) {
    if (status == SkillStatus.maintenanceRecommended) {
      final now = DateTime.now();
      return curriculum.skills
          .where((s) => ProgressLogic.maintenanceDue(s, progress[s.id], now))
          .length;
    }
    if (status == SkillStatus.notStarted) {
      final touched = progress.values
          .where((p) => p.status != SkillStatus.notStarted)
          .length;
      return curriculum.skills.length - touched;
    }
    return progress.values.where((p) => p.status == status).length;
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      );
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.finished,
    required this.total,
  });

  final String label;
  final int finished;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text('$finished / $total'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: total == 0 ? 0 : finished / total),
        ],
      ),
    );
  }
}