// test/legal_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/legal/legal_text.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/features/settings/about_screen.dart';
import 'test_utils.dart';

void main() {
  // Expected to FAIL until the disclaimer is pasted in. That is intentional.
  test('Epic fan-content disclaimer (policy section 1.10) is pasted in', () {
    expect(
      LegalText.epicDisclaimer.contains('TODO'),
      isFalse,
      reason: 'Copy the disclaimer word-for-word from ${LegalText.policyUrl} '
          'into lib/core/legal/legal_text.dart before any release.',
    );
  });

  testWidgets('About states the app is unofficial, credits the font and shows '
      'the data versions', (tester) async {
    useTallScreen(tester);
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: MaterialApp(theme: AppTheme.dark, home: const AboutScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unofficial fan project'), findsOneWidget);
    expect(find.text('Fan-content notice'), findsOneWidget);
    expect(find.text('Credits'), findsOneWidget);
    expect(find.text('Data versions'), findsOneWidget);
  });
}