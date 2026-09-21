// test/features/skill_progress_test.dart

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
import 'package:roadmap_for_rl/features/skills/skill_detail_screen.dart';
import '../test_utils.dart';

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Future<ProviderContainer> open(WidgetTester tester, String skillId) async {
    useTallScreen(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: SkillDetailScreen(skill: curriculum.skillById(skillId)!),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(
      tester.element(find.byType(SkillDetailScreen)),
    );
  }

  testWidgets('ticking a drill starts the skill', (tester) async {
    final container = await open(tester, 'driving_basics');
    expect(find.text('Not Started'), findsOneWidget);

    final box = find.byType(Checkbox).first;
    await tester.ensureVisible(box);
    await tester.pumpAndSettle();
    await tester.tap(box);
    await tester.pumpAndSettle();

    expect(container.read(progressProvider)['driving_basics']?.status,
        SkillStatus.practicing);
  });

  testWidgets('I already know this warns before skipping ahead',
      (tester) async {
    final container = await open(tester, 'boost_basics');
    expect(find.text('Locked'), findsOneWidget);

    Future<void> chooseMastered() async {
      await tester.tap(find.text('I already know this'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mastered: I can also use it in real matches'));
      await tester.pumpAndSettle();
      expect(find.text('Skipping ahead?'), findsOneWidget);
    }

    await chooseMastered();
    await tester.tap(find.text('Go back'));
    await tester.pumpAndSettle();
    expect(container.read(progressProvider)['boost_basics'], isNull);

    await chooseMastered();
    await tester.tap(find.text('Continue anyway'));
    await tester.pumpAndSettle();
    expect(container.read(progressProvider)['boost_basics']?.status,
        SkillStatus.mastered);
  });

  testWidgets("I'm struggling shows help and is counted", (tester) async {
    final container = await open(tester, 'driving_basics');
    await tester.tap(find.text("I'm struggling with this"));
    await tester.pumpAndSettle();

    expect(find.text("Let's get you unstuck"), findsOneWidget);
    expect(find.text('Suggested retry'), findsOneWidget);
    expect(container.read(progressProvider)['driving_basics']?.struggleCount, 1);
  });
}