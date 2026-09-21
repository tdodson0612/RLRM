// lib/data/theme_mode_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'preferences.dart';

/// Dark, light or follow the phone. Dark is the default look.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode_v1';

  @override
  ThemeMode build() {
    final saved = ref.read(sharedPreferencesProvider)?.getString(_key);
    for (final mode in ThemeMode.values) {
      if (mode.name == saved) return mode;
    }
    return ThemeMode.dark;
  }

  void choose(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider)?.setString(_key, mode.name);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);