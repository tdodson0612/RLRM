// test/legal_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/legal/legal_text.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/features/settings/about_screen.dart';

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

  testWidgets('About screen says the app is unofficial', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const AboutScreen()),
    );
    expect(find.text('Unofficial fan project'), findsOneWidget);
  });
}