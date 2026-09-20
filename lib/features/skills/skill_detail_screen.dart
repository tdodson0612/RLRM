// lib/features/skills/skill_detail_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_label.dart';
import '../../data/control_bindings_provider.dart';
import '../../data/curriculum_repository.dart';
import '../../data/profile_provider.dart';
import '../../data/progress_provider.dart';
import '../../domain/enums.dart';
import '../../domain/models/skill_model.dart';
import '../../domain/models/training_pack_model.dart';
import '../../domain/progress_logic.dart';
import '../training/pack_card.dart';

/// One lesson. Button names are written as tokens like `[Boost]` in the data
/// and shown here as the player's own buttons. Checkboxes save progress.
class SkillDetailScreen extends ConsumerWidget {
  const SkillDetailScreen({
    super.key,
    required this.skill,
    this.showUnverified = !kReleaseMode,
  });

  final SkillModel skill;

  /// Packs not yet checked in-game show while developing, not in release.
  final bool showUnverified;

  Future<void> _alreadyKnow(
    BuildContext context,
    WidgetRef ref,
    List<SkillModel> unfinished,
  ) async {
    final choice = await showDialog<SkillStatus>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('How well do you know this?'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, SkillStatus.consistent),
            child: const Text('Consistent: I can do it most of the time'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, SkillStatus.mastered),
            child: const Text('Mastered: I can also use it in real matches'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (choice == null || !context.mounted) return;
    if (unfinished.isNotEmpty) {
      final names = unfinished.map((s) => s.name).join(', ');
      final go = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Skipping ahead?'),
          content: Text(
            'You marked ${skill.name} as ${choice.label}, but these steps '
            'before it are not finished: $names. They usually make this one '
            'easier. You can continue anyway.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Go back'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Continue anyway'),
            ),
          ],
        ),
      );
      if (go != true || !context.mounted) return;
    }
    ref.read(progressProvider.notifier).markKnown(skill, choice);
  }

  void _struggle(
    BuildContext context,
    WidgetRef ref,
    List<SkillModel> unfinished,
    List<TrainingPackModel> packs,
    String Function(String) resolve,
  ) {
    ref.read(progressProvider.notifier).recordStruggle(skill.id);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _StruggleSheet(
        skill: skill,
        unfinished: unfinished,
        packs: packs,
        resolve: resolve,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bindings = ref.watch(controlBindingsProvider);
    final curriculum = ref.watch(curriculumProvider).valueOrNull;
    final progress = ref.watch(progressProvider);
    final profile = ref.watch(profileProvider);
    final notifier = ref.read(progressProvider.notifier);
    final mine = progress[skill.id];
    String t(String text) => bindings.resolve(text);

    final needs = <SkillModel>[];
    for (final id in skill.prerequisites) {
      final need = curriculum?.skillById(id);
      if (need != null) needs.add(need);
    }
    final unfinished = curriculum == null
        ? <SkillModel>[]
        : ProgressLogic.unfinishedPrerequisites(
            skill, curriculum, progress, profile.rank);
    final status = ProgressLogic.displayStatus(
      skill: skill,
      progress: mine,
      prerequisitesMet: unfinished.isEmpty,
      now: DateTime.now(),
    );
    final packs = <TrainingPackModel>[];
    for (final id in skill.trainingPackIds) {
      final pack = curriculum?.packById(id);
      if (pack == null) continue;
      if (pack.isActive ||
          (showUnverified && pack.status == PackStatus.needsVerification)) {
        packs.add(pack);
      }
    }

    List<Widget> checks(List<SkillTask> tasks, Set<String> done, TaskKind kind) {
      return [
        for (final task in tasks)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            value: done.contains(task.id),
            onChanged: (_) => notifier.toggleTask(skill, kind, task.id),
            title: Text(task.title == null
                ? t(task.text)
                : '${task.title}: ${t(task.text)}'),
          ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(skill.name),
        actions: [
          IconButton(
            tooltip: (mine?.favorite ?? false)
                ? 'Remove from favorites'
                : 'Add to favorites',
            icon: Icon((mine?.favorite ?? false)
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () => notifier.toggleFavorite(skill.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(skill.stage.label)),
              Chip(label: Text(skill.category.label)),
              Chip(label: Text('${skill.estimatedMinutes} min')),
              Chip(
                label: Text(skill.applicableModes.map((m) => m.label).join(', ')),
              ),
              if (skill.optional) const Chip(label: Text('Optional / Advanced')),
            ],
          ),
          const SizedBox(height: 16),
          StatusLabel(status),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (status == SkillStatus.notStarted ||
                  status == SkillStatus.locked)
                FilledButton(
                  onPressed: () =>
                      notifier.setStatus(skill.id, SkillStatus.practicing),
                  child: const Text('Start practicing'),
                ),
              OutlinedButton(
                onPressed: () => _alreadyKnow(context, ref, unfinished),
                child: const Text('I already know this'),
              ),
              OutlinedButton(
                onPressed: () => _struggle(context, ref, unfinished, packs, t),
                child: const Text("I'm struggling with this"),
              ),
              OutlinedButton(
                onPressed: () {
                  notifier.logPractice(skill.id, skill.estimatedMinutes);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Practice logged.')),
                  );
                },
                child: const Text('I practiced this'),
              ),
            ],
          ),
          _Section('What is it?', [Text(t(skill.description))]),
          _Section('Why it matters', [Text(t(skill.whyItMatters))]),
          _Section('What this unlocks', [Text(skill.whatItUnlocks)]),
          if (needs.isNotEmpty)
            _Section('Learn these first', [
              for (final need in needs)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(need.name),
                  subtitle: Text(need.stage.label),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SkillDetailScreen(
                        skill: need,
                        showUnverified: showUnverified,
                      ),
                    ),
                  ),
                ),
            ]),
          _Section('How to do it', [
            for (var i = 0; i < skill.instructions.length; i++)
              Text('${i + 1}. ${t(skill.instructions[i])}'),
          ]),
          _Section(
            'Practice (${skill.trainingMethod.label})',
            checks(skill.drills, mine?.completedDrills ?? const <String>{},
                TaskKind.drill),
          ),
          _Section(
            'How you will know you have it',
            checks(skill.masteryRequirements,
                mine?.completedMasteryRequirements ?? const <String>{},
                TaskKind.mastery),
          ),
          _Section(
            'Use it in a match',
            checks(skill.matchApplicationRequirements,
                mine?.completedApplicationRequirements ?? const <String>{},
                TaskKind.application),
          ),
          if (skill.commonMistakes.isNotEmpty)
            _Section('Common mistakes', [
              for (final m in skill.commonMistakes) Text('• ${t(m)}'),
            ]),
          if (skill.easierDrill != null)
            _Section('An easier way to start', [Text(t(skill.easierDrill!))]),
          if (packs.isNotEmpty) ...[
            const _Heading('Training packs'),
            for (final pack in packs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PackCard(pack: pack, curriculum: curriculum!),
              ),
          ],
        ],
      ),
    );
  }
}

