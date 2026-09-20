// lib/domain/models/skill_model.dart

import '../enums.dart';
import '../json_helpers.dart';
import 'stat_check.dart';

/// One checkable item: a drill, a mastery requirement or a match-application
/// requirement. Progress tracking saves the [id], so keep ids stable.
class SkillTask {
  const SkillTask({required this.id, required this.text, this.title});

  factory SkillTask.fromJson(Map<String, dynamic> json) => SkillTask(
        id: json['id'] as String,
        text: json['text'] as String,
        title: json['title'] as String?,
      );

  final String id;
  final String text;
  final String? title;

  Map<String, dynamic> toJson() => {
        'id': id,
        if (title != null) 'title': title,
        'text': text,
      };
}

class SkillModel {
  const SkillModel({
    required this.id,
    required this.name,
    required this.stage,
    required this.category,
    required this.description,
    required this.whyItMatters,
    required this.whatItUnlocks,
    required this.instructions,
    required this.drills,
    required this.masteryRequirements,
    required this.matchApplicationRequirements,
    required this.prerequisites,
    required this.trainingPackIds,
    required this.applicableModes,
    required this.estimatedMinutes,
    required this.maintenanceInterval,
    this.optional = false,
    this.trainingMethod = TrainingMethod.freeplay,
    this.commonMistakes = const [],
    this.easierDrill,
    this.statChecks = const [],
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        id: json['id'] as String,
        name: json['name'] as String,
        stage: enumByName(Stage.values, json['stage'], 'stage'),
        category:
            enumByName(SkillCategory.values, json['category'], 'category'),
        description: json['description'] as String,
        whyItMatters: json['whyItMatters'] as String,
        whatItUnlocks: json['whatItUnlocks'] as String,
        instructions: stringList(json['instructions']),
        drills: objectList(json['drills'], SkillTask.fromJson),
        masteryRequirements:
            objectList(json['masteryRequirements'], SkillTask.fromJson),
        matchApplicationRequirements:
            objectList(json['matchApplicationRequirements'], SkillTask.fromJson),
        prerequisites: stringList(json['prerequisites']),
        trainingPackIds: stringList(json['trainingPackIds']),
        applicableModes:
            enumList(GameMode.values, json['applicableModes'], 'mode'),
        estimatedMinutes: json['estimatedMinutes'] as int,
        maintenanceInterval:
            Duration(days: json['maintenanceIntervalDays'] as int),
        optional: json['optional'] as bool? ?? false,
        trainingMethod: enumByName(TrainingMethod.values,
            json['trainingMethod'] ?? 'freeplay', 'trainingMethod'),
        commonMistakes: stringList(json['commonMistakes']),
        easierDrill: json['easierDrill'] as String?,
        statChecks: objectList(json['statChecks'], StatCheck.fromJson),
      );

  final String id;
  final String name;
  final Stage stage;
  final SkillCategory category;

  /// "What is it?" in plain words. Lesson text may use control tokens.
  final String description;
  final String whyItMatters;
  final String whatItUnlocks;

  /// Step-by-step controller instructions. Buttons are written as tokens such
  /// as `[Boost]` and resolved with the player's own bindings.
  final List<String> instructions;
  final List<SkillTask> drills;
  final List<SkillTask> masteryRequirements;
  final List<SkillTask> matchApplicationRequirements;

  /// Skills that should come first. They guide recommendations and never lock.
  final List<String> prerequisites;
  final List<String> trainingPackIds;
  final List<GameMode> applicableModes;
  final int estimatedMinutes;

  /// How long after the last practice this skill should be refreshed.
  final Duration maintenanceInterval;
  final bool optional;
  final TrainingMethod trainingMethod;

  /// Shown by "I'm struggling with this".
  final List<String> commonMistakes;
  final String? easierDrill;
  final List<StatCheck> statChecks;

  bool appliesTo(GameMode mode) =>
      mode == GameMode.all ||
      applicableModes.contains(GameMode.all) ||
      applicableModes.contains(mode);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'stage': stage.name,
        'category': category.name,
        'description': description,
        'whyItMatters': whyItMatters,
        'whatItUnlocks': whatItUnlocks,
        'instructions': instructions,
        'drills': [for (final t in drills) t.toJson()],
        'masteryRequirements': [for (final t in masteryRequirements) t.toJson()],
        'matchApplicationRequirements': [
          for (final t in matchApplicationRequirements) t.toJson(),
        ],
        'prerequisites': prerequisites,
        'trainingPackIds': trainingPackIds,
        'applicableModes': [for (final m in applicableModes) m.name],
        'optional': optional,
        'estimatedMinutes': estimatedMinutes,
        'maintenanceIntervalDays': maintenanceInterval.inDays,
        'trainingMethod': trainingMethod.name,
        'commonMistakes': commonMistakes,
        if (easierDrill != null) 'easierDrill': easierDrill,
        'statChecks': [for (final c in statChecks) c.toJson()],
      };
}