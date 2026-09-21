// test/core/accessibility_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/core/widgets/app_card.dart';
import 'package:roadmap_for_rl/core/widgets/status_label.dart';
import 'package:roadmap_for_rl/domain/enums.dart';

/// WCAG contrast ratio between two colors.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  final themes = {'dark': AppTheme.dark, 'light': AppTheme.light};

  for (final entry in themes.entries) {
    final scheme = entry.value.colorScheme;

    test('${entry.key} theme: text is readable (4.5:1 or better)', () {
      expect(contrast(scheme.onSurface, scheme.surface),
          greaterThanOrEqualTo(4.5));
      expect(contrast(scheme.onSurfaceVariant, scheme.surfaceContainer),
          greaterThanOrEqualTo(4.5));
      expect(contrast(scheme.onPrimary, scheme.primary),
          greaterThanOrEqualTo(4.5));
      expect(contrast(scheme.primary, scheme.surfaceContainer),
          greaterThanOrEqualTo(4.5));
    });

    test('${entry.key} theme: every status icon stands out (3:1 or better)',
        () {
      for (final status in SkillStatus.values) {
        final color = StatusLabel.colorFor(status, entry.value.brightness);
        expect(contrast(color, scheme.surfaceContainer),
            greaterThanOrEqualTo(3.0),
            reason: '${status.label} on ${entry.key}');
      }
    });
  }

  test('the bundled typeface is the one the theme uses', () {
    expect(AppTheme.dark.textTheme.bodyMedium?.fontFamily, AppTheme.fontFamily);
    expect(AppTheme.light.textTheme.titleLarge?.fontFamily, AppTheme.fontFamily);
  });

  testWidgets('a highlighted card is visibly different', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: Column(
            children: [
              AppCard(highlight: true, child: Text('next')),
              AppCard(child: Text('other')),
            ],
          ),
        ),
      ),
    );
    RoundedRectangleBorder border(String text) {
      final material = tester.widget<Material>(find
          .descendant(
            of: find.ancestor(of: find.text(text), matching: find.byType(AppCard)),
            matching: find.byType(Material),
          )
          .first);
      return material.shape! as RoundedRectangleBorder;
    }

    expect(border('next').side.width, 2);
    expect(border('other').side.width, 1);
    expect(border('next').side.color, AppTheme.dark.colorScheme.primary);
  });
}