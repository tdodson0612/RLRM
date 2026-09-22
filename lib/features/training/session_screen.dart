// lib/features/training/session_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/control_bindings_provider.dart';
import '../../data/curriculum_repository.dart';
import '../../data/favorites_provider.dart';
import '../../data/pack_report_provider.dart';
import '../../data/profile_provider.dart';
import '../../data/progress_provider.dart';
import '../../domain/enums.dart';
import '../../domain/session_generator.dart';
import '../skills/skill_detail_screen.dart';

/// A timed practice plan: what to work on, for how long, how, and why.
class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({
    super.key,
    required this.minutes,
    this.showUnverified = !kReleaseMode,
    this.savedSkillIds,
    this.savedMode,
  });

  final int minutes;
  final bool showUnverified;

  /// Set when a favorite session is opened. Those skills are used until the
  /// player changes the mode, skips a skill or builds a new session.
  final List<String>? savedSkillIds;
  final GameMode? savedMode;

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  final Set<String> _excluded = {};
  final Set<String> _done = {};
  late GameMode? _mode = widget.savedMode;
  late bool _useSaved = widget.savedSkillIds != null;
  TrainingSession? _session;

  TrainingSession? _generate() {
    final curriculum = ref.read(curriculumProvider).valueOrNull;
    if (curriculum == null) return null;
    final packReports = ref.read(packReportsProvider);
    if (_useSaved) {
      return SessionGenerator.fromSkills(
        curriculum: curriculum,
        progress: ref.read(progressProvider),
        minutes: widget.minutes,
        mode: _mode ?? ref.read(profileProvider).mode,
        rank: ref.read(profileProvider).rank,
        skillIds: widget.savedSkillIds!,
        allowUnverifiedPacks: widget.showUnverified,
        packReports: packReports,
      );
    }
    return SessionGenerator.generate(
      curriculum: curriculum,
      progress: ref.read(progressProvider),
      profile: ref.read(profileProvider),
      minutes: widget.minutes,
      mode: _mode,
      exclude: _excluded,
      allowUnverifiedPacks: widget.showUnverified,
      packReports: packReports,
    );
  }

  void _regenerate() => setState(() => _session = null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final curriculum = ref.watch(curriculumProvider);
    final bindings = ref.watch(controlBindingsProvider);
    final profile = ref.watch(profileProvider);
    _session ??= _generate();
    final session = _session;
    final mode = _mode ?? profile.mode;
    final current = session == null
        ? null
        : SavedSession(
            minutes: session.minutes,
            mode: session.mode,
            skillIds: [for (final a in session.activities) a.skill.id],
          );
    final saved = current != null &&
        ref.watch(favoritesProvider).sessions.any((s) => s.id == current.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(session?.name ?? 'Session'),
        actions: [
          if (current != null && current.skillIds.isNotEmpty)
            IconButton(
              tooltip: saved ? 'Remove saved session' : 'Save this session',
              icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggleSession(current),
            ),
        ],
      ),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Could not build a session: $error'),
        ),
        data: (_) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('${widget.minutes} minutes', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in GameMode.values)
                  ChoiceChip(
                    label: Text(m.label),
                    selected: mode == m,
                    onSelected: (_) {
                      _mode = m;
                      _useSaved = false;
                      _done.clear();
                      _regenerate();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (session == null || session.activities.isEmpty)
              const Text('There is nothing to suggest for this mode yet.')
            else
              for (final activity in session.activities)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _card(context, activity, bindings.resolve),
                ),
            OutlinedButton(
              onPressed: () {
                _excluded.clear();
                _done.clear();
                _useSaved = false;
                _regenerate();
              },
              child: const Text('Build a new session'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    SessionActivity activity,
    String Function(String) resolve,
  ) {
    final theme = Theme.of(context);
    final skill = activity.skill;
    final pack = activity.pack;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill.name, style: theme.textTheme.titleMedium),
          Text('${activity.minutes} min · ${activity.method.label}'),
          const SizedBox(height: 8),
          Text('Goal: ${resolve(activity.goal)}'),
          const SizedBox(height: 4),
          Text('Why: ${activity.reason}'),
          if (pack != null) ...[
            const SizedBox(height: 8),
            Text('Pack: ${pack.name} by ${pack.creator ?? 'unknown'}'),
            SelectableText(
              pack.code,
              style: theme.textTheme.titleMedium?.copyWith(letterSpacing: 1.2),
            ),
            OutlinedButton.icon(
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
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Done'),
            value: _done.contains(skill.id),
            onChanged: (on) {
              setState(() {
                if (on ?? false) {
                  if (_done.add(skill.id)) {
                    ref
                        .read(progressProvider.notifier)
                        .logPractice(skill.id, activity.minutes);
                  }
                } else {
                  _done.remove(skill.id);
                }
              });
            },
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SkillDetailScreen(
                      skill: skill,
                      showUnverified: widget.showUnverified,
                    ),
                  ),
                ),
                child: const Text('Open lesson'),
              ),
              TextButton(
                onPressed: () {
                  _excluded.add(skill.id);
                  _useSaved = false;
                  _regenerate();
                },
                child: const Text('Skip this skill'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
