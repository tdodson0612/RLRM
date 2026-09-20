// lib/features/favorites/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/curriculum_repository.dart';
import '../../data/favorites_provider.dart';
import '../../data/progress_provider.dart';
import '../skills/skill_detail_screen.dart';
import '../training/pack_card.dart';
import '../training/session_screen.dart';

/// Everything the player has hearted: skills, training packs and sessions.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final curriculum = ref.watch(curriculumProvider);
    final progress = ref.watch(progressProvider);
    final favorites = ref.watch(favoritesProvider);

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(text, style: theme.textTheme.titleMedium),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Could not load favorites: $error'),
        ),
        data: (c) {
          final skills = [
            for (final s in c.skills)
              if (progress[s.id]?.favorite ?? false) s,
          ];
          final packs = [
            for (final p in c.trainingPacks)
              if (favorites.packs.contains(p.id)) p,
          ];
          if (skills.isEmpty && packs.isEmpty && favorites.sessions.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Nothing saved yet. Tap the heart on a skill, a training pack '
                'or a session to keep it here.',
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (skills.isNotEmpty) ...[
                heading('Skills'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final skill in skills)
                        ListTile(
                          title: Text(skill.name),
                          subtitle: Text(
                              '${skill.stage.label} · ${skill.category.label}'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => SkillDetailScreen(skill: skill),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              if (packs.isNotEmpty) ...[
                heading('Training packs'),
                for (final pack in packs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PackCard(pack: pack, curriculum: c),
                  ),
              ],
              if (favorites.sessions.isNotEmpty) ...[
                heading('Sessions'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final session in favorites.sessions)
                        ListTile(
                          title: Text(session.title),
                          subtitle: Text([
                            for (final id in session.skillIds)
                              c.skillById(id)?.name ?? id,
                          ].join(', ')),
                          trailing: IconButton(
                            tooltip: 'Remove saved session',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => ref
                                .read(favoritesProvider.notifier)
                                .toggleSession(session),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => SessionScreen(
                                minutes: session.minutes,
                                savedSkillIds: session.skillIds,
                                savedMode: session.mode,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}