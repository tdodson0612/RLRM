// test/data/progress_provider_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/data/control_bindings_provider.dart';
import 'package:roadmap_for_rl/data/preferences.dart';
import 'package:roadmap_for_rl/data/profile_provider.dart';
import 'package:roadmap_for_rl/data/progress_provider.dart';
import 'package:roadmap_for_rl/domain/controls/control_bindings.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CurriculumModel c;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    c = CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Future<ProviderContainer> open(Map<String, Object> saved) async {
    SharedPreferences.setMockInitialValues(saved);
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('ticking a drill starts a skill and is saved on the device', () async {
    final first = await open({});
    final skill = c.skillById('driving_basics')!;
    first
        .read(progressProvider.notifier)
        .toggleTask(skill, TaskKind.drill, skill.drills.first.id);
    expect(first.read(progressProvider)['driving_basics']!.status,
        SkillStatus.practicing);

    // A brand new container reading the same storage sees the same progress.
    final prefs = first.read(sharedPreferencesProvider)!;
    final second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);
    final saved = second.read(progressProvider)['driving_basics']!;
    expect(saved.status, SkillStatus.practicing);
    expect(saved.completedDrills, {skill.drills.first.id});
  });

  test('I already know this fills in the matching checks', () async {
    final container = await open({});
    final skill = c.skillById('boost_basics')!;
    container.read(progressProvider.notifier).markKnown(skill, SkillStatus.mastered);
    final p = container.read(progressProvider)['boost_basics']!;
    expect(p.status, SkillStatus.mastered);
    expect(p.completedMasteryRequirements, hasLength(skill.masteryRequirements.length));
    expect(p.completedApplicationRequirements,
        hasLength(skill.matchApplicationRequirements.length));
  });

  test("I'm struggling is counted and starts the skill", () async {
    final container = await open({});
    final notifier = container.read(progressProvider.notifier);
    notifier.recordStruggle('driving_basics');
    notifier.recordStruggle('driving_basics');
    final p = container.read(progressProvider)['driving_basics']!;
    expect(p.struggleCount, 2);
    expect(p.lastStruggled, isNotNull);
    expect(p.status, SkillStatus.practicing);
  });

  test('logging practice records the date and a log entry', () async {
    final container = await open({});
    container.read(progressProvider.notifier).logPractice('driving_basics', 10);
    expect(container.read(progressProvider)['driving_basics']!.lastPracticed,
        isNotNull);
    expect(container.read(practiceLogProvider).single.minutes, 10);
  });

  test('reset clears progress and the practice log', () async {
    final container = await open({});
    final notifier = container.read(progressProvider.notifier);
    notifier.logPractice('driving_basics', 10);
    notifier.resetAll();
    expect(container.read(progressProvider), isEmpty);
    expect(container.read(practiceLogProvider), isEmpty);
  });

  test('damaged saved data never stops the app opening', () async {
    final container = await open({
      'progress_v1': 'this is not json',
      'practice_log_v1': '{"oops"',
      'profile_v1': '[]',
      'bindings_v1': '42',
    });
    expect(container.read(progressProvider), isEmpty);
    expect(container.read(practiceLogProvider), isEmpty);
    expect(container.read(profileProvider).onboarded, isFalse);
    expect(container.read(controlBindingsProvider)
        .buttonFor(ControlAction.boost), 'Circle');
  });

  test('profile and button changes are saved too', () async {
    final first = await open({});
    first.read(profileProvider.notifier).save(const PlayerProfile(
          rank: Stage.gold,
          mode: GameMode.twoVsTwo,
          focus: {SkillCategory.defense},
          onboarded: true,
        ));
    first.read(bindingsStateProvider.notifier).rebind(ControlAction.boost, 'R1');

    final prefs = first.read(sharedPreferencesProvider)!;
    final second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);
    final profile = second.read(profileProvider);
    expect(profile.rank, Stage.gold);
    expect(profile.mode, GameMode.twoVsTwo);
    expect(profile.focus, {SkillCategory.defense});
    expect(profile.onboarded, isTrue);
    expect(second.read(controlBindingsProvider).resolve('[Boost]'), 'R1');
  });
}