// test/domain/maintenance_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/data/preferences.dart';
import 'package:roadmap_for_rl/data/progress_provider.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/domain/models/progress_model.dart';
import 'package:roadmap_for_rl/domain/progress_logic.dart';
import 'package:roadmap_for_rl/domain/session_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CurriculumModel c;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  final now = DateTime(2026, 9, 20);
  const bronze = PlayerProfile(rank: Stage.bronze, onboarded: true);

  ProgressModel mastered(String id, int daysAgo) => ProgressModel(
        skillId: id,
        status: SkillStatus.mastered,
        lastPracticed: now.subtract(Duration(days: daysAgo)),
      );

  List<SkillRecommendation> recs(Map<String, ProgressModel> progress) =>
      SessionGenerator.recommend(
        curriculum: c,
        progress: progress,
        profile: bronze,
        now: now,
      );

  TrainingSession make(int minutes, Map<String, ProgressModel> progress) =>
      SessionGenerator.generate(
        curriculum: c,
        progress: progress,
        profile: bronze,
        minutes: minutes,
        now: now,
      );

  test('an overdue mastered skill is recommended as maintenance', () {
    final rec = recs({'driving_basics': mastered('driving_basics', 200)})
        .firstWhere((r) => r.skill.id == 'driving_basics');
    expect(rec.isMaintenance, isTrue);
    expect(rec.reason, contains('Maintenance'));
    expect(rec.reason, contains('200 days'));
  });

  test('a recently practiced mastered skill is left alone', () {
    final list = recs({'driving_basics': mastered('driving_basics', 10)});
    expect(list.any((r) => r.skill.id == 'driving_basics'), isFalse);
  });

  test('skills that others build on are refreshed first', () {
    final list = recs({
      'ball_contact': mastered('ball_contact', 200),
      'basic_shooting': mastered('basic_shooting', 200),
    });
    final ids = list.map((r) => r.skill.id).toList();
    expect(ids.indexOf('ball_contact'), lessThan(ids.indexOf('basic_shooting')));
  });

  test('Standard and Long sessions keep a slot for a refresh, Quick does not',
      () {
    final progress = {'driving_basics': mastered('driving_basics', 200)};

    for (final minutes in [30, 60]) {
      final refresh = make(minutes, progress)
          .activities
          .where((a) => a.skill.id == 'driving_basics')
          .toList();
      expect(refresh, hasLength(1), reason: '$minutes minute session');
      expect(refresh.single.reason, contains('Maintenance'));
    }
    expect(make(10, progress).activities.single.skill.id,
        isNot('driving_basics'));
  });

  test('logging practice clears the refresh flag and keeps the mastery',
      () async {
    final old = DateTime.now().subtract(const Duration(days: 200));
    SharedPreferences.setMockInitialValues({
      'progress_v1': jsonEncode([
        ProgressModel(
          skillId: 'driving_basics',
          status: SkillStatus.mastered,
          lastPracticed: old,
        ).toJson(),
      ]),
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    final skill = c.skillById('driving_basics')!;
    bool due() => ProgressLogic.maintenanceDue(
          skill,
          container.read(progressProvider)['driving_basics'],
          DateTime.now(),
        );

    expect(due(), isTrue);
    container.read(progressProvider.notifier).logPractice('driving_basics', 5);
    expect(due(), isFalse);
    expect(container.read(progressProvider)['driving_basics']!.status,
        SkillStatus.mastered);
  });
}