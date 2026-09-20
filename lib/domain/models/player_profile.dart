// lib/domain/models/player_profile.dart

import '../enums.dart';
import '../json_helpers.dart';

/// What the player told us about themselves. No account, saved on the device.
class PlayerProfile {
  const PlayerProfile({
    this.rank = Stage.beginner,
    this.mode = GameMode.all,
    this.focus = const {},
    this.nickname = '',
    this.onboarded = false,
  });

  factory PlayerProfile.fromJson(Map<String, dynamic> json) => PlayerProfile(
        rank: enumByName(Stage.values, json['rank'] ?? 'beginner', 'rank'),
        mode: enumByName(GameMode.values, json['mode'] ?? 'all', 'mode'),
        focus: enumList(SkillCategory.values, json['focus'], 'focus').toSet(),
        nickname: json['nickname'] as String? ?? '',
        onboarded: json['onboarded'] as bool? ?? false,
      );

  /// A starting point for recommendations, not a claim about real rank.
  final Stage rank;
  final GameMode mode;

  /// Areas to lean toward. Empty means "everything".
  final Set<SkillCategory> focus;
  final String nickname;
  final bool onboarded;

  PlayerProfile copyWith({
    Stage? rank,
    GameMode? mode,
    Set<SkillCategory>? focus,
    String? nickname,
    bool? onboarded,
  }) =>
      PlayerProfile(
        rank: rank ?? this.rank,
        mode: mode ?? this.mode,
        focus: focus ?? this.focus,
        nickname: nickname ?? this.nickname,
        onboarded: onboarded ?? this.onboarded,
      );

  Map<String, dynamic> toJson() => {
        'rank': rank.name,
        'mode': mode.name,
        'focus': [for (final c in focus) c.name],
        'nickname': nickname,
        'onboarded': onboarded,
      };
}