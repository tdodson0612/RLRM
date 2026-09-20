// test/domain/progress_logic_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/progress_model.dart';
import 'package:roadmap_for_rl/domain/progress_logic.dart';

void main() {
  late CurriculumModel c;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  final now = DateTime(2026, 9, 20);

  test('ticking boxes moves a skill forward, never back', () {
    final skill = c.skillById('driving_basics')!;
    var p = const ProgressModel(skillId: 'driving_basics');
    p = p.copyWith(completedDrills: {skill.drills.first.id});
    expect(ProgressLogic.autoStatus(skill, p), SkillStatus.practicing);

    p = p.copyWith(completedMasteryRequirements: {
      for (final t in skill.masteryRequirements) t.id,
    });
    expect(ProgressLogic.autoStatus(skill, p), SkillStatus.consistent);

    p = p.copyWith(completedApplicationRequirements: {
      for (final t in skill.matchApplicationRequirements) t.id,
    });
    expect(ProgressLogic.autoStatus(skill, p), SkillStatus.mastered);

    final manual = p.copyWith(status: SkillStatus.mastered, completedDrills: {});
    expect(ProgressLogic.autoStatus(skill, manual), SkillStatus.mastered);
  });

  test('a skill shows as locked until its prerequisites are done', () {
    final skill = c.skillById('boost_basics')!;
    SkillStatus show(Map<String, ProgressModel> progress) =>
        ProgressLogic.displayStatus(
          skill: skill,
          progress: progress[skill.id],
          prerequisitesMet: ProgressLogic.prerequisitesMet(
              skill, c, progress, Stage.beginner),
          now: now,
        );

    expect(show({}), SkillStatus.locked);
    expect(
      show({
        'driving_basics': const ProgressModel(
          skillId: 'driving_basics',
          status: SkillStatus.consistent,
        ),
      }),
      SkillStatus.notStarted,
    );
  });

  test('skills below your rank are assumed known but never hidden', () {
    final beginnerSkill = c.skillById('driving_basics')!;
    final bronzeSkill = c.skillById('basic_challenges')!;
    expect(ProgressLogic.assumedKnown(beginnerSkill, {}, Stage.silver), isTrue);
    expect(ProgressLogic.assumedKnown(beginnerSkill, {}, Stage.beginner), isFalse);
    expect(ProgressLogic.prerequisitesMet(bronzeSkill, c, {}, Stage.bronze),
        isTrue);
    expect(ProgressLogic.prerequisitesMet(bronzeSkill, c, {}, Stage.beginner),
        isFalse);
  });

  test('a mastered skill needs maintenance after its interval', () {
    final skill = c.skillById('driving_basics')!;
    ProgressModel mastered(int daysAgo) => ProgressModel(
          skillId: skill.id,
          status: SkillStatus.mastered,
          lastPracticed: now.subtract(Duration(days: daysAgo)),
        );
    expect(ProgressLogic.maintenanceDue(skill, mastered(10), now), isFalse);
    expect(ProgressLogic.maintenanceDue(skill, mastered(200), now), isTrue);
    expect(
      ProgressLogic.displayStatus(
        skill: skill,
        progress: mastered(200),
        prerequisitesMet: true,
        now: now,
      ),
      SkillStatus.maintenanceRecommended,
    );
  });

  test('the frontier moves up once most of a stage is done', () {
    final progress = {
      for (final s in c.skillsIn(Stage.bronze).where((s) => !s.optional))
        s.id: ProgressModel(skillId: s.id, status: SkillStatus.consistent),
    };
    expect(ProgressLogic.frontier(c, {}, Stage.beginner), Stage.beginner);
    expect(ProgressLogic.frontier(c, progress, Stage.beginner), Stage.bronze);
  });
}