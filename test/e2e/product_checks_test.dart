// test/e2e/product_checks_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/domain/models/progress_model.dart';
import 'package:roadmap_for_rl/domain/progress_logic.dart';
import 'package:roadmap_for_rl/domain/session_generator.dart';

/// The four final questions from the brief, asked of the real curriculum.
void main() {
  late CurriculumModel c;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  const bronze = PlayerProfile(rank: Stage.bronze, onboarded: true);

  test('1. a Bronze player who has no idea gets a clear answer', () {
    final recs = SessionGenerator.recommend(
      curriculum: c,
      progress: const {},
      profile: bronze,
    );
    expect(recs, isNotEmpty);
    final top = recs.first;
    expect(top.skill.name, isNotEmpty);
    expect(top.reason, isNotEmpty, reason: 'the app must say why');
    expect(top.skill.instructions, isNotEmpty, reason: 'and how');
  });

  test('2. thirty minutes says what, how, where, success and what next', () {
    final session = SessionGenerator.generate(
      curriculum: c,
      progress: const {},
      profile: bronze,
      minutes: 30,
      allowUnverifiedPacks: true,
    );
    expect(session.activities, hasLength(3));
    expect(session.activities.fold<int>(0, (a, b) => a + b.minutes), 30);
    for (final a in session.activities) {
      expect(a.skill.name, isNotEmpty, reason: 'what to practice');
      expect(a.skill.instructions, isNotEmpty, reason: 'how to practice it');
      expect(a.goal, isNotEmpty, reason: 'today\'s goal');
      expect(a.method.label, isNotEmpty, reason: 'where to practice');
      expect(a.skill.masteryRequirements, isNotEmpty,
          reason: 'what success looks like');
      expect(a.skill.matchApplicationRequirements, isNotEmpty,
          reason: 'how to use it in a match');
      expect(a.skill.whatItUnlocks, isNotEmpty, reason: 'what comes after');
      expect(a.reason, isNotEmpty, reason: 'why it was chosen');
    }
  });

  test('3. a player can skip ahead without breaking the curriculum', () {
    // Mark every Gold skill mastered with none of the steps before them done.
    final progress = {
      for (final s in c.skillsIn(Stage.gold))
        s.id: ProgressModel(
          skillId: s.id,
          status: SkillStatus.mastered,
          lastPracticed: DateTime.now(),
        ),
    };
    for (final minutes in [10, 30, 60]) {
      final session = SessionGenerator.generate(
        curriculum: c,
        progress: progress,
        profile: bronze,
        minutes: minutes,
      );
      expect(session.activities, isNotEmpty, reason: '$minutes minutes');
    }
    // The steps before those skills are still visible and still not done.
    final skipped = c.skillById('advanced_shooting')!;
    for (final id in skipped.prerequisites) {
      expect(c.skillById(id), isNotNull);
      expect(ProgressLogic.statusOf(progress, id), SkillStatus.notStarted);
    }
  });

  test('3b. every rank and mode still gets a session of every length', () {
    for (final rank in Stage.values) {
      for (final mode in GameMode.values) {
        for (final minutes in [10, 30, 60]) {
          final session = SessionGenerator.generate(
            curriculum: c,
            progress: const {},
            profile: PlayerProfile(rank: rank, mode: mode, onboarded: true),
            minutes: minutes,
          );
          expect(session.activities, isNotEmpty,
              reason: '${rank.label} / ${mode.label} / $minutes min');
        }
      }
    }
  });

  test('4. the curriculum teaches match use, not just mechanics', () {
    for (final s in c.skills) {
      expect(s.matchApplicationRequirements, isNotEmpty, reason: s.id);
      final mechanical = {for (final t in s.masteryRequirements) t.text};
      for (final t in s.matchApplicationRequirements) {
        expect(mechanical.contains(t.text), isFalse,
            reason: '${s.id} repeats a mechanical check as a match check');
      }
    }
  });

  test('4b. doing the mechanics alone never counts as mastered', () {
    final skill = c.skillById('consistent_shooting')!;
    final mechanicsOnly = ProgressModel(
      skillId: skill.id,
      completedDrills: {for (final t in skill.drills) t.id},
      completedMasteryRequirements: {
        for (final t in skill.masteryRequirements) t.id,
      },
    );
    expect(ProgressLogic.autoStatus(skill, mechanicsOnly),
        SkillStatus.consistent);

    final withMatch = mechanicsOnly.copyWith(
      completedApplicationRequirements: {
        for (final t in skill.matchApplicationRequirements) t.id,
      },
    );
    expect(ProgressLogic.autoStatus(skill, withMatch), SkillStatus.mastered);
  });
}