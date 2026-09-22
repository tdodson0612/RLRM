// lib/services/app_state.dart

import 'package:flutter/widgets.dart';

import '../data/weekly_plan.dart';
import '../models/exercise.dart';
import '../models/exercise_progress.dart';
import '../models/reminder_settings.dart';
import '../models/workout_day.dart';
import '../models/workout_session.dart';
import 'formatters.dart';
import 'notification_service.dart';
import 'storage_service.dart';

/// The one place that holds the app's data. Screens read from it, and when
/// something changes it calls notifyListeners() so the screens redraw.
class AppState extends ChangeNotifier {
  AppState(this._storage, this._notifications) {
    _progress = _storage.loadProgress();
    _history = _storage.loadHistory();
    _reminder = _storage.loadReminder();
    _celebrations = _storage.loadCelebrations();
  }

  /// Loads saved data and re-schedules reminders. Call once at app start.
  static Future<AppState> load() async {
    final storage = await StorageService.create();
    final state = AppState(storage, NotificationService());
    if (state._reminder.enabled) {
      await state._notifications.syncReminders(state._reminder);
    }
    return state;
  }

  final StorageService _storage;
  final NotificationService _notifications;

  late Map<String, ExerciseProgress> _progress;
  late List<WorkoutSession> _history; // oldest first
  late ReminderSettings _reminder;
  late bool _celebrations;

  // ------------------------------------------------------------ reading

  ReminderSettings get reminder => _reminder;
  bool get celebrations => _celebrations;

  /// Newest workout first.
  List<WorkoutSession> get history => _history.reversed.toList();

  int get workoutsCompleted => _history.length;

  WorkoutDay get today => planForWeekday(DateTime.now().weekday);

  bool get workedOutToday {
    final now = DateTime.now();
    return _history.any((s) => isSameDay(s.date, now));
  }

  int get workoutsThisWeek {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    return _history.where((s) => !s.date.isBefore(monday)).length;
  }

  /// The next day (after today) that has a workout.
  WorkoutDay? get nextTrainingDay {
    final now = DateTime.now();
    for (var i = 1; i <= 7; i++) {
      final day = planForWeekday((now.weekday - 1 + i) % 7 + 1);
      if (!day.isRest) return day;
    }
    return null;
  }

  ExerciseProgress progressFor(Exercise exercise) =>
      _progress[exercise.id] ?? ExerciseProgress.initial(exercise);

  // ------------------------------------------------------------ writing

  /// Records what the user really did. The goal moves up if they reached it.
  Future<GoalUpdate> logResult(Exercise exercise, int actual) async {
    final update = progressFor(exercise).applyResult(actual, exercise);
    _progress[exercise.id] = update.progress;
    notifyListeners();
    await _storage.saveProgress(_progress);
    return update;
  }

  /// Saves a finished (or ended-early) workout to history.
  Future<void> saveSession(
    WorkoutDay day,
    List<ExerciseResult> results,
  ) async {
    if (results.isEmpty) return;
    _history.add(
      WorkoutSession(
        date: DateTime.now(),
        planName: day.name,
        results: List.of(results),
      ),
    );
    notifyListeners();
    await _storage.saveHistory(_history);
  }

  /// Saves new reminder settings and re-schedules the notifications.
  /// Returns false if the phone refused notification permission.
  Future<bool> updateReminder(ReminderSettings next) async {
    var settings = next;
    var allowed = true;
    if (next.enabled && !_reminder.enabled) {
      allowed = await _notifications.requestPermission();
      if (!allowed) settings = next.copyWith(enabled: false);
    }
    _reminder = settings;
    notifyListeners();
    await _storage.saveReminder(settings);
    await _notifications.syncReminders(settings);
    return allowed;
  }

  Future<void> sendTestNotification() async {
    await _notifications.requestPermission();
    await _notifications.showTest();
  }

  Future<void> setCelebrations(bool value) async {
    _celebrations = value;
    notifyListeners();
    await _storage.saveCelebrations(value);
  }

  Future<void> resetAll() async {
    await _storage.clearAll();
    await _notifications.cancelAll();
    _progress = {};
    _history = [];
    _reminder = const ReminderSettings();
    _celebrations = true;
    notifyListeners();
  }
}

/// Makes the AppState available to every screen:
///   final state = AppScope.of(context);
/// Screens that call this redraw automatically when the data changes.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found above this widget.');
    return scope!.notifier!;
  }
}
