// lib/domain/models/curriculum_model.dart

import '../enums.dart';
import '../json_helpers.dart';
import 'skill_model.dart';
import 'training_pack_model.dart';

/// The whole versioned curriculum. Skills and packs are data, so either can be
/// updated without touching the app's screens.
class CurriculumModel {
  CurriculumModel({
    required this.version,
    required this.packDataVersion,
    required this.releaseDate,
    required this.lastUpdated,
    required this.skills,
    required this.trainingPacks,
  })  : _skillsById = {for (final s in skills) s.id: s},
        _packsById = {for (final p in trainingPacks) p.id: p};

  factory CurriculumModel.fromJson(Map<String, dynamic> json) =>
      CurriculumModel(
        version: json['version'] as String,
        packDataVersion: json['packDataVersion'] as String,
        releaseDate: DateTime.parse(json['releaseDate'] as String),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
        skills: objectList(json['skills'], SkillModel.fromJson),
        trainingPacks:
            objectList(json['trainingPacks'], TrainingPackModel.fromJson),
      );

  final String version;
  final String packDataVersion;
  final DateTime releaseDate;
  final DateTime lastUpdated;

  /// In curriculum order: Beginner first, SSL last.
  final List<SkillModel> skills;
  final List<TrainingPackModel> trainingPacks;

  final Map<String, SkillModel> _skillsById;
  final Map<String, TrainingPackModel> _packsById;

  SkillModel? skillById(String id) => _skillsById[id];
  TrainingPackModel? packById(String id) => _packsById[id];

  List<SkillModel> skillsIn(Stage stage) =>
      [for (final s in skills) if (s.stage == stage) s];

  /// Skills that list [id] as a prerequisite.
  List<SkillModel> unlockedBy(String id) =>
      [for (final s in skills) if (s.prerequisites.contains(id)) s];

  Map<String, dynamic> toJson() => {
        'version': version,
        'packDataVersion': packDataVersion,
        'releaseDate': dateOnly(releaseDate),
        'lastUpdated': dateOnly(lastUpdated),
        'skills': [for (final s in skills) s.toJson()],
        'trainingPacks': [for (final p in trainingPacks) p.toJson()],
      };
}