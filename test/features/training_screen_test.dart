// test/features/training_screen_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/features/training/training_screen.dart';

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Widget app({required bool showUnverified}) => ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: TrainingScreen(showUnverified: showUnverified),
        ),
      );

  testWidgets('lists packs with their credit and copies a code', (tester) async {
    // Tests have no real clipboard, so answer the platform call ourselves.
    tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async => null);
    await tester.pumpWidget(app(showUnverified: true));
    await tester.pumpAndSettle();

    expect(find.text('SHOOTING'), findsOneWidget);
    expect(find.text('Easy Goals :D'), findsOneWidget);
    expect(find.text('by FL0'), findsOneWidget);

    final copy = find.text('Copy Code').first;
    await tester.ensureVisible(copy);
    await tester.pumpAndSettle(); // let the scroll finish before tapping
    await tester.tap(copy);
    await tester.pumpAndSettle();
    expect(find.text('Training pack code copied!'), findsOneWidget);
  });

  testWidgets('unchecked packs are hidden when showUnverified is false',
      (tester) async {
    await tester.pumpWidget(app(showUnverified: false));
    await tester.pumpAndSettle();

    expect(find.text('Easy Goals :D'), findsNothing);
    expect(find.text('Copy Code'), findsNothing);
  });
}