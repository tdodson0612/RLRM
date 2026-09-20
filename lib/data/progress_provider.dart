// lib/data/progress_provider.dart

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models/progress_model.dart';
import '../domain/models/skill_model.dart';
import '../domain/progress_logic.dart';
import 'preferences.dart';

enum TaskKind { drill, mastery, application }

/// One logged practice: which skill, how long, and when.
class PracticeEntry {
  const PracticeEntry({
    required this.skillId,
    required this.minutes,
    required this.date,
  });

  factory PracticeEntry.fromJson(Map<String, dynamic> json) => PracticeEntry(
        skillId: json['skillId'] as String,
        minutes: json['minutes'] as int,
        date: DateTime.parse(json['date'] as String),
      );

  final String skillId;
  final int minutes;
  final DateTime date;

  Map<String, dynamic> toJson() => {
        'skillId': skillId,
        'minutes': minutes,
        'date': date.toIso8601String(),
      };
}

class PracticeLogNotifier extends Notifier<List<PracticeEntry>> {
  static const _key = 'practice_log_v1';

  @override
  List<PracticeEntry> build() {
    final raw = ref.read(sharedPreferencesProvider)?.getString(_key);
    if (raw == null) return [];
    try {
      return [
        for (final item in jsonDecode(raw) as List<dynamic>)
          PracticeEntry.fromJson(item as Map<String, dynamic>),
      ];
    } on Object {
      return []; // damaged data must never stop the app opening
    }
  }

  void add(String skillId, int minutes) {
    final next = [
      ...state,
      PracticeEntry(skillId: skillId, minutes: minutes, date: DateTime.now()),
    ];
    state = next.length > 300 ? next.sublist(next.length - 300) : next;
    _save();
  }

  void clear() {
    state = [];
    _save();
  }

  void _save() {
    ref.read(sharedPreferencesProvider)?.setString(
          _key,
          jsonEncode([for (final e in state) e.toJson()]),
        );
  }
}

final practiceLogProvider =
    NotifierProvider<PracticeLogNotifier, List<PracticeEntry>>(
  PracticeLogNotifier.new,
);

/// Progress for every skill the player has touched, keyed by skill id.
class ProgressNotifier extends Notifier<Map<String, ProgressModel>> {
  static const _key = 'progress_v1';

  @override
  Map<String, ProgressModel> build() {
    final raw = ref.read(sharedPreferencesProvider)?.getString(_key);
    if (raw == null) return {};
    try {
      final out = <String, ProgressModel>{};
      for (final item in jsonDecode(raw) as List<dynamic>) {
        final p = ProgressModel.fromJson(item as Map<String, dynamic>);
        out[p.skillId] = p;
      }
      return out;
    } on Object {
      return {}; // damaged data must never stop the app opening
    }
  }

  ProgressModel _get(String id) => state[id] ?? ProgressModel(skillId: id);

  void _put(ProgressModel p) {
    state = {...state, p.skillId: p};
    ref.read(sharedPreferencesProvider)?.setString(
          _key,
          jsonEncode([for (final item in state.values) item.toJson()]),
        );
  }

  /// Ticks or unticks a drill, mastery check or match-application check.
  void toggleTask(SkillModel skill, TaskKind kind, String taskId) {
    final p = _get(skill.id);
    Set<String> flip(Set<String> s) =>
        s.contains(taskId) ? ({...s}..remove(taskId)) : {...s, taskId};
    var next = switch (kind) {
      TaskKind.drill => p.copyWith(completedDrills: flip(p.completedDrills)),
      TaskKind.mastery => p.copyWith(
          completedMasteryRequirements: flip(p.completedMasteryRequirements)),
      TaskKind.application => p.copyWith(
          completedApplicationRequirements:
              flip(p.completedApplicationRequirements)),
    };
    next = next.copyWith(
      status: ProgressLogic.autoStatus(skill, next),
      lastPracticed: DateTime.now(),
    );
    _put(next);
  }

  void setStatus(String id, SkillStatus status) =>
      _put(_get(id).copyWith(status: status));

  /// "I already know this". Consistent ticks the mastery checks, mastered
  /// ticks the match-application checks as well.
  void markKnown(SkillModel skill, SkillStatus status) {
    final p = _get(skill.id);
    _put(p.copyWith(
      status: status,
      completedMasteryRequirements: {
        ...p.completedMasteryRequirements,
        for (final t in skill.masteryRequirements) t.id,
      },
      completedApplicationRequirements: status == SkillStatus.mastered
          ? {
              ...p.completedApplicationRequirements,
              for (final t in skill.matchApplicationRequirements) t.id,
            }
          : p.completedApplicationRequirements,
    ));
  }

  /// "I'm struggling". Repeated struggles send recommendations back a step.
  void recordStruggle(String id) {
    final p = _get(id);
    _put(p.copyWith(
      struggleCount: p.struggleCount + 1,
      lastStruggled: DateTime.now(),
      status: p.status == SkillStatus.notStarted
          ? SkillStatus.practicing
          : p.status,
    ));
  }

  /// Records a practice: last practiced date, log entry, and Practicing.
  void logPractice(String id, int minutes) {
    final p = _get(id);
    _put(p.copyWith(
      lastPracticed: DateTime.now(),
      status: p.status == SkillStatus.notStarted
          ? SkillStatus.practicing
          : p.status,
    ));
    ref.read(practiceLogProvider.notifier).add(id, minutes);
  }

  void toggleFavorite(String id) {
    final p = _get(id);
    _put(p.copyWith(favorite: !p.favorite));
  }

  void resetAll() {
    state = {};
    ref.read(sharedPreferencesProvider)?.remove(_key);
    ref.read(practiceLogProvider.notifier).clear();
  }
}

final progressProvider =
    NotifierProvider<ProgressNotifier, Map<String, ProgressModel>>(
  ProgressNotifier.new,
);