class _StruggleSheet extends StatelessWidget {
  const _StruggleSheet({
    required this.skill,
    required this.unfinished,
    required this.packs,
    required this.resolve,
  });

  final SkillModel skill;
  final List<SkillModel> unfinished;
  final List<TrainingPackModel> packs;
  final String Function(String) resolve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: Text(text, style: theme.textTheme.titleMedium),
        );
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Let's get you unstuck", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              'Getting stuck is normal. Slow down, make it easier, then build '
              'back up.',
            ),
            if (skill.commonMistakes.isNotEmpty) ...[
              heading('Common mistakes'),
              for (final m in skill.commonMistakes) Text('• ${resolve(m)}'),
            ],
            if (skill.easierDrill != null) ...[
              heading('Try an easier version'),
              Text(resolve(skill.easierDrill!)),
            ],
            heading('Recommended first'),
            Text(unfinished.isEmpty
                ? 'You have the steps before this one covered.'
                : 'Practice ${unfinished.first.name} first. It is the step '
                    'before this one.'),
            if (packs.isNotEmpty) ...[
              heading('Training pack'),
              Text('${packs.first.name} by ${packs.first.creator ?? 'unknown'}'),
              SelectableText(packs.first.code),
            ],
            heading('Suggested retry'),
            const Text(
              'Do the easier version for about 10 minutes. Take a break, then '
              'try the first drill again in your next session.',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
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

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Heading(title),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}