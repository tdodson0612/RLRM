// lib/data/pack_report_provider.dart

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models/training_pack_model.dart';
import 'preferences.dart';

/// Why the player reported a pack. "Too hard" nudges the effective
/// difficulty up a stage; "too easy" nudges it down a stage. This is a guess
/// at the right difficulty, not a promise: the master data still needs a
/// human to fix it (see the emailed report).
enum ReportKind { tooHard, tooEasy }

/// One report, kept so the pack card can show "you reported this" and offer
/// to undo it.
class PackReport {
  const PackReport({
    required this.kind,
    required this.effectiveDifficulty,
    required this.reportedAt,
  });

  factory PackReport.fromJson(Map<String, dynamic> json) => PackReport(
        kind: ReportKind.values.byName(json['kind'] as String),
        effectiveDifficulty:
            Stage.values.byName(json['effectiveDifficulty'] as String),
        reportedAt: DateTime.parse(json['reportedAt'] as String),
      );

  final ReportKind kind;
  final Stage effectiveDifficulty;
  final DateTime reportedAt;

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'effectiveDifficulty': effectiveDifficulty.name,
        'reportedAt': reportedAt.toIso8601String(),
      };
}

/// Reports are kept only on this device. They change what this player sees;
/// they do not change the pack for anyone else, and they are never sent
/// anywhere unless the player presses Send on the email draft the report
/// screen opens for them.
class PackReportsNotifier extends Notifier<Map<String, PackReport>> {
  static const _key = 'pack_reports_v1';

  @override
  Map<String, PackReport> build() {
    final raw = ref.read(sharedPreferencesProvider)?.getString(_key);
    if (raw == null) return {};
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return {
        for (final entry in json.entries)
          entry.key: PackReport.fromJson(entry.value as Map<String, dynamic>),
      };
    } on Object {
      return {}; // damaged data must never stop the app opening
    }
  }

  /// One stage harder for "too hard", one stage easier for "too easy",
  /// clamped to Beginner..SSL. Immediately changes what this pack looks like
  /// to this player, including whether it still shows for their rank.
  void report(TrainingPackModel pack, ReportKind kind) {
    final shift = kind == ReportKind.tooHard ? 1 : -1;
    final nextIndex =
        (pack.difficulty.index + shift).clamp(0, Stage.values.length - 1);
    _set(pack.id, PackReport(
      kind: kind,
      effectiveDifficulty: Stage.values[nextIndex],
      reportedAt: DateTime.now(),
    ));
  }

  void undo(String packId) {
    final next = {...state}..remove(packId);
    state = next;
    _save(next);
  }

  void _set(String packId, PackReport report) {
    final next = {...state, packId: report};
    state = next;
    _save(next);
  }

  void _save(Map<String, PackReport> reports) {
    ref.read(sharedPreferencesProvider)?.setString(
          _key,
          jsonEncode({for (final e in reports.entries) e.key: e.value.toJson()}),
        );
  }
}

final packReportsProvider =
    NotifierProvider<PackReportsNotifier, Map<String, PackReport>>(
  PackReportsNotifier.new,
);

/// The difficulty this player actually sees for a pack: their own report if
/// they made one, otherwise the pack's listed difficulty.
Stage effectiveDifficulty(
  TrainingPackModel pack,
  Map<String, PackReport> reports,
) =>
    reports[pack.id]?.effectiveDifficulty ?? pack.difficulty;
