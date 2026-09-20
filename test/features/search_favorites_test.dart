// test/features/search_favorites_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/favorites_provider.dart';
import 'package:roadmap_for_rl/data/progress_provider.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/features/favorites/favorites_screen.dart';
import 'package:roadmap_for_rl/features/search/search_screen.dart';
import 'package:roadmap_for_rl/features/skills/skill_detail_screen.dart';
import 'package:roadmap_for_rl/features/training/session_screen.dart';
import 'package:roadmap_for_rl/features/training/training_screen.dart';

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Future<ProviderContainer> open(WidgetTester tester, Widget home) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(theme: AppTheme.dark, home: home),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));
  }

  testWidgets('typing finds skills and packs, and a result opens its lesson',
      (tester) async {
    await open(tester, const SearchScreen());
    await tester.enterText(find.byType(TextField), 'flick');
    await tester.pumpAndSettle();

    expect(find.text('Flick Fundamentals'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Delayed Flicks'), 300);
    expect(find.text('Delayed Flicks'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Flick Fundamentals'),
      -300,
    );
    await tester.tap(find.text('Flick Fundamentals'));
    await tester.pumpAndSettle();
    expect(find.text('What is it?'), findsOneWidget);
  });

  testWidgets('hearting a skill saves it and lists it under Favorites',
      (tester) async {
    final container = await open(
      tester,
      SkillDetailScreen(skill: curriculum.skillById('flick_fundamentals')!),
    );
    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();
    expect(container.read(progressProvider)['flick_fundamentals']?.favorite,
        isTrue);
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Flick Fundamentals'), findsOneWidget);
  });

  testWidgets('a pack can be hearted from the Training tab', (tester) async {
    final container =
        await open(tester, const TrainingScreen(showUnverified: true));
    final heart = find.byTooltip('Add to favorites').first;
    await tester.ensureVisible(heart);
    await tester.pumpAndSettle();
    await tester.tap(heart);
    await tester.pumpAndSettle();
    expect(container.read(favoritesProvider).packs, hasLength(1));
  });

  testWidgets('a session can be saved and removed with the heart',
      (tester) async {
    final container = await open(tester, const SessionScreen(minutes: 10));
    await tester.tap(find.byTooltip('Save this session'));
    await tester.pumpAndSettle();
    expect(container.read(favoritesProvider).sessions, hasLength(1));

    await tester.tap(find.byTooltip('Remove saved session'));
    await tester.pumpAndSettle();
    expect(container.read(favoritesProvider).sessions, isEmpty);
  });
}