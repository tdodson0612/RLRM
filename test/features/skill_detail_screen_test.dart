// test/features/skill_detail_screen_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/control_bindings_provider.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/domain/controls/control_bindings.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/features/roadmap/roadmap_screen.dart';
import 'package:roadmap_for_rl/features/skills/skill_detail_screen.dart';
import '../test_utils.dart';

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Widget app(Widget home, {ControlBindings? bindings}) => ProviderScope(
        overrides: [
          curriculumProvider.overrideWith((ref) => curriculum),
          if (bindings != null) controlBindingsProvider.overrideWithValue(bindings),
        ],
        child: MaterialApp(theme: AppTheme.dark, home: home),
      );

  testWidgets('lesson text shows the default buttons, never the tokens',
      (tester) async {
    useTallScreen(tester);
    final skill = curriculum.skillById('boost_basics')!;
    await tester.pumpWidget(app(SkillDetailScreen(skill: skill)));
    await tester.pumpAndSettle();

    expect(find.text('What is it?'), findsOneWidget);
    expect(find.textContaining('Using Circle to go faster'), findsOneWidget);
    expect(find.textContaining('[Boost]'), findsNothing);
  });

  testWidgets("lesson text uses the player's own bindings", (tester) async {
    useTallScreen(tester);
    final skill = curriculum.skillById('boost_basics')!;
    final mine = const ControlBindings().rebind(ControlAction.boost, 'R1');
    await tester.pumpWidget(app(SkillDetailScreen(skill: skill), bindings: mine));
    await tester.pumpAndSettle();

    expect(find.textContaining('Using R1 to go faster'), findsOneWidget);
    expect(find.textContaining('Circle'), findsNothing);
  });

  testWidgets('a skill with a pack shows it further down the page',
      (tester) async {
    useTallScreen(tester);
    final skill = curriculum.skillById('basic_shooting')!;
    await tester.pumpWidget(
      app(SkillDetailScreen(skill: skill, showUnverified: true)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Easy Goals :D'), findsOneWidget);
  });

  testWidgets('tapping a skill on the Roadmap opens its page', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app(const RoadmapScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('BEGINNER'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Driving Basics'));
    await tester.pumpAndSettle();

    expect(find.text('What is it?'), findsOneWidget);
    expect(find.text('How to do it'), findsOneWidget);
  });
}