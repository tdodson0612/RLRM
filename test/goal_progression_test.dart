// test/goal_progression_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pump_chump/data/exercise_library.dart';
import 'package:pump_chump/models/exercise_progress.dart';

void main() {
  final pushUp = exerciseById('push_up');
  final plank = exerciseById('plank');

  test('a new exercise starts at its starting goal', () {
    expect(ExerciseProgress.initial(pushUp).currentGoal, 10);
    expect(ExerciseProgress.initial(plank).currentGoal, 20);
  });

  test('reaching the goal raises it by exactly 5', () {
    final update = ExerciseProgress.initial(pushUp).applyResult(10, pushUp);
    expect(update.goalReached, isTrue);
    expect(update.previousGoal, 10);
    expect(update.progress.currentGoal, 15);
  });

  test('beating the goal records the REAL number and moves up one step', () {
    const start = ExerciseProgress(exerciseId: 'push_up', currentGoal: 15);
    final update = start.applyResult(17, pushUp);
    expect(update.progress.personalBest, 17); // 17, not 15
    expect(update.progress.currentGoal, 20); // not 22
    expect(update.goalReached, isTrue);
  });

  test('missing the goal keeps the goal the same', () {
    const start = ExerciseProgress(exerciseId: 'push_up', currentGoal: 15);
    final update = start.applyResult(12, pushUp);
    expect(update.goalReached, isFalse);
    expect(update.progress.currentGoal, 15);
    expect(update.progress.personalBest, 12);
  });

  test('personal best never goes down', () {
    var progress = ExerciseProgress.initial(pushUp);
    progress = progress.applyResult(20, pushUp).progress;
    progress = progress.applyResult(8, pushUp).progress;
    expect(progress.personalBest, 20);
  });

  test('the new-personal-best flag is only true for a real record', () {
    final first = ExerciseProgress.initial(pushUp).applyResult(10, pushUp);
    expect(first.newPersonalBest, isTrue);
    final worse = first.progress.applyResult(9, pushUp);
    expect(worse.newPersonalBest, isFalse);
  });

  test('timed exercises progress in seconds', () {
    final update = ExerciseProgress.initial(plank).applyResult(20, plank);
    expect(update.progress.currentGoal, 25);
  });

  test('the goal ladder goes 10, 15, 20, 25, 30, 35, 40', () {
    var progress = ExerciseProgress.initial(pushUp);
    final goals = <int>[progress.currentGoal];
    for (var i = 0; i < 6; i++) {
      progress = progress.applyResult(progress.currentGoal, pushUp).progress;
      goals.add(progress.currentGoal);
    }
    expect(goals, [10, 15, 20, 25, 30, 35, 40]);
  });

  test('progress survives being turned into JSON and back', () {
    const original = ExerciseProgress(
      exerciseId: 'push_up',
      currentGoal: 25,
      personalBest: 27,
      timesLogged: 6,
    );
    final copy = ExerciseProgress.fromJson(original.toJson());
    expect(copy.currentGoal, 25);
    expect(copy.personalBest, 27);
    expect(copy.timesLogged, 6);
  });
}
