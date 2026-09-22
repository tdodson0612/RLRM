// test/weekly_plan_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pump_chump/data/exercise_library.dart';
import 'package:pump_chump/data/weekly_plan.dart';
import 'package:pump_chump/models/exercise.dart';

void main() {
  test('the plan covers Monday to Sunday exactly once', () {
    expect(weeklyPlan.map((d) => d.weekday).toList(), [1, 2, 3, 4, 5, 6, 7]);
  });

  test('there are at least two rest days', () {
    expect(weeklyPlan.where((d) => d.isRest).length, greaterThanOrEqualTo(2));
  });

  test('every planned exercise exists in the library', () {
    for (final day in weeklyPlan) {
      for (final id in day.exerciseIds) {
        expect(findExercise(id), isNotNull, reason: '$id (${day.name})');
      }
    }
  });

  test('every library exercise is used somewhere in the plan', () {
    final planned = {for (final day in weeklyPlan) ...day.exerciseIds};
    for (final exercise in exerciseLibrary) {
      expect(planned, contains(exercise.id));
    }
  });

  test('exercise ids are unique', () {
    final ids = exerciseLibrary.map((e) => e.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('no exercise appears twice on the same day', () {
    for (final day in weeklyPlan) {
      expect(day.exerciseIds.toSet().length, day.exerciseIds.length);
    }
  });

  test('upper and lower body are each trained twice a week', () {
    expect(weeklyPlan.where((d) => d.name.startsWith('Upper')).length, 2);
    expect(weeklyPlan.where((d) => d.name.startsWith('Lower')).length, 2);
  });

  test('back-to-back days never train the same big muscle areas', () {
    Set<BodyRegion> regionsFor(int weekday) => planForWeekday(weekday)
        .exerciseIds
        .map((id) => exerciseById(id).region)
        .toSet()
      ..removeAll({BodyRegion.core, BodyRegion.fullBody});

    for (var weekday = 1; weekday <= 7; weekday++) {
      final next = weekday == 7 ? 1 : weekday + 1;
      final overlap = regionsFor(weekday).intersection(regionsFor(next));
      expect(overlap, isEmpty, reason: 'day $weekday and day $next overlap');
    }
  });

  test('every exercise has usable goals and text', () {
    for (final e in exerciseLibrary) {
      expect(e.name, isNotEmpty);
      expect(e.instructions, isNotEmpty);
      expect(e.targetMuscles, isNotEmpty);
      expect(e.startingGoal, greaterThan(0));
      expect(e.progressionAmount, 5);
    }
  });

  test('no exercise instructions call for equipment', () {
    final equipment = RegExp(
      r'\b(dumbbells?|barbells?|kettlebells?|bench|chair|towel|resistance band|machine|pull-up bar)\b',
      caseSensitive: false,
    );
    for (final e in exerciseLibrary) {
      expect(equipment.hasMatch(e.instructions), isFalse, reason: e.name);
    }
  });
}
