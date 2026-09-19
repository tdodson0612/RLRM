// lib/domain/models/stat_check.dart

import '../enums.dart';

/// A number a player can read off an in-game screen to show a skill is
/// working. It is advice, never a lock. The thresholds are coaching judgment
/// and live in the curriculum data so they can be tuned.
class StatCheck {
  const StatCheck({
    required this.screen,
    required this.metric,
    required this.minimum,
    required this.label,
    this.matches = 1,
    this.trainingPackId,
  });

  factory StatCheck.fromJson(Map<String, dynamic> json) => StatCheck(
        screen: enumByName(StatScreen.values, json['screen'], 'screen'),
        metric: enumByName(StatMetric.values, json['metric'], 'metric'),
        minimum: (json['minimum'] as num).toDouble(),
        label: json['label'] as String,
        matches: json['matches'] as int? ?? 1,
        trainingPackId: json['trainingPackId'] as String?,
      );

  final StatScreen screen;
  final StatMetric metric;

  /// The average per match to reach, or the percentage for the two % metrics.
  final double minimum;

  /// The goal in plain words, e.g. "Average 2 or more saves over 3 matches".
  final String label;

  /// How many matches to average over. Ignored for training-pack results.
  final int matches;

  /// The pack whose results screen to photograph, when [screen] needs one.
  final String? trainingPackId;

  bool isMetBy(double average) => average >= minimum;

  Map<String, dynamic> toJson() => {
        'screen': screen.name,
        'metric': metric.name,
        'minimum': minimum,
        'label': label,
        'matches': matches,
        if (trainingPackId != null) 'trainingPackId': trainingPackId,
      };
}