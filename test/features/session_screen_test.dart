// test/features/session_screen_test.dart

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
import 'package:roadmap_for_rl/features/training/training_screen.dart';

void main() {
  testWidgets('a session explains its goal and logs practice when done',
      (tester) async {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const TrainingScreen(showUnverified: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quick · 10 min'));
    await tester.pumpAndSettle();

    expect(find.text('Quick session'), findsOneWidget);
    expect(find.textContaining('Goal:'), findsOneWidget);
    expect(find.textContaining('Why:'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    final container =
        ProviderScope.containerOf(tester.element(find.text('Quick session')));
    expect(container.read(practiceLogProvider), isEmpty);

    await tester.ensureVisible(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final log = container.read(practiceLogProvider);
    expect(log, hasLength(1));
    expect(log.single.minutes, 10);
    final progress = container.read(progressProvider);
    expect(progress[log.single.skillId]?.status, SkillStatus.practicing);
  });
}