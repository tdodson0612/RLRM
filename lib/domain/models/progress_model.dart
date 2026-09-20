// lib/domain/models/progress_model.dart

import '../enums.dart';
import '../json_helpers.dart';

/// A player's progress on one skill. It holds ids only, so the curriculum can
/// change wording without breaking saved progress.
class ProgressModel {
  const ProgressModel({
    required this.skillId,
    this.status = SkillStatus.notStarted,
    this.completedDrills = const {},
    this.completedMasteryRequirements = const {},
    this.completedApplicationRequirements = const {},
    this.lastPracticed,
    this.notes = '',
    this.favorite = false,
    this.struggleCount = 0,
    this.lastStruggled,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
        skillId: json['skillId'] as String,
        status: enumByName(
            SkillStatus.values, json['status'] ?? 'notStarted', 'status'),
        completedDrills: stringList(json['completedDrills']).toSet(),
        completedMasteryRequirements:
            stringList(json['completedMasteryRequirements']).toSet(),
        completedApplicationRequirements:
            stringList(json['completedApplicationRequirements']).toSet(),
        lastPracticed: dateOrNull(json['lastPracticed']),
        notes: json['notes'] as String? ?? '',
        favorite: json['favorite'] as bool? ?? false,
        struggleCount: json['struggleCount'] as int? ?? 0,
        lastStruggled: dateOrNull(json['lastStruggled']),
      );

  final String skillId;
  final SkillStatus status;
  final Set<String> completedDrills;
  final Set<String> completedMasteryRequirements;
  final Set<String> completedApplicationRequirements;
  final DateTime? lastPracticed;
  final String notes;
  final bool favorite;

  /// How often the player tapped "I'm struggling". Repeated struggles move
  /// this skill's prerequisites up the recommendations.
  final int struggleCount;
  final DateTime? lastStruggled;

  ProgressModel copyWith({
    SkillStatus? status,
    Set<String>? completedDrills,
    Set<String>? completedMasteryRequirements,
    Set<String>? completedApplicationRequirements,
    DateTime? lastPracticed,
    String? notes,
    bool? favorite,
    int? struggleCount,
    DateTime? lastStruggled,
  }) =>
      ProgressModel(
        skillId: skillId,
        status: status ?? this.status,
        completedDrills: completedDrills ?? this.completedDrills,
        completedMasteryRequirements:
            completedMasteryRequirements ?? this.completedMasteryRequirements,
        completedApplicationRequirements: completedApplicationRequirements ??
            this.completedApplicationRequirements,
        lastPracticed: lastPracticed ?? this.lastPracticed,
        notes: notes ?? this.notes,
        favorite: favorite ?? this.favorite,
        struggleCount: struggleCount ?? this.struggleCount,
        lastStruggled: lastStruggled ?? this.lastStruggled,
      );

  Map<String, dynamic> toJson() => {
        'skillId': skillId,
        'status': status.name,
        'completedDrills': completedDrills.toList()..sort(),
        'completedMasteryRequirements': completedMasteryRequirements.toList()
          ..sort(),
        'completedApplicationRequirements':
            completedApplicationRequirements.toList()..sort(),
        if (lastPracticed != null)
          'lastPracticed': lastPracticed!.toIso8601String(),
        'notes': notes,
        'favorite': favorite,
        'struggleCount': struggleCount,
        if (lastStruggled != null)
          'lastStruggled': lastStruggled!.toIso8601String(),
      };
}