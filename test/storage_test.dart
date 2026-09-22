// test/storage_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pump_chump/data/exercise_library.dart';
import 'package:pump_chump/models/exercise_progress.dart';
import 'package:pump_chump/models/reminder_settings.dart';
import 'package:pump_chump/models/workout_session.dart';
import 'package:pump_chump/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('progress survives a save and a reload', () async {
    final storage = await StorageService.create();
    final pushUp = exerciseById('push_up');
    final update = ExerciseProgress.initial(pushUp).applyResult(17, pushUp);
    await storage.saveProgress({pushUp.id: update.progress});

    final reloaded = (await StorageService.create()).loadProgress();
    expect(reloaded['push_up']!.personalBest, 17);
    expect(reloaded['push_up']!.currentGoal, 15);
  });

  test('history keeps the real number, not the goal', () async {
    final storage = await StorageService.create();
    final session = WorkoutSession(
      date: DateTime(2026, 9, 21, 19, 0),
      planName: 'Upper A',
      results: const [
        ExerciseResult(exerciseId: 'push_up', goal: 15, actual: 17),
      ],
    );
    await storage.saveHistory([session]);

    final reloaded = (await StorageService.create()).loadHistory();
    expect(reloaded, hasLength(1));
    expect(reloaded.first.planName, 'Upper A');
    expect(reloaded.first.results.first.goal, 15);
    expect(reloaded.first.results.first.actual, 17);
    expect(reloaded.first.results.first.reachedGoal, isTrue);
  });

  test('reminder settings survive a save and a reload', () async {
    final storage = await StorageService.create();
    await storage.saveReminder(
      const ReminderSettings(
        enabled: true,
        hour: 6,
        minute: 30,
        weekdays: {1, 3, 5},
        title: 'Lift!',
        message: 'Go go go',
      ),
    );

    final reloaded = (await StorageService.create()).loadReminder();
    expect(reloaded.enabled, isTrue);
    expect(reloaded.hour, 6);
    expect(reloaded.minute, 30);
    expect(reloaded.weekdays, {1, 3, 5});
    expect(reloaded.title, 'Lift!');
  });

  test('empty storage gives safe defaults', () async {
    final storage = await StorageService.create();
    expect(storage.loadProgress(), isEmpty);
    expect(storage.loadHistory(), isEmpty);
    expect(storage.loadReminder().enabled, isFalse);
    expect(storage.loadCelebrations(), isTrue);
  });

  test('damaged saved data does not crash the app', () async {
    SharedPreferences.setMockInitialValues({
      'progress_v1': 'not json at all',
      'history_v1': '{{{',
      'reminder_v1': '[]',
    });
    final storage = await StorageService.create();
    expect(storage.loadProgress(), isEmpty);
    expect(storage.loadHistory(), isEmpty);
    expect(storage.loadReminder().enabled, isFalse);
  });

  test('clearAll wipes everything', () async {
    final storage = await StorageService.create();
    await storage.saveReminder(const ReminderSettings(enabled: true));
    await storage.saveCelebrations(false);
    await storage.clearAll();
    expect(storage.loadReminder().enabled, isFalse);
    expect(storage.loadCelebrations(), isTrue);
  });
}
