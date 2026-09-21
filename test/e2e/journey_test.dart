// test/e2e/journey_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/app.dart';
import 'package:roadmap_for_rl/data/control_bindings_provider.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/favorites_provider.dart';
import 'package:roadmap_for_rl/data/preferences.dart';
import 'package:roadmap_for_rl/data/profile_provider.dart';
import 'package:roadmap_for_rl/data/progress_provider.dart';
import 'package:roadmap_for_rl/data/theme_mode_provider.dart';
import 'package:roadmap_for_rl/domain/controls/control_bindings.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/domain/session_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_utils.dart';

/// Walks through the real app the way a player would: real curriculum, real
/// screens, real saving. Each test is one journey from your checklist.
void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Future<SharedPreferences> storage([Map<String, Object> saved = const {}]) {
    SharedPreferences.setMockInitialValues({...saved});
    return SharedPreferences.getInstance();
  }

  /// A player who has finished setup as Bronze.
  Map<String, Object> bronze({GameMode mode = GameMode.all}) => {
        'profile_v1': jsonEncode(
          PlayerProfile(rank: Stage.bronze, mode: mode, onboarded: true)
              .toJson(),
        ),
      };

  /// Opens the app. A new key means a brand new app start, reading whatever
  /// was saved on the phone.
  Future<ProviderContainer> launch(
      WidgetTester tester, SharedPreferences prefs) async {
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          curriculumProvider.overrideWith((ref) => curriculum),
        ],
        child: const RoadmapApp(),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> runOnboarding(
    WidgetTester tester, {
    required String rank,
    required String mode,
    String? focus,
  }) async {
    await tapText(tester, 'Get started');
    await tapText(tester, rank);
    await tapText(tester, 'Next');
    await tapText(tester, mode);
    await tapText(tester, 'Next');
    if (focus != null) await tapText(tester, focus);
    await tapText(tester, 'Build my roadmap');
  }

  testWidgets('first launch: setup, then a clear first step on one screen',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844); // a normal phone
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final prefs = await storage();
    final container = await launch(tester, prefs);

    expect(find.text('Welcome to RLRM.'), findsOneWidget);
    await runOnboarding(tester, rank: 'Bronze', mode: '1v1', focus: 'Defense');

    final profile = container.read(profileProvider);
    expect(profile.rank, Stage.bronze);
    expect(profile.mode, GameMode.oneVsOne);
    expect(profile.focus, {SkillCategory.defense});

    // Home answers "what should I practice next, and why?" without scrolling.
    expect(find.text('Current stage: Bronze'), findsOneWidget);
    expect(find.text("Today's training"), findsOneWidget);
    expect(find.text('Recommended next'), findsOneWidget);
    expect(find.textContaining('Why:'), findsOneWidget);
    expect(tester.getRect(find.text('Recommended next')).bottom, lessThan(844));

    final recs = SessionGenerator.recommend(
      curriculum: curriculum,
      progress: const {},
      profile: profile,
    );
    for (final rec in recs.take(3)) {
      expect(find.text(rec.skill.name), findsWidgets);
    }
  });

  testWidgets('a lesson: tick a step, log practice, see it on Home and Progress',
      (tester) async {
    useTallScreen(tester);
    final prefs = await storage(bronze());
    final container = await launch(tester, prefs);
    final next = SessionGenerator.recommend(
      curriculum: curriculum,
      progress: const {},
      profile: container.read(profileProvider),
    ).firstWhere((r) => !r.isMaintenance).skill;

    await tapText(tester, 'Start training');
    expect(find.text(next.name), findsWidgets);
    expect(find.text('Not Started'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('Practicing'), findsOneWidget);

    await tapText(tester, 'I practiced this');
    expect(find.text('Practice logged.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('You are already practicing this.'), findsOneWidget);
    await openTab(tester, 'Progress');
    expect(
      find.text('This week: ${next.estimatedMinutes} minutes in 1 sessions'),
      findsOneWidget,
    );
  });

  testWidgets('a session: what to do, mark it done, save it, open it again',
      (tester) async {
    useTallScreen(tester);
    final prefs = await storage(bronze());
    final container = await launch(tester, prefs);

    await openTab(tester, 'Training');
    await tapText(tester, 'Standard · 30 min');
    expect(find.text('Standard session'), findsOneWidget);
    expect(find.textContaining('Goal:'), findsNWidgets(3));
    expect(find.textContaining('Why:'), findsNWidgets(3));
    expect(find.byType(Checkbox), findsNWidgets(3));

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(container.read(practiceLogProvider), hasLength(1));

    await tester.tap(find.byTooltip('Save this session'));
    await tester.pumpAndSettle();
    final saved = container.read(favoritesProvider).sessions.single;
    expect(saved.skillIds, hasLength(3));

    await tester.pageBack();
    await tester.pumpAndSettle();
    await openTab(tester, 'Home');
    await tester.tap(find.byTooltip('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Standard session · All'), findsOneWidget);

    await tapText(tester, 'Standard session · All');
    expect(find.text('Standard session'), findsOneWidget);
    expect(find.text(curriculum.skillById(saved.skillIds.first)!.name),
        findsWidgets);
  });

  testWidgets('settings: dark and light, your own buttons, and reset',
      (tester) async {
    useTallScreen(tester);
    final prefs = await storage(bronze());
    final container = await launch(tester, prefs);
    ThemeMode theme() =>
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;

    await openTab(tester, 'Settings');
    await tapText(tester, 'Light');
    expect(theme(), ThemeMode.light);
    await tapText(tester, 'Dark');
    expect(theme(), ThemeMode.dark);

    // Change the Boost button, and see lessons use it.
    await tapText(tester, 'Controls');
    await tapText(tester, 'Boost');
    await tester.enterText(find.byType(TextField), 'R1');
    await tapText(tester, 'Save');
    expect(container.read(controlBindingsProvider).buttonFor(ControlAction.boost),
        'R1');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await openTab(tester, 'Roadmap');
    await tapText(tester, 'BEGINNER');
    await tapText(tester, 'Boost Basics');
    expect(find.textContaining('Using R1 to go faster'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Reset clears progress but keeps the profile and buttons.
    container.read(progressProvider.notifier).setStatus(
        'driving_basics', SkillStatus.practicing);
    await openTab(tester, 'Settings');
    await tapText(tester, 'Reset progress');
    expect(find.text('Reset all progress?'), findsOneWidget);
    await tapText(tester, 'Reset');
    expect(container.read(progressProvider), isEmpty);
    expect(container.read(profileProvider).rank, Stage.bronze);
    expect(container.read(controlBindingsProvider).resolve('[Boost]'), 'R1');
  });

  testWidgets('closing and reopening the app keeps everything', (tester) async {
    useTallScreen(tester);
    final prefs = await storage();
    final first = await launch(tester, prefs);
    await runOnboarding(tester, rank: 'Silver', mode: '3v3');

    first.read(progressProvider.notifier)
      ..logPractice('driving_basics', 10)
      ..toggleFavorite('flick_fundamentals');
    first.read(favoritesProvider.notifier).togglePack('pack_easy_goals');
    first.read(bindingsStateProvider.notifier)
        .rebind(ControlAction.boost, 'R1');
    first.read(themeModeProvider.notifier).choose(ThemeMode.light);
    await tester.pumpAndSettle();

    // A brand new app start, reading only what was saved on the phone.
    final again = await launch(tester, prefs);
    expect(find.text('Welcome to RLRM.'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(again.read(profileProvider).rank, Stage.silver);
    expect(again.read(profileProvider).mode, GameMode.threeVsThree);
    expect(again.read(progressProvider)['driving_basics']?.lastPracticed,
        isNotNull);
    expect(again.read(progressProvider)['flick_fundamentals']?.favorite, isTrue);
    expect(again.read(favoritesProvider).packs, {'pack_easy_goals'});
    expect(again.read(controlBindingsProvider).resolve('[Boost]'), 'R1');
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.light);
  });

  testWidgets('skipping ahead warns, allows it, and leaves the roadmap intact',
      (tester) async {
    useTallScreen(tester);
    final prefs = await storage(bronze());
    final container = await launch(tester, prefs);

    await openTab(tester, 'Roadmap');
    await tapText(tester, 'PLATINUM');
    await tapText(tester, 'Air Dribble Fundamentals');
    expect(find.text('Learn these first'), findsOneWidget);

    await tapText(tester, 'I already know this');
    await tapText(tester, 'Mastered: I can also use it in real matches');
    expect(find.text('Skipping ahead?'), findsOneWidget);
    expect(find.textContaining('Air Roll Aerial Control'), findsWidgets);
    await tapText(tester, 'Continue anyway');

    expect(find.text('Mastered'), findsOneWidget);
    expect(container.read(progressProvider)['air_dribble_basics']?.status,
        SkillStatus.mastered);

    // The steps before it are still there, and still not marked done.
    await tapText(tester, 'Catching');
    expect(find.text('Catching'), findsWidgets);
    expect(container.read(progressProvider)['catching'], isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await openTab(tester, 'Home');
    expect(find.text('Recommended next'), findsOneWidget);
  });

  testWidgets('search finds a skill and its pack, and favorites keep it',
      (tester) async {
    useTallScreen(tester);
    final prefs = await storage(bronze());
    final container = await launch(tester, prefs);

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'flick');
    await tester.pumpAndSettle();
    expect(find.text('Flick Fundamentals'), findsOneWidget);
    expect(find.text('Delayed Flicks'), findsOneWidget);

    await tapText(tester, 'Flick Fundamentals');
    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();
    expect(container.read(progressProvider)['flick_fundamentals']?.favorite,
        isTrue);
  });
}