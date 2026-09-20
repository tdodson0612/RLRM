// lib/data/control_bindings_provider.dart

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/controls/control_bindings.dart';
import 'preferences.dart';

/// The saved changes to the player's buttons.
class BindingsNotifier extends Notifier<ControlBindings> {
  static const _key = 'bindings_v1';

  @override
  ControlBindings build() {
    final raw = ref.read(sharedPreferencesProvider)?.getString(_key);
    if (raw == null) return const ControlBindings();
    try {
      return ControlBindings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return const ControlBindings(); // damaged data must never stop the app
    }
  }

  void rebind(ControlAction action, String button) =>
      _set(state.rebind(action, button));

  void reset(ControlAction action) => _set(state.reset(action));

  void _set(ControlBindings bindings) {
    state = bindings;
    ref
        .read(sharedPreferencesProvider)
        ?.setString(_key, jsonEncode(bindings.toJson()));
  }
}

final bindingsStateProvider =
    NotifierProvider<BindingsNotifier, ControlBindings>(BindingsNotifier.new);

/// What lesson text reads from. Screens and tests use this one.
final controlBindingsProvider = Provider<ControlBindings>(
  (ref) => ref.watch(bindingsStateProvider),
);