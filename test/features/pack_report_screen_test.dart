// test/features/pack_report_screen_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/theme/app_theme.dart';
import 'package:roadmap_for_rl/core/widgets/app_card.dart';
import 'package:roadmap_for_rl/data/curriculum_repository.dart';
import 'package:roadmap_for_rl/data/pack_report_mail.dart';
import 'package:roadmap_for_rl/data/pack_report_provider.dart';
import 'package:roadmap_for_rl/data/profile_provider.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/player_profile.dart';
import 'package:roadmap_for_rl/features/training/training_screen.dart';
import '../test_utils.dart';

/// A Bronze player, so Bronze packs fit their one-rank-either-side band.
class _BronzePlayer extends ProfileNotifier {
  @override
  PlayerProfile build() => const PlayerProfile(rank: Stage.bronze, onboarded: true);
}

void main() {
  late CurriculumModel curriculum;

  setUpAll(() {
    final raw = File('assets/curriculum/curriculum.json').readAsStringSync();
    curriculum =
        CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  testWidgets(
      'reporting too hard opens a mailto draft and hides the pack for that '
      'rank immediately', (tester) async {
    useTallScreen(tester);
    final launched = <Uri>[];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          curriculumProvider.overrideWith((ref) => curriculum),
          profileProvider.overrideWith(_BronzePlayer.new),
          mailLauncherProvider.overrideWithValue((uri) async {
            launched.add(uri);
            return true;
          }),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: TrainingScreen(showUnverified: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Bronze band by default: Novice Defender is visible. Another Bronze
    // pack (Woolly's) shows too, so we must target Novice Defender's own
    // report button specifically - .first would grab whichever pack's
    // button happens to render earlier on the page, not necessarily this
    // one, and reporting the wrong pack would leave Novice Defender's own
    // difficulty untouched.
    expect(find.text('Novice Defender'), findsOneWidget);

    final noviceCard = find.ancestor(
      of: find.text('Novice Defender'),
      matching: find.byType(AppCard),
    );
    final reportButton = find.descendant(
      of: noviceCard,
      matching: find.widgetWithText(OutlinedButton, 'Report difficulty'),
    );
    await tester.ensureVisible(reportButton);
    await tester.pumpAndSettle();
    await tester.tap(reportButton);
    await tester.pumpAndSettle();

    expect(find.text('Way too hard for my rank'), findsOneWidget);
    await tester.tap(find.text('Way too hard for my rank'));
    await tester.pumpAndSettle();

    // The mail draft was opened, addressed to the developer, without an
    // automatic send.
    expect(launched, hasLength(1));
    expect(launched.single.scheme, 'mailto');
    expect(launched.single.path, developerEmail);
    expect(find.textContaining('opened an email'), findsOneWidget);

    // Bronze -> reported too hard -> effective Silver, which no longer fits
    // a Bronze player's band, so the pack disappears on this device now.
    expect(find.text('Novice Defender'), findsNothing);
  });

  testWidgets('undoing a report brings the pack back', (tester) async {
    useTallScreen(tester);
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          curriculumProvider.overrideWith((ref) => curriculum),
          profileProvider.overrideWith(_BronzePlayer.new),
          mailLauncherProvider.overrideWithValue((uri) async => true),
        ],
        child: Builder(builder: (context) {
          container = ProviderScope.containerOf(context);
          return MaterialApp(
            theme: AppTheme.dark,
            home: TrainingScreen(showUnverified: true),
          );
        }),
      ),
    );
    await tester.pumpAndSettle();
    container.read(packReportsProvider.notifier).report(
        curriculum.packById('pack_novice_defender')!, ReportKind.tooHard);
    await tester.pumpAndSettle();
    expect(find.text('Novice Defender'), findsNothing);

    // The pack is gone from the visible list, so reopen the report state
    // directly and undo it.
    container.read(packReportsProvider.notifier).undo('pack_novice_defender');
    await tester.pumpAndSettle();
    expect(find.text('Novice Defender'), findsOneWidget);
  });
}