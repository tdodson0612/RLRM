// test/widget_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/app.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';

Finder _navLabel(String label) => find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    );

void main() {
  testWidgets('shell shows the five core tabs and can switch tabs',
      (tester) async {
    // Loading assets uses real I/O, which never finishes inside a widget test,
    // and the loading spinner would keep pumpAndSettle waiting forever. So the
    // test hands the app its curriculum directly.
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    final curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumProvider.overrideWith((ref) => curriculum)],
        child: const RoadmapApp(),
      ),
    );

    for (final label in ['Home', 'Roadmap', 'Training', 'Progress', 'Settings']) {
      expect(_navLabel(label), findsOneWidget);
    }

    await tester.tap(_navLabel('Roadmap'));
    await tester.pumpAndSettle();

    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 1);
  });
}