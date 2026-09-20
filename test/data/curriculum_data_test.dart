// test/data/curriculum_data_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/controls/control_bindings.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/skill_model.dart';

Iterable<String> lessonTexts(SkillModel s) => [
      s.description,
      s.whyItMatters,
      ...s.instructions,
      ...s.commonMistakes,
      if (s.easierDrill != null) s.easierDrill!,
      ...s.drills.map((t) => t.text),
      ...s.masteryRequirements.map((t) => t.text),
      ...s.matchApplicationRequirements.map((t) => t.text),
    ];

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  test('every stage has skills and skill ids are unique', () {
    for (final stage in Stage.values) {
      expect(curriculum.skillsIn(stage), isNotEmpty, reason: stage.label);
    }
    final ids = curriculum.skills.map((s) => s.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('skills run in order from Beginner to SSL', () {
    final stages = curriculum.skills.map((s) => s.stage.index).toList();
    expect(stages, orderedEquals([...stages]..sort()));
  });

  test('prerequisites exist, come earlier and never sit in a later stage', () {
    final seen = <String>{};
    for (final skill in curriculum.skills) {
      for (final id in skill.prerequisites) {
        final need = curriculum.skillById(id);
        expect(need, isNotNull, reason: '${skill.id} needs unknown $id');
        expect(seen, contains(id), reason: '${skill.id} is listed before $id');
        expect(need!.stage.index, lessThanOrEqualTo(skill.stage.index),
            reason: '${skill.id} needs $id from a later stage');
      }
      seen.add(skill.id);
    }
  });

  test('every skill can be practiced, tested and applied in a match', () {
    for (final s in curriculum.skills) {
      expect(s.instructions.length, greaterThanOrEqualTo(2), reason: s.id);
      expect(s.drills, isNotEmpty, reason: s.id);
      expect(s.masteryRequirements, isNotEmpty, reason: s.id);
      expect(s.matchApplicationRequirements, isNotEmpty, reason: s.id);
    }
  });

  test('task ids are unique across the whole curriculum', () {
    final ids = [
      for (final s in curriculum.skills) ...[
        ...s.drills.map((t) => t.id),
        ...s.masteryRequirements.map((t) => t.id),
        ...s.matchApplicationRequirements.map((t) => t.id),
      ],
    ];
    expect(ids.toSet().length, ids.length);
  });

  test('every [Button] token in a lesson is a known control action', () {
    final token = RegExp(r'\[([^\[\]]+)\]');
    for (final s in curriculum.skills) {
      for (final text in lessonTexts(s)) {
        for (final m in token.allMatches(text)) {
          expect(ControlAction.fromLabel(m.group(1)!), isNotNull,
              reason: '${s.id}: unknown token ${m.group(0)}');
        }
      }
    }
  });

  test('pack links point at real packs whose codes look like codes', () {
    final code = RegExp(r'^[0-9A-F]{4}(-[0-9A-F]{4}){3}$');
    for (final s in curriculum.skills) {
      for (final id in s.trainingPackIds) {
        expect(curriculum.packById(id), isNotNull, reason: '${s.id} -> $id');
      }
    }
    for (final p in curriculum.trainingPacks) {
      expect(code.hasMatch(p.code), isTrue, reason: '${p.id}: ${p.code}');
    }
  });
}