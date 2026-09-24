// test/domain/session_generator_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/domain/models/progress_model.dart';
import 'package:roadmap_for_rl/domain/session_generator.dart';

void main() {
  late CurriculumModel c;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  const bronze = PlayerProfile(rank: Stage.bronze, onboarded: true);
  final now = DateTime(2026, 9, 20);

  TrainingSession make(
    int minutes, {
    Map<String, ProgressModel> progress = const {},
    PlayerProfile profile = bronze,
    GameMode? mode,
    bool packs = false,
  }) =>
      SessionGenerator.generate(
        curriculum: c,
        progress: progress,
        profile: profile,
        minutes: minutes,
        mode: mode,
        allowUnverifiedPacks: packs,
        now: now,
      );

  test('sessions are sized to 10, 30 and 60 minutes', () {
    final quick = make(10);
    expect(quick.name, 'Quick session');
    expect(quick.activities, hasLength(1));
    expect(quick.activities.single.minutes, 10);

    final standard = make(30);
    expect(standard.activities, hasLength(3));
    expect(standard.activities.fold<int>(0, (a, b) => a + b.minutes), 30);

    final long = make(60);
    expect(long.activities, hasLength(4));
    expect(long.activities.fold<int>(0, (a, b) => a + b.minutes), 60);
  });

  test('a skill you are practicing comes first', () {
    final progress = {
      'consistent_shooting': const ProgressModel(
        skillId: 'consistent_shooting',
        status: SkillStatus.practicing,
      ),
    };
    expect(make(30, progress: progress).activities.first.skill.id,
        'consistent_shooting');
  });

  test('repeated struggles send you back to the step before', () {
    final progress = {
      'advanced_shooting': ProgressModel(
        skillId: 'advanced_shooting',
        status: SkillStatus.practicing,
        struggleCount: 2,
        lastStruggled: now.subtract(const Duration(days: 1)),
      ),
    };
    final first = make(30, progress: progress).activities.first;
    expect(first.skill.id, 'consistent_shooting');
    expect(first.reason, contains('struggled'));
  });

  test('only skills that fit the chosen mode are used', () {
    final session = make(60, mode: GameMode.oneVsOne);
    for (final a in session.activities) {
      expect(a.skill.appliesTo(GameMode.oneVsOne), isTrue, reason: a.skill.id);
    }
    expect(session.mode, GameMode.oneVsOne);
  });

  test('a pack is used only when allowed, and never for skills without one', () {
    final progress = {
      'basic_saves': const ProgressModel(
        skillId: 'basic_saves',
        status: SkillStatus.practicing,
      ),
    };
    const silver = PlayerProfile(rank: Stage.silver, onboarded: true);
    final withPacks =
        make(10, progress: progress, profile: silver, packs: true);
    expect(withPacks.activities.first.skill.id, 'basic_saves');
    // basic_saves has two candidate packs: Novice Defender (Bronze) and
    // Basic Goalie (Silver). The pack-ordering feature places the easier
    // one first, and a Silver player's band includes both, so the easier
    // Bronze pack is the one actually offered.
    expect(withPacks.activities.first.pack?.name, 'Novice Defender');
    expect(withPacks.activities.first.method, TrainingMethod.customTraining);

    final without = make(10, progress: progress, profile: silver);
    expect(without.activities.first.pack, isNull);
    expect(without.activities.first.method, isNot(TrainingMethod.customTraining));
  });

  test('a pack above your rank band is never offered, even to a top player',
      () {
    // Basic Goalie is Silver-tagged. An SSL player is far above the one-below
    // band, so a session for them must never surface it.
    final progress = {
      'basic_saves': const ProgressModel(
        skillId: 'basic_saves',
        status: SkillStatus.practicing,
      ),
    };
    const ssl = PlayerProfile(rank: Stage.ssl, onboarded: true);
    final session = make(10, progress: progress, profile: ssl, packs: true);
    expect(session.activities.first.pack, isNull);
  });

  test('the same progress always gives the same session', () {
    List<String> ids(TrainingSession s) => [for (final a in s.activities) a.skill.id];
    expect(ids(make(60)), ids(make(60)));
  });

  test('every activity says what to do and why', () {
    for (final a in make(60).activities) {
      expect(a.goal, isNotEmpty);
      expect(a.reason, isNotEmpty);
    }
  });
}