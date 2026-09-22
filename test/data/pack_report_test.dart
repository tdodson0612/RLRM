// test/data/pack_report_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/data/pack_report_mail.dart';
import 'package:roadmap_for_rl/data/pack_report_provider.dart';
import 'package:roadmap_for_rl/data/preferences.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/domain/models/training_pack_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

TrainingPackModel pack(Stage difficulty) => TrainingPackModel(
      id: 'pack_x',
      name: 'Pack X',
      code: 'AAAA-BBBB-CCCC-DDDD',
      description: 'Test pack.',
      categories: const [],
      skills: const ['some_skill'],
      applicableModes: const [],
      difficulty: difficulty,
      source: 'test',
    );

Future<ProviderContainer> open([Map<String, Object> saved = const {}]) async {
  SharedPreferences.setMockInitialValues(saved);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  return container;
}

void main() {
  test('too hard shifts the effective difficulty up one stage', () async {
    final c = await open();
    addTearDown(c.dispose);
    final p = pack(Stage.bronze);
    c.read(packReportsProvider.notifier).report(p, ReportKind.tooHard);
    expect(effectiveDifficulty(p, c.read(packReportsProvider)), Stage.silver);
  });

  test('too easy shifts the effective difficulty down one stage', () async {
    final c = await open();
    addTearDown(c.dispose);
    final p = pack(Stage.silver);
    c.read(packReportsProvider.notifier).report(p, ReportKind.tooEasy);
    expect(effectiveDifficulty(p, c.read(packReportsProvider)), Stage.bronze);
  });

  test('the shift clamps at the top and bottom of the scale', () async {
    final c = await open();
    addTearDown(c.dispose);
    c.read(packReportsProvider.notifier).report(pack(Stage.ssl), ReportKind.tooHard);
    expect(effectiveDifficulty(pack(Stage.ssl), c.read(packReportsProvider)),
        Stage.ssl);
    c.read(packReportsProvider.notifier)
        .report(pack(Stage.beginner), ReportKind.tooEasy);
    expect(
        effectiveDifficulty(pack(Stage.beginner), c.read(packReportsProvider)),
        Stage.beginner);
  });

  test('undo removes the report and restores the listed difficulty',
      () async {
    final c = await open();
    addTearDown(c.dispose);
    final p = pack(Stage.gold);
    c.read(packReportsProvider.notifier).report(p, ReportKind.tooHard);
    expect(effectiveDifficulty(p, c.read(packReportsProvider)), Stage.platinum);
    c.read(packReportsProvider.notifier).undo(p.id);
    expect(effectiveDifficulty(p, c.read(packReportsProvider)), Stage.gold);
  });

  test('a report survives a restart, kept only on this device', () async {
    final first = await open();
    addTearDown(first.dispose);
    first.read(packReportsProvider.notifier).report(pack(Stage.gold), ReportKind.tooEasy);

    final prefs = first.read(sharedPreferencesProvider)!;
    final second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);
    expect(second.read(packReportsProvider)['pack_x']?.kind, ReportKind.tooEasy);
  });

  test('damaged saved reports never stop the app opening', () async {
    final c = await open({'pack_reports_v1': 'not json'});
    addTearDown(c.dispose);
    expect(c.read(packReportsProvider), isEmpty);
  });

  test('the mailto draft names the pack, the issue and the rank, and is '
      'addressed to the developer', () {
    const profile = PlayerProfile(rank: Stage.gold, onboarded: true);
    final uri = packReportMailto(
      pack: pack(Stage.bronze),
      kind: ReportKind.tooHard,
      profile: profile,
    );
    expect(uri.scheme, 'mailto');
    expect(uri.path, developerEmail);
    final body = Uri.decodeComponent(uri.queryParameters['body']!);
    expect(body, contains('Pack X'));
    expect(body, contains('AAAA-BBBB-CCCC-DDDD'));
    expect(body, contains('too hard'));
    expect(body, contains('Gold'));
  });
}
