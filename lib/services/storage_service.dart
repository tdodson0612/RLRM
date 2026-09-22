// lib/services/storage_service.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise_progress.dart';
import '../models/reminder_settings.dart';
import '../models/workout_session.dart';

/// Saves and loads everything on the phone (no server, no account).
///
/// Data is stored as small pieces of JSON text. If saved data is ever
/// damaged, we fall back to empty defaults instead of crashing the app.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static const _progressKey = 'progress_v1';
  static const _historyKey = 'history_v1';
  static const _reminderKey = 'reminder_v1';
  static const _celebrationsKey = 'celebrations_v1';

  static Future<StorageService> create() async =>
      StorageService(await SharedPreferences.getInstance());

  // ---------------------------------------------------------- progress

  Map<String, ExerciseProgress> loadProgress() {
    final raw = _prefs.getString(_progressKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (id, value) => MapEntry(
          id,
          ExerciseProgress.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      debugPrint('Could not read saved progress: $e');
      return {};
    }
  }

  Future<void> saveProgress(Map<String, ExerciseProgress> progress) =>
      _prefs.setString(
        _progressKey,
        jsonEncode(progress.map((id, p) => MapEntry(id, p.toJson()))),
      );

  // ----------------------------------------------------------- history

  /// Oldest workout first.
  List<WorkoutSession> loadHistory() {
    final raw = _prefs.getString(_historyKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((s) => WorkoutSession.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Could not read saved history: $e');
      return [];
    }
  }

  Future<void> saveHistory(List<WorkoutSession> history) => _prefs.setString(
        _historyKey,
        jsonEncode(history.map((s) => s.toJson()).toList()),
      );

  // ---------------------------------------------------------- reminder

  ReminderSettings loadReminder() {
    final raw = _prefs.getString(_reminderKey);
    if (raw == null) return const ReminderSettings();
    try {
      return ReminderSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Could not read saved reminder: $e');
      return const ReminderSettings();
    }
  }

  Future<void> saveReminder(ReminderSettings settings) =>
      _prefs.setString(_reminderKey, jsonEncode(settings.toJson()));

  // ---------------------------------------------------------- settings

  bool loadCelebrations() => _prefs.getBool(_celebrationsKey) ?? true;

  Future<void> saveCelebrations(bool value) =>
      _prefs.setBool(_celebrationsKey, value);

  // ------------------------------------------------------------- reset

  Future<void> clearAll() async {
    await _prefs.remove(_progressKey);
    await _prefs.remove(_historyKey);
    await _prefs.remove(_reminderKey);
    await _prefs.remove(_celebrationsKey);
  }
}
