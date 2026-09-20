// test/features/home_screen_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/progress_provider.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/features/home/home_screen.dart';

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Future<ProviderContainer> open(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(theme: AppTheme.dark, home: const HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(HomeScreen)));
  }

  testWidgets('Home says what to practice next, and why', (tester) async {
    await open(tester);

    expect(find.text('Your training'), findsOneWidget);
    expect(find.text('Current stage: Beginner'), findsOneWidget);
    expect(find.text("Today's training"), findsOneWidget);
    expect(find.text('Recommended next'), findsOneWidget);
    expect(find.text('Why: A good place to start.'), findsOneWidget);
    expect(find.text('Nothing in progress yet.'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Start training'), 200);
    await tester.tap(find.text('Start training'));
    await tester.pumpAndSettle();
    expect(find.text('What is it?'), findsOneWidget);
  });

  testWidgets('a skill in progress becomes the current focus', (tester) async {
    final container = await open(tester);
    container
        .read(progressProvider.notifier)
        .setStatus('driving_basics', SkillStatus.practicing);
    await tester.pumpAndSettle();

    expect(find.text('You are already practicing this.'), findsOneWidget);
    expect(find.text('Nothing in progress yet.'), findsNothing);
  });

  testWidgets('search and favorites are one tap away', (tester) async {
    await open(tester);

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    Navigator.of(tester.element(find.byType(TextField))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Favorites'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nothing saved yet'), findsOneWidget);
  });
}