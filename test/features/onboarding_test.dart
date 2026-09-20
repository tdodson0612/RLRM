// test/features/onboarding_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/app.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/profile_provider.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';

void main() {
  testWidgets('first launch asks for rank, mode and focus, then opens the app',
      (tester) async {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: const RoadmapApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to RLRM.'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('What is your current rank?'), findsOneWidget);
    await tester.tap(find.text('Gold'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('What mode do you mainly play?'), findsOneWidget);
    await tester.tap(find.text('2v2'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('What do you want to improve?'), findsOneWidget);
    await tester.tap(find.text('Defense'));
    await tester.tap(find.text('Build my roadmap'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    final container =
        ProviderScope.containerOf(tester.element(find.byType(NavigationBar)));
    final profile = container.read(profileProvider);
    expect(profile.onboarded, isTrue);
    expect(profile.rank, Stage.gold);
    expect(profile.mode, GameMode.twoVsTwo);
    expect(profile.focus, {SkillCategory.defense});
  });
}