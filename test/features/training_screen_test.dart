// test/features/training_screen_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/profile_provider.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/features/training/training_screen.dart';
import '../test_utils.dart';

/// A player of a fixed rank, so the visible pack band is predictable.
class _RankedPlayer extends ProfileNotifier {
  _RankedPlayer(this.rank);

  final Stage rank;

  @override
  PlayerProfile build() => PlayerProfile(rank: rank, onboarded: true);
}

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  Widget app({required bool showUnverified, Stage rank = Stage.bronze}) =>
      ProviderScope(
        overrides: [
          curriculumProvider.overrideWith((ref) => curriculum),
          profileProvider.overrideWith(() => _RankedPlayer(rank)),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: TrainingScreen(showUnverified: showUnverified),
        ),
      );

  testWidgets('lists packs with their credit and copies a code', (tester) async {
    useTallScreen(tester);
    // Tests have no real clipboard, so answer the platform call ourselves.
    tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async => null);
    await tester.pumpWidget(app(showUnverified: true));
    await tester.pumpAndSettle();

    expect(find.text('SHOOTING'), findsOneWidget);
    expect(find.text("Woolly's Basic Aiming Practice"), findsOneWidget);
    expect(find.text('by woollyhat'), findsOneWidget);

    final copy = find.text('Copy Code').first;
    await tester.ensureVisible(copy);
    await tester.pumpAndSettle(); // let the scroll finish before tapping
    await tester.tap(copy);
    await tester.pumpAndSettle();
    expect(find.text('Training pack code copied!'), findsOneWidget);
  });

  testWidgets('unchecked packs are hidden when showUnverified is false',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app(showUnverified: false));
    await tester.pumpAndSettle();

    expect(find.text("Woolly's Basic Aiming Practice"), findsNothing);
    expect(find.text('Copy Code'), findsNothing);
  });

  testWidgets('only packs at or one rank below your own are shown',
      (tester) async {
    useTallScreen(tester);
    // A Bronze player sees Bronze packs, never Silver or above.
    await tester.pumpWidget(app(showUnverified: true, rank: Stage.bronze));
    await tester.pumpAndSettle();
    expect(find.text('Novice Defender'), findsOneWidget);
    expect(find.text('Basic Striker'), findsNothing);

    // A Silver player sees both their own tier and the Bronze tier below it.
    await tester.pumpWidget(app(showUnverified: true, rank: Stage.silver));
    await tester.pumpAndSettle();
    expect(find.text('Novice Defender'), findsOneWidget);
    expect(find.text('Basic Striker'), findsOneWidget);
    expect(find.text('[Why You Suck] Shadow Defense'), findsNothing);
  });

  testWidgets('within a rank, packs run easiest-taught-skill first',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app(showUnverified: true, rank: Stage.silver));
    await tester.pumpAndSettle();

    final striker = tester.getTopLeft(find.text('Basic Striker'));
    final goalie = tester.getTopLeft(find.text('Basic Goalie'));
    // Basic Striker teaches basic_shooting, taught earlier than basic_saves,
    // which Basic Goalie teaches, so Striker must appear first on screen.
    expect(striker.dy, lessThan(goalie.dy));
  });
}