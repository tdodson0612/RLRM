// lib/domain/session_generator.dart

import 'enums.dart';
import 'models/curriculum_model.dart';
import 'models/player_profile.dart';
import 'models/progress_model.dart';
import 'models/skill_model.dart';
import 'models/training_pack_model.dart';
import 'progress_logic.dart';

/// One thing to practice in a session.
class SessionActivity {
  const SessionActivity({
    required this.skill,
    required this.minutes,
    required this.method,
    required this.goal,
    required this.reason,
    this.pack,
  });

  final SkillModel skill;
  final int minutes;
  final TrainingMethod method;
  final TrainingPackModel? pack;

  /// The next thing to try. It may contain `[Button]` tokens.
  final String goal;

  /// Why this skill was picked, in plain words.
  final String reason;
}

class TrainingSession {
  const TrainingSession({
    required this.minutes,
    required this.mode,
    required this.activities,
  });

  final int minutes;
  final GameMode mode;
  final List<SessionActivity> activities;

  String get name => switch (minutes) {
        10 => 'Quick session',
        30 => 'Standard session',
        _ => 'Long session',
      };
}

/// A skill worth practicing now, with a score and a plain-words reason.
class SkillRecommendation {
  const SkillRecommendation(this.skill, this.score, this.reason);

  final SkillModel skill;
  final double score;
  final String reason;
}

abstract final class SessionGenerator {
  /// Ranks skills for right now. The order of importance is: skills being
  /// practiced, recent struggles (which send you back a step), skills whose
  /// prerequisites are done, skills close to mastery, then maintenance. Only
  /// skills that fit the mode are used, and nothing is random. Home and the
  /// session builder both use this.
  static List<SkillRecommendation> recommend({
    required CurriculumModel curriculum,
    required Map<String, ProgressModel> progress,
    required PlayerProfile profile,
    GameMode? mode,
    Set<String> exclude = const {},
    DateTime? now,
  }) {
    final when = now ?? DateTime.now();
    final playMode = mode ?? profile.mode;
    final reach =
        ProgressLogic.frontier(curriculum, progress, profile.rank).index + 1;
    final found = <String, SkillRecommendation>{};

    void offer(SkillModel skill, double score, String reason) {
      if (exclude.contains(skill.id) || !skill.appliesTo(playMode)) return;
      var total = score;
      if (_inFocus(profile.focus, skill.category)) total += 8;
      if (playMode != GameMode.all && skill.applicableModes.contains(playMode)) {
        total += 10;
      }
      total -= skill.stage.index * 0.5;
      final old = found[skill.id];
      if (old == null || total > old.score) {
        found[skill.id] = SkillRecommendation(skill, total, reason);
      }
    }

    for (final skill in curriculum.skills) {
      if (ProgressLogic.assumedKnown(skill, progress, profile.rank)) continue;
      final p = progress[skill.id];
      final status = ProgressLogic.statusOf(progress, skill.id);

      if (status == SkillStatus.practicing) {
        final lastStruggle = p?.lastStruggled;
        final recent =
            lastStruggle != null && when.difference(lastStruggle).inDays <= 14;
        offer(skill, recent ? 115 : 100, 'You are already practicing this.');
        if (recent && (p?.struggleCount ?? 0) >= 2) {
          final back = ProgressLogic.unfinishedPrerequisites(
              skill, curriculum, progress, profile.rank);
          if (back.isNotEmpty) {
            offer(
              back.first,
              130,
              'You have struggled with ${skill.name}, and ${back.first.name} '
              'is the step before it.',
            );
          }
        }
      } else if (status == SkillStatus.notStarted) {
        final ready = skill.stage.index <= reach &&
            ProgressLogic.prerequisitesMet(
                skill, curriculum, progress, profile.rank);
        if (ready) offer(skill, 50, _readyReason(skill, curriculum));
      } else if (status == SkillStatus.consistent) {
        offer(
          skill,
          40 + 20 * ProgressLogic.closeness(skill, p),
          'You can do this already. Now prove it in a real match.',
        );
      } else if (ProgressLogic.maintenanceDue(skill, p, when)) {
        final days = when.difference(p!.lastPracticed!).inDays;
        final interval = skill.maintenanceInterval.inDays == 0
            ? 1
            : skill.maintenanceInterval.inDays;
        final overdue = (days / interval).clamp(0.0, 3.0).toDouble();
        offer(skill, 30 + overdue * 5,
            'Maintenance: you last practiced this $days days ago.');
      }
    }

    if (found.isEmpty) {
      for (final skill in curriculum.skills) {
        if (!ProgressLogic.isDone(ProgressLogic.statusOf(progress, skill.id))) {
          offer(skill, 1, 'The next unfinished skill on your roadmap.');
          if (found.isNotEmpty) break;
        }
      }
    }

    return found.values.toList()..sort((a, b) => b.score.compareTo(a.score));
  }

  /// Builds a session of 10, 30 or 60 minutes from the top recommendations.
  static TrainingSession generate({
    required CurriculumModel curriculum,
    required Map<String, ProgressModel> progress,
    required PlayerProfile profile,
    required int minutes,
    GameMode? mode,
    Set<String> exclude = const {},
    bool allowUnverifiedPacks = false,
    DateTime? now,
  }) {
    final ranked = recommend(
      curriculum: curriculum,
      progress: progress,
      profile: profile,
      mode: mode,
      exclude: exclude,
      now: now,
    );
    final count = switch (minutes) { 10 => 1, 30 => 3, _ => 4 };
    return _assemble(
      ranked.take(count).toList(),
      curriculum: curriculum,
      progress: progress,
      minutes: minutes,
      mode: mode ?? profile.mode,
      allowUnverified: allowUnverifiedPacks,
    );
  }

  /// Rebuilds a saved (favorite) session for the same skills, using today's
  /// progress for the goals and packs.
  static TrainingSession fromSkills({
    required CurriculumModel curriculum,
    required Map<String, ProgressModel> progress,
    required int minutes,
    required GameMode mode,
    required List<String> skillIds,
    bool allowUnverifiedPacks = false,
  }) {
    return _assemble(
      [
        for (final id in skillIds)
          if (curriculum.skillById(id) != null)
            SkillRecommendation(
                curriculum.skillById(id)!, 0, 'From your saved session.'),
      ],
      curriculum: curriculum,
      progress: progress,
      minutes: minutes,
      mode: mode,
      allowUnverified: allowUnverifiedPacks,
    );
  }

  static TrainingSession _assemble(
    List<SkillRecommendation> chosen, {
    required CurriculumModel curriculum,
    required Map<String, ProgressModel> progress,
    required int minutes,
    required GameMode mode,
    required bool allowUnverified,
  }) {
    final each = chosen.isEmpty ? 0 : minutes ~/ chosen.length;
    var packsUsed = 0;
    final activities = <SessionActivity>[];
    for (final c in chosen) {
      final pack = packsUsed < 3
          ? _pickPack(c.skill, curriculum, mode, allowUnverified)
          : null;
      if (pack != null) packsUsed++;
      final method = pack != null
          ? TrainingMethod.customTraining
          : (c.skill.trainingMethod == TrainingMethod.customTraining
              ? TrainingMethod.freeplay
              : c.skill.trainingMethod);
      activities.add(SessionActivity(
        skill: c.skill,
        minutes: each,
        method: method,
        pack: pack,
        goal: _goal(c.skill, progress[c.skill.id]),
        reason: c.reason,
      ));
    }
    return TrainingSession(minutes: minutes, mode: mode, activities: activities);
  }

  static bool _inFocus(Set<SkillCategory> focus, SkillCategory category) {
    if (focus.contains(category)) return true;
    if (focus.contains(SkillCategory.gameSense) &&
        category == SkillCategory.positioning) {
      return true;
    }
    return focus.contains(SkillCategory.mechanics) &&
        const {
          SkillCategory.wallPlay,
          SkillCategory.recoveries,
          SkillCategory.kickoffs,
          SkillCategory.boostManagement,
        }.contains(category);
  }

  static String _readyReason(SkillModel skill, CurriculumModel curriculum) {
    if (skill.prerequisites.isEmpty) return 'A good place to start.';
    final names = [
      for (final id in skill.prerequisites.take(2))
        if (curriculum.skillById(id) != null) curriculum.skillById(id)!.name,
    ];
    return 'You have the steps before it covered: ${names.join(', ')}.';
  }

  static TrainingPackModel? _pickPack(
    SkillModel skill,
    CurriculumModel curriculum,
    GameMode mode,
    bool allowUnverified,
  ) {
    for (final id in skill.trainingPackIds) {
      final pack = curriculum.packById(id);
      if (pack == null) continue;
      final usable = pack.status == PackStatus.active ||
          (allowUnverified && pack.status == PackStatus.needsVerification);
      final fits = mode == GameMode.all ||
          pack.applicableModes.contains(GameMode.all) ||
          pack.applicableModes.contains(mode);
      if (usable && fits) return pack;
    }
    return null;
  }

  /// The next unfinished drill, then mastery check, then match check.
  static String _goal(SkillModel skill, ProgressModel? p) {
    for (final t in skill.drills) {
      if (!(p?.completedDrills.contains(t.id) ?? false)) {
        return t.title == null ? t.text : '${t.title}: ${t.text}';
      }
    }
    for (final t in skill.masteryRequirements) {
      if (!(p?.completedMasteryRequirements.contains(t.id) ?? false)) {
        return t.text;
      }
    }
    for (final t in skill.matchApplicationRequirements) {
      if (!(p?.completedApplicationRequirements.contains(t.id) ?? false)) {
        return t.text;
      }
    }
    return skill.masteryRequirements.isEmpty
        ? skill.description
        : skill.masteryRequirements.first.text;
  }
}