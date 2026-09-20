// lib/data/preferences.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The on-device store for progress and settings. `main` provides the real
/// one. Tests leave it null, and everything then works in memory only.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);