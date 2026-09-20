// lib/features/training/pack_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/favorites_provider.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/training_pack_model.dart';

/// One training pack: credit, code, what it helps with and a Copy Code button.
class PackCard extends ConsumerWidget {
  const PackCard({
    super.key,
    required this.pack,
    required this.curriculum,
  });

  final TrainingPackModel pack;
  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saved = ref.watch(favoritesProvider).packs.contains(pack.id);
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
          Text('Aimed at: ${pack.difficulty.label} · Modes: $modes'),
          Text('Helps with: ${skills.join(', ')}'),
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
        ],
      ),
    );
  }
}