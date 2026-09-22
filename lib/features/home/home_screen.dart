// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_label.dart';
import '../../data/curriculum_repository.dart';
import '../../data/profile_provider.dart';
import '../../data/progress_provider.dart';
import '../../domain/enums.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/skill_model.dart';
import '../../domain/progress_logic.dart';
import '../../domain/session_generator.dart';
import '../favorites/favorites_screen.dart';
import '../search/search_screen.dart';
import '../skills/skill_detail_screen.dart';
import '../training/session_screen.dart';

void _open(BuildContext context, Widget screen) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => screen));

/// Opens the app and answers one question: what should I practice next?
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curriculum = ref.watch(curriculumProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => _open(context, const SearchScreen()),
          ),
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite_border),
            onPressed: () => _open(context, const FavoritesScreen()),
          ),
        ],
      ),
      body: Stack(
        children: [
          // An original car (see assets/cars/bg_car.png, not a Rocket League
          // vehicle) sitting behind the content, faint enough to never
          // compete with the text or progress bars on top of it.
          Positioned(
            right: -60,
            bottom: -40,
            child: Opacity(
              opacity: 0.08,
              child: Image.asset('assets/cars/bg_car.png', width: 340),
            ),
          ),
          curriculum.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Could not load your training: $error'),
            ),
            data: (data) => _HomeBody(curriculum: data),
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = ref.watch(progressProvider);
    final profile = ref.watch(profileProvider);
    final now = DateTime.now();

    final recs = SessionGenerator.recommend(
      curriculum: curriculum,
      progress: progress,
      profile: profile,
      now: now,
    );
    SkillStatus statusOf(SkillModel s) => ProgressLogic.statusOf(progress, s.id);
    SkillStatus shown(SkillModel s) => ProgressLogic.displayStatus(
          skill: s,
          progress: progress[s.id],
          prerequisitesMet: ProgressLogic.prerequisitesMet(
              s, curriculum, progress, profile.rank),
          now: now,
        );

    final today = recs.take(3).toList();
    final next = recs
        .where((r) => statusOf(r.skill) == SkillStatus.notStarted)
        .firstOrNull;
    final focus = recs
        .where((r) => statusOf(r.skill) == SkillStatus.practicing)
        .firstOrNull;
    final completed = [
      for (final s in curriculum.skills)
        if (ProgressLogic.isDone(statusOf(s)) &&
            progress[s.id]?.lastPracticed != null)
          s,
    ]..sort((a, b) => progress[b.id]!.lastPracticed!
        .compareTo(progress[a.id]!.lastPracticed!));
    final refresh = [
      for (final s in curriculum.skills)
        if (ProgressLogic.maintenanceDue(s, progress[s.id], now)) s,
    ];
    final finished = curriculum.skills
        .where((s) => ProgressLogic.isDone(statusOf(s)))
        .length;
    final total = curriculum.skills.length;
    final stage = ProgressLogic.frontier(curriculum, progress, profile.rank);

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(text, style: theme.textTheme.titleMedium),
        );

    ListTile tile(SkillModel skill, String subtitle) => ListTile(
          title: Text(skill.name),
          subtitle: Text(subtitle),
          trailing: StatusLabel(shown(skill)),
          onTap: () => _open(context, SkillDetailScreen(skill: skill)),
        );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your training', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('Current stage: ${stage.label}'),
              Text('$finished of $total skills consistent or mastered'),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: total == 0 ? 0 : finished / total,
                minHeight: 8,
                semanticsLabel: 'Overall progress',
                semanticsValue: '$finished of $total skills',
              ),
            ],
          ),
        ),
        heading("Today's training"),
        if (today.isEmpty)
          const AppCard(
            child: Text(
              'You have worked through everything we can suggest for this '
              'mode. Try another mode or rank in Settings.',
            ),
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final rec in today)
                  tile(rec.skill, '${rec.skill.estimatedMinutes} min'),
              ],
            ),
          ),
        heading('Recommended next'),
        if (next == null)
          const AppCard(child: Text('Nothing new to start right now.'))
        else
          AppCard(
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(next.skill.name, style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('Why: ${next.reason}'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      _open(context, SkillDetailScreen(skill: next.skill)),
                  child: const Text('Start training'),
                ),
              ],
            ),
          ),
        heading('Current focus'),
        if (focus == null)
          const AppCard(child: Text('Nothing in progress yet.'))
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: tile(focus.skill, focus.reason),
          ),
        if (completed.isNotEmpty) ...[
          heading('Recently completed'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final s in completed.take(3)) tile(s, s.category.label),
              ],
            ),
          ),
        ],
        if (refresh.isNotEmpty) ...[
          heading('Time to refresh'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final s in refresh.take(3))
                  tile(
                    s,
                    'Last practiced '
                    '${now.difference(progress[s.id]!.lastPracticed!).inDays} '
                    'days ago',
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => _open(context, const SessionScreen(minutes: 30)),
          child: const Text('Continue training'),
        ),
      ],
    );
  }
}