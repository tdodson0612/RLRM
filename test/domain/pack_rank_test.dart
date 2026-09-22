// test/domain/pack_rank_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/progress_logic.dart';

void main() {
  test('a pack fits only its own rank and one rank below', () {
    bool fits(Stage pack, Stage player) => ProgressLogic.packFitsRank(pack, player);

    expect(fits(Stage.gold, Stage.gold), isTrue);
    expect(fits(Stage.silver, Stage.gold), isTrue, reason: 'one below, easy');
    expect(fits(Stage.platinum, Stage.gold), isFalse, reason: 'above, too hard');
    expect(fits(Stage.bronze, Stage.gold), isFalse, reason: 'two below, not offered');
    expect(fits(Stage.diamond, Stage.bronze), isFalse,
        reason: 'a Bronze player must never see a Diamond pack');
  });

  test('a Beginner has no rank below them, so only Beginner packs would fit',
      () {
    expect(ProgressLogic.packFitsRank(Stage.beginner, Stage.beginner), isTrue);
    expect(ProgressLogic.packFitsRank(Stage.bronze, Stage.beginner), isFalse);
  });

  test('the real curriculum has no pack above SSL players and none below '
      'Bronze players, given the current dataset', () {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    final ssl = [
      for (final p in c.trainingPacks)
        if (ProgressLogic.packFitsRank(p.difficulty, Stage.ssl)) p,
    ];
    expect(ssl, isNotEmpty);

    for (final p in c.trainingPacks) {
      expect(ProgressLogic.packFitsRank(p.difficulty, Stage.beginner), isFalse,
          reason: '${p.name} (${p.difficulty.label}) has no Beginner pack to '
              'compare against, so a Beginner sees nothing yet, by design.');
    }
  });

  test('every pack in the curriculum is ordered by rank, then by the '
      'earliest curriculum position of the skills it teaches', () {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    final position = {for (var i = 0; i < c.skills.length; i++) c.skills[i].id: i};

    int earliest(p) => p.skills
        .map((sid) => position[sid])
        .where((i) => i != null)
        .cast<int>()
        .reduce((a, b) => a < b ? a : b);

    (Stage, int) key(p) => (p.difficulty, earliest(p));

    var previous = (Stage.beginner, -1);
    for (final pack in c.trainingPacks) {
      final current = key(pack);
      final inOrder = current.$1.index > previous.$1.index ||
          (current.$1.index == previous.$1.index && current.$2 >= previous.$2);
      expect(inOrder, isTrue,
          reason: '${pack.name} is out of order relative to the previous pack');
      previous = current;
    }
  });
}