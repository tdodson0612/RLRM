// lib/models/workout_day.dart

/// One day of the weekly plan (a training day or a rest day).
class WorkoutDay {
  const WorkoutDay({
    required this.weekday,
    required this.name,
    required this.focus,
    required this.exerciseIds,
  });

  /// 1 = Monday ... 7 = Sunday (the same numbers as DateTime.weekday).
  final int weekday;

  /// Short name, for example "Upper A".
  final String name;

  /// Plain-English description of what the day trains.
  final String focus;

  /// Ids from the exercise library, in workout order. Empty on rest days.
  final List<String> exerciseIds;

  bool get isRest => exerciseIds.isEmpty;
}
