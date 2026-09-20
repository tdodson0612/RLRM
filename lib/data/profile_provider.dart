// lib/data/profile_provider.dart

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/player_profile.dart';
import 'preferences.dart';

/// The player's rank, mode and focus, saved on the device.
class ProfileNotifier extends Notifier<PlayerProfile> {
  static const _key = 'profile_v1';

  @override
  PlayerProfile build() {
    final raw = ref.read(sharedPreferencesProvider)?.getString(_key);
    if (raw == null) return const PlayerProfile();
    try {
      return PlayerProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return const PlayerProfile(); // damaged data must never stop the app
    }
  }

  void save(PlayerProfile profile) {
    state = profile;
    ref
        .read(sharedPreferencesProvider)
        ?.setString(_key, jsonEncode(profile.toJson()));
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, PlayerProfile>(ProfileNotifier.new);