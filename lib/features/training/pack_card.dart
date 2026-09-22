// lib/features/training/pack_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/favorites_provider.dart';
import '../../data/pack_report_mail.dart';
import '../../data/pack_report_provider.dart';
import '../../data/profile_provider.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/training_pack_model.dart';

/// One training pack: credit, code, what it helps with, Copy Code, and a way
/// to report the difficulty as wrong for your rank.
class PackCard extends ConsumerWidget {
  const PackCard({
    super.key,
    required this.pack,
    required this.curriculum,
  });

  final TrainingPackModel pack;
  final CurriculumModel curriculum;

  Future<void> _openReportSheet(BuildContext context, WidgetRef ref) async {
    final existing = ref.read(packReportsProvider)[pack.id];
    final choice = await showModalBottomSheet<ReportKind?>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Report ${pack.name}'),
              subtitle: Text('Listed as ${pack.difficulty.label}'),
            ),
            ListTile(
              leading: const Icon(Icons.trending_up_rounded),
              title: const Text('Way too hard for my rank'),
              onTap: () => Navigator.pop(ctx, ReportKind.tooHard),
            ),
            ListTile(
              leading: const Icon(Icons.trending_down_rounded),
              title: const Text('Way too easy for my rank'),
              onTap: () => Navigator.pop(ctx, ReportKind.tooEasy),
            ),
            if (existing != null)
              ListTile(
                leading: const Icon(Icons.undo_rounded),
                title: const Text('Undo my report'),
                onTap: () => Navigator.pop(ctx, null),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;

    if (existing != null && choice == null) {
      ref.read(packReportsProvider.notifier).undo(pack.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report undone. Shows as ${pack.difficulty.label} again.')),
      );
      return;
    }
    if (choice == null) return; // sheet dismissed without a choice

    ref.read(packReportsProvider.notifier).report(pack, choice);
    final profile = ref.read(profileProvider);
    final mailto = packReportMailto(pack: pack, kind: choice, profile: profile);
    await ref.read(mailLauncherProvider)(mailto);
    if (!context.mounted) return;
    final now = effectiveDifficulty(pack, ref.read(packReportsProvider));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thanks — this now shows as ${now.label} for you. We opened an '
          'email with the details; send it so this gets fixed for everyone.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saved = ref.watch(favoritesProvider).packs.contains(pack.id);
    final report = ref.watch(packReportsProvider)[pack.id];
    final shownDifficulty = report?.effectiveDifficulty ?? pack.difficulty;
    final skills = [
      for (final id in pack.skills) curriculum.skillById(id)?.name ?? id,
    ];
    final modes = pack.applicableModes.map((m) => m.label).join(', ');
    final checked = pack.isActive;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pack.name, style: theme.textTheme.titleMedium),
                    if (pack.creator != null)
                      Text('by ${pack.creator}',
                          style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              IconButton(
                tooltip: saved ? 'Remove from favorites' : 'Add to favorites',
                icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).togglePack(pack.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            pack.code,
            style: theme.textTheme.titleLarge?.copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(pack.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Aimed at: ${shownDifficulty.label} · Modes: $modes'),
          Text('Helps with: ${skills.join(', ')}'),
          if (report != null) ...[
            const SizedBox(height: 8),
            Text(
              'You reported this as '
              '${report.kind == ReportKind.tooHard ? 'too hard' : 'too easy'}.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.secondary),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(checked ? Icons.check_circle_outline : Icons.help_outline,
                  size: 18, color: theme.colorScheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  checked ? 'Checked in game' : 'Not checked in game yet',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copy Code'),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: pack.code));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Training pack code copied!')),
                  );
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.flag_outlined),
                label: Text(report == null ? 'Report difficulty' : 'Reported'),
                onPressed: () => _openReportSheet(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
