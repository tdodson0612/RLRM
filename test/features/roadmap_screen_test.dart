// test/features/roadmap_screen_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/features/roadmap/roadmap_screen.dart';

void main() {
  testWidgets('Roadmap lists stages and expands to show skills', (tester) async {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(theme: AppTheme.dark, home: const RoadmapScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BEGINNER'), findsOneWidget);
    expect(find.text('BRONZE'), findsOneWidget);

    await tester.tap(find.text('BEGINNER'));
    await tester.pumpAndSettle();
    expect(find.text('Driving Basics'), findsOneWidget);
  });
}