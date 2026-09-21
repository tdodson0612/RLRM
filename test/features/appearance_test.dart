// test/features/appearance_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/app.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/preferences.dart';
import 'package:roadmap_for_rl/data/profile_provider.dart';
import 'package:roadmap_for_rl/data/theme_mode_provider.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/features/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../test_utils.dart';

class _SetUpPlayer extends ProfileNotifier {
  @override
  PlayerProfile build() => const PlayerProfile(onboarded: true);
}

void main() {
  test('the chosen appearance is saved, and bad data falls back to dark',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final first = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(first.dispose);
    expect(first.read(themeModeProvider), ThemeMode.dark);

    first.read(themeModeProvider.notifier).choose(ThemeMode.light);
    final second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);
    expect(second.read(themeModeProvider), ThemeMode.light);

    SharedPreferences.setMockInitialValues({'theme_mode_v1': 'purple'});
    final bad = await SharedPreferences.getInstance();
    final third = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(bad)],
    );
    addTearDown(third.dispose);
    expect(third.read(themeModeProvider), ThemeMode.dark);
  });

  testWidgets('Settings switches the whole app between dark and light',
      (tester) async {
    useTallScreen(tester);
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          curriculumProvider.overrideWith((ref) => curriculum),
          profileProvider.overrideWith(_SetUpPlayer.new),
        ],
        child: const RoadmapApp(),
      ),
    );
    await tester.pumpAndSettle();
    ThemeMode current() =>
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;
    expect(current(), ThemeMode.dark);

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(current(), ThemeMode.light);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('Home progress can be read aloud by a screen reader',
      (tester) async {
    useTallScreen(tester);
    final handle = tester.ensureSemantics();
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(theme: AppTheme.dark, home: const HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel(RegExp('Overall progress')), findsWidgets);
    handle.dispose();
  });
}