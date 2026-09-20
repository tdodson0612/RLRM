// lib/domain/models/training_pack_model.dart

import '../enums.dart';
import '../json_helpers.dart';

/// A reference to a community-made training pack. The app lists the code and
/// credits the creator. It does not own or host the pack.
class TrainingPackModel {
  const TrainingPackModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.categories,
    required this.skills,
    required this.applicableModes,
    required this.difficulty,
    required this.source,
    this.status = PackStatus.needsVerification,
    this.creator,
    this.sourceUrl,
    this.verifiedDate,
    this.lastChecked,
    this.replacementPackId,
    this.verificationNotes,
  });

  factory TrainingPackModel.fromJson(Map<String, dynamic> json) =>
      TrainingPackModel(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
        description: json['description'] as String,
        categories:
            enumList(SkillCategory.values, json['categories'], 'category'),
        skills: stringList(json['skills']),
        applicableModes:
            enumList(GameMode.values, json['applicableModes'], 'mode'),
        difficulty: enumByName(Stage.values, json['difficulty'], 'difficulty'),
        source: json['source'] as String,
        status: enumByName(
            PackStatus.values, json['status'] ?? 'needsVerification', 'status'),
        creator: json['creator'] as String?,
        sourceUrl: json['sourceUrl'] as String?,
        verifiedDate: dateOrNull(json['verifiedDate']),
        lastChecked: dateOrNull(json['lastChecked']),
        replacementPackId: json['replacementPackId'] as String?,
        verificationNotes: json['verificationNotes'] as String?,
      );

  final String id;
  final String name;

  /// The in-game code, like `ABCD-1234-EF56-7890`.
  final String code;
  final String description;
  final List<SkillCategory> categories;

  /// Ids of the skills this pack helps with.
  final List<String> skills;
  final List<GameMode> applicableModes;

  /// The stage this pack is aimed at, not a promise about rank.
  final Stage difficulty;

  /// Where the code was found, for example a publication name.
  final String source;
  final PackStatus status;
  final String? creator;
  final String? sourceUrl;
  final DateTime? verifiedDate;
  final DateTime? lastChecked;

  /// Set when [status] is retired, so the curriculum can point to a new pack.
  final String? replacementPackId;
  final String? verificationNotes;

  bool get isActive => status == PackStatus.active;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'description': description,
        'categories': [for (final c in categories) c.name],
        'skills': skills,
        'applicableModes': [for (final m in applicableModes) m.name],
        'difficulty': difficulty.name,
        'source': source,
        'status': status.name,
        if (creator != null) 'creator': creator,
        if (sourceUrl != null) 'sourceUrl': sourceUrl,
        if (verifiedDate != null) 'verifiedDate': dateOnly(verifiedDate),
        if (lastChecked != null) 'lastChecked': dateOnly(lastChecked),
        if (replacementPackId != null) 'replacementPackId': replacementPackId,
        if (verificationNotes != null) 'verificationNotes': verificationNotes,
      };
}