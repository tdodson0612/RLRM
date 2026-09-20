// test/domain/search_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/search.dart';

void main() {
  late CurriculumModel c;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  test('flick finds the flick skills first, and the flick pack', () {
    final r = Search.run(c, 'flick');
    final ids = r.skills.map((s) => s.id).toList();
    expect(ids.take(3), containsAll(['flick_fundamentals', 'consistent_flicks', 'advanced_flicks']));
    expect(r.skills.first.name.toLowerCase(), contains('flick'));
    expect(r.packs.map((p) => p.id), contains('pack_delayed_flicks'));
  });

  test('a plural word still finds the singular', () {
    expect(Search.run(c, 'flicks').skills.first.name.toLowerCase(),
        contains('flick'));
  });

  test('categories and stages are searchable', () {
    expect(Search.run(c, 'defense').skills.map((s) => s.id),
        contains('basic_saves'));
    expect(Search.run(c, 'platinum').skills.map((s) => s.id),
        contains('fast_aerials'));
  });

  test('every word must match, and blank queries return nothing', () {
    expect(Search.run(c, 'flick zzzzzz').isEmpty, isTrue);
    expect(Search.run(c, '   ').isEmpty, isTrue);
    expect(Search.run(c, 'qqqqqq').isEmpty, isTrue);
  });

  test('related shows the steps to learn first', () {
    final r = Search.run(c, 'flick fundamentals');
    expect(r.skills.first.id, 'flick_fundamentals');
    expect(r.related.map((s) => s.id), contains('bounce_dribbling'));
  });

  test('packs can be found by creator', () {
    final r = Search.run(c, 'skogur');
    expect(r.packs.first.id, 'pack_powershot_practice');
  });
}