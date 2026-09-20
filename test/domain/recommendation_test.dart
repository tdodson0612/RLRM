// test/domain/recommendation_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/domain/session_generator.dart';

void main() {
  late CurriculumModel c;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  List<SkillRecommendation> recs(PlayerProfile profile) =>
      SessionGenerator.recommend(
        curriculum: c,
        progress: const {},
        profile: profile,
        now: DateTime(2026, 9, 20),
      );

  test('a brand new Beginner is told to start with driving', () {
    final list = recs(const PlayerProfile());
    expect(list.first.skill.id, 'driving_basics');
    expect(list.first.reason, isNotEmpty);
  });

  test('recommendations come best-first', () {
    final list = recs(const PlayerProfile(rank: Stage.bronze));
    for (var i = 1; i < list.length; i++) {
      expect(list[i - 1].score, greaterThanOrEqualTo(list[i].score));
    }
  });

  test('a Gold player is not sent back to Beginner basics', () {
    final list = recs(const PlayerProfile(rank: Stage.gold));
    expect(list, isNotEmpty);
    expect(list.first.skill.stage.index, greaterThanOrEqualTo(Stage.gold.index));
  });

  test('a saved session is rebuilt for the same skills', () {
    final session = SessionGenerator.fromSkills(
      curriculum: c,
      progress: const {},
      minutes: 30,
      mode: GameMode.all,
      skillIds: ['basic_shooting', 'nope', 'ball_contact'],
    );
    expect(session.activities.map((a) => a.skill.id),
        ['basic_shooting', 'ball_contact']);
    expect(session.activities.first.minutes, 15);
    expect(session.activities.first.reason, 'From your saved session.');
  });
}