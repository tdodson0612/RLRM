// test/features/maintenance_screen_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/preferences.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/progress_model.dart';
import 'package:roadmap_for_rl/features/home/home_screen.dart';
import 'package:roadmap_for_rl/features/progress/progress_screen.dart';
import 'package:roadmap_for_rl/features/skills/skill_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  /// Opens a screen for a player who mastered Driving Basics 200 days ago.
  Future<void> open(WidgetTester tester, Widget home) async {
    SharedPreferences.setMockInitialValues({
      'progress_v1': jsonEncode([
        ProgressModel(
          skillId: 'driving_basics',
          status: SkillStatus.mastered,
          lastPracticed: DateTime.now().subtract(const Duration(days: 200)),
        ).toJson(),
      ]),
    });
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          curriculumProvider.overrideWith((ref) => curriculum),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(theme: AppTheme.dark, home: home),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the skill page recommends a refresh and logging it clears it',
      (tester) async {
    await open(
      tester,
      SkillDetailScreen(skill: curriculum.skillById('driving_basics')!),
    );

    expect(find.text('Maintenance Recommended'), findsOneWidget);
    expect(find.text('Last practiced: 200 days ago'), findsOneWidget);
    expect(find.text('Time for a refresh'), findsOneWidget);

    await tester.tap(find.text('Log a quick refresh'));
    await tester.pumpAndSettle();

    expect(find.text('Maintenance Recommended'), findsNothing);
    expect(find.text('Mastered'), findsOneWidget);
    expect(find.text('Last practiced: today'), findsOneWidget);
  });

  testWidgets('Progress counts the skills that need a refresh', (tester) async {
    await open(tester, const ProgressScreen());
    expect(find.text('Maintenance Recommended'), findsOneWidget);
  });

  testWidgets('Home lists what is due a refresh', (tester) async {
    await open(tester, const HomeScreen());
    await tester.scrollUntilVisible(find.text('Time to refresh'), 200);
    expect(find.text('Time to refresh'), findsOneWidget);
    expect(find.text('Last practiced 200 days ago'), findsOneWidget);
  });
}