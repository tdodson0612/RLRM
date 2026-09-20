// lib/data/favorites_provider.dart

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/json_helpers.dart';
import 'preferences.dart';

/// A session the player chose to keep. It stores the skills and length, and
/// the goals and packs are worked out fresh when it is opened.
class SavedSession {
  const SavedSession({
    required this.minutes,
    required this.mode,
    required this.skillIds,
  });

  factory SavedSession.fromJson(Map<String, dynamic> json) => SavedSession(
        minutes: json['minutes'] as int,
        mode: enumByName(GameMode.values, json['mode'], 'mode'),
        skillIds: stringList(json['skillIds']),
      );

  final int minutes;
  final GameMode mode;
  final List<String> skillIds;

  String get id => '$minutes-${mode.name}-${skillIds.join(',')}';

  String get title {
    final length = switch (minutes) {
      10 => 'Quick',
      30 => 'Standard',
      _ => 'Long',
    };
    return '$length session · ${mode.label}';
  }

  Map<String, dynamic> toJson() => {
        'minutes': minutes,
        'mode': mode.name,
        'skillIds': skillIds,
      };
}

class FavoritesState {
  const FavoritesState({this.packs = const {}, this.sessions = const []});

  final Set<String> packs;
  final List<SavedSession> sessions;
}

class FavoritesNotifier extends Notifier<FavoritesState> {
  static const _key = 'favorites_v1';

  @override
  FavoritesState build() {
    final raw = ref.read(sharedPreferencesProvider)?.getString(_key);
    if (raw == null) return const FavoritesState();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return FavoritesState(
        packs: stringList(json['packs']).toSet(),
        sessions: objectList(json['sessions'], SavedSession.fromJson),
      );
    } on Object {
      return const FavoritesState(); // damaged data must never stop the app
    }
  }

  void togglePack(String packId) {
    final packs = {...state.packs};
    if (!packs.remove(packId)) packs.add(packId);
    _set(FavoritesState(packs: packs, sessions: state.sessions));
  }

  void toggleSession(SavedSession session) {
    final has = state.sessions.any((s) => s.id == session.id);
    final sessions = has
        ? [
            for (final s in state.sessions)
              if (s.id != session.id) s,
          ]
        : [...state.sessions, session];
    _set(FavoritesState(packs: state.packs, sessions: sessions));
  }

  void _set(FavoritesState next) {
    state = next;
    ref.read(sharedPreferencesProvider)?.setString(
          _key,
          jsonEncode({
            'packs': next.packs.toList()..sort(),
            'sessions': [for (final s in next.sessions) s.toJson()],
          }),
        );
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, FavoritesState>(FavoritesNotifier.new);