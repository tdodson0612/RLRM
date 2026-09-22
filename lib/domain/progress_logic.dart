// lib/domain/progress_logic.dart

import 'enums.dart';
import 'models/curriculum_model.dart';
import 'models/progress_model.dart';
import 'models/skill_model.dart';

/// The rules that turn saved progress into statuses. Plain functions with no
/// screens involved, so they are easy to test.
abstract final class ProgressLogic {
  static bool isDone(SkillStatus status) =>
      status == SkillStatus.consistent || status == SkillStatus.mastered;

  static SkillStatus statusOf(Map<String, ProgressModel> progress, String id) =>
      progress[id]?.status ?? SkillStatus.notStarted;

  /// Skills below the player's own rank are assumed known until they say
  /// otherwise. They are never recommended, and never hidden.
  static bool assumedKnown(
    SkillModel skill,
    Map<String, ProgressModel> progress,
    Stage rank,
  ) =>
      skill.stage.index < rank.index &&
      statusOf(progress, skill.id) == SkillStatus.notStarted;

  /// Prerequisites that are neither finished nor assumed known.
  static List<SkillModel> unfinishedPrerequisites(
    SkillModel skill,
    CurriculumModel curriculum,
    Map<String, ProgressModel> progress,
    Stage rank,
  ) {
    final out = <SkillModel>[];
    for (final id in skill.prerequisites) {
      final need = curriculum.skillById(id);
      if (need == null) continue;
      if (!isDone(statusOf(progress, id)) &&
          !assumedKnown(need, progress, rank)) {
        out.add(need);
      }
    }
    return out;
  }

  static bool prerequisitesMet(
    SkillModel skill,
    CurriculumModel curriculum,
    Map<String, ProgressModel> progress,
    Stage rank,
  ) =>
      unfinishedPrerequisites(skill, curriculum, progress, rank).isEmpty;

  /// How much of the mastery and match-application checks are ticked, 0 to 1.
  static double closeness(SkillModel skill, ProgressModel? progress) {
    final total = skill.masteryRequirements.length +
        skill.matchApplicationRequirements.length;
    if (total == 0 || progress == null) return 0;
    final done = progress.completedMasteryRequirements.length +
        progress.completedApplicationRequirements.length;
    return (done / total).clamp(0.0, 1.0).toDouble();
  }

  /// Moves a status forward as boxes are ticked. It never moves it back.
  static SkillStatus autoStatus(SkillModel skill, ProgressModel p) {
    var status = p.status;
    final started = p.completedDrills.isNotEmpty ||
        p.completedMasteryRequirements.isNotEmpty ||
        p.completedApplicationRequirements.isNotEmpty;
    if (status == SkillStatus.notStarted && started) {
      status = SkillStatus.practicing;
    }
    final masteryDone = skill.masteryRequirements.isNotEmpty &&
        skill.masteryRequirements
            .every((t) => p.completedMasteryRequirements.contains(t.id));
    final matchDone = skill.matchApplicationRequirements.isNotEmpty &&
        skill.matchApplicationRequirements
            .every((t) => p.completedApplicationRequirements.contains(t.id));
    if (masteryDone && matchDone) return SkillStatus.mastered;
    if (masteryDone &&
        (status == SkillStatus.notStarted ||
            status == SkillStatus.practicing)) {
      return SkillStatus.consistent;
    }
    return status;
  }

  /// A mastered skill that has gone unpracticed for its whole interval.
  static bool maintenanceDue(
    SkillModel skill,
    ProgressModel? progress,
    DateTime now,
  ) {
    final last = progress?.lastPracticed;
    if (progress == null || progress.status != SkillStatus.mastered) {
      return false;
    }
    return last != null && now.difference(last) >= skill.maintenanceInterval;
  }

  /// What to show on screen. Locked and maintenance are never saved. They are
  /// worked out here, and neither one blocks anything.
  static SkillStatus displayStatus({
    required SkillModel skill,
    required ProgressModel? progress,
    required bool prerequisitesMet,
    required DateTime now,
  }) {
    final stored = progress?.status ?? SkillStatus.notStarted;
    if (maintenanceDue(skill, progress, now)) {
      return SkillStatus.maintenanceRecommended;
    }
    if (stored == SkillStatus.notStarted && !prerequisitesMet) {
      return SkillStatus.locked;
    }
    return stored;
  }

  /// Packs at your rank or one stage below. A Gold player sees Silver and
  /// Gold packs (easy or right at level) but nothing above Gold. A Beginner
  /// sees only Beginner-difficulty content, since there is no stage below it.
  static bool packFitsRank(Stage packDifficulty, Stage playerRank) =>
      packDifficulty.index <= playerRank.index &&
      packDifficulty.index >= playerRank.index - 1;

  /// The highest stage where at least 70% of the core skills are done, or the
  /// player's own rank if that is higher. Recommendations reach one past it.
  static Stage frontier(
    CurriculumModel curriculum,
    Map<String, ProgressModel> progress,
    Stage rank,
  ) {
    var best = rank;
    for (final stage in Stage.values) {
      if (stage.index <= best.index) continue;
      final core = curriculum.skillsIn(stage).where((s) => !s.optional).toList();
      if (core.isEmpty) continue;
      final done = core.where((s) => isDone(statusOf(progress, s.id))).length;
      if (done / core.length >= 0.7) best = stage;
    }
    return best;
  }
}