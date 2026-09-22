// test/data/favorites_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/data/favorites_provider.dart';
import 'package:roadmap_for_rl/data/preferences.dart';
import 'package:roadmap_for_rl/data/progress_provider.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> open(Map<String, Object> saved) async {
    SharedPreferences.setMockInitialValues(saved);
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  ProviderContainer reopen(ProviderContainer from) {
    final again = ProviderContainer(
      overrides: [
        sharedPreferencesProvider
            .overrideWithValue(from.read(sharedPreferencesProvider)),
      ],
    );
    addTearDown(again.dispose);
    return again;
  }

  const session = SavedSession(
    minutes: 30,
    mode: GameMode.twoVsTwo,
    skillIds: ['basic_shooting', 'basic_saves'],
  );

  test('favorite packs toggle on and off and are saved', () async {
    final first = await open({});
    final notifier = first.read(favoritesProvider.notifier);
    notifier.togglePack('pack_novice_defender');
    expect(first.read(favoritesProvider).packs, {'pack_novice_defender'});
    expect(reopen(first).read(favoritesProvider).packs, {'pack_novice_defender'});

    notifier.togglePack('pack_novice_defender');
    expect(first.read(favoritesProvider).packs, isEmpty);
  });

  test('a session can be saved, saved again without duplicates, and removed',
      () async {
    final first = await open({});
    final notifier = first.read(favoritesProvider.notifier);
    notifier.toggleSession(session);
    final saved = reopen(first).read(favoritesProvider).sessions.single;
    expect(saved.minutes, 30);
    expect(saved.mode, GameMode.twoVsTwo);
    expect(saved.skillIds, ['basic_shooting', 'basic_saves']);
    expect(saved.title, 'Standard session · 2v2');

    notifier.toggleSession(session);
    expect(first.read(favoritesProvider).sessions, isEmpty);
  });

  test('a favorite skill is saved with its progress', () async {
    final first = await open({});
    first.read(progressProvider.notifier).toggleFavorite('flick_fundamentals');
    expect(reopen(first).read(progressProvider)['flick_fundamentals']!.favorite,
        isTrue);
    first.read(progressProvider.notifier).toggleFavorite('flick_fundamentals');
    expect(first.read(progressProvider)['flick_fundamentals']!.favorite, isFalse);
  });

  test('damaged favorites never stop the app opening', () async {
    final container = await open({'favorites_v1': '{"packs": 7'});
    expect(container.read(favoritesProvider).packs, isEmpty);
    expect(container.read(favoritesProvider).sessions, isEmpty);
  });
}