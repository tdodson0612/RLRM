// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/app.dart';

Finder _navLabel(String label) => find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    );

void main() {
  testWidgets('shell shows the five core tabs and can switch tabs',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: RoadmapApp()));

    for (final label in ['Home', 'Roadmap', 'Training', 'Progress', 'Settings']) {
      expect(_navLabel(label), findsOneWidget);
    }

    await tester.tap(_navLabel('Roadmap'));
    await tester.pumpAndSettle();

    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 1);
  });
}