// lib/features/shell/app_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/home_screen.dart';
import '../progress/progress_screen.dart';
import '../roadmap/roadmap_screen.dart';
import '../settings/settings_screen.dart';
import '../training/training_screen.dart';

/// Which bottom-navigation tab is showing. Any screen can jump to another tab
/// with `ref.read(navIndexProvider.notifier).goTo(index)`.
class NavIndex extends Notifier<int> {
  @override
  int build() => 0;

  void goTo(int index) => state = index;
}

final navIndexProvider = NotifierProvider<NavIndex, int>(NavIndex.new);

class _Tab {
  const _Tab(this.label, this.carAsset, this.screen);

  final String label;

  /// An original car icon (see assets/cars/), not a Rocket League vehicle.
  final String carAsset;
  final Widget screen;
}

const _tabs = <_Tab>[
  _Tab('Home', 'assets/cars/nav_home.png', HomeScreen()),
  _Tab('Roadmap', 'assets/cars/nav_roadmap.png', RoadmapScreen()),
  _Tab('Training', 'assets/cars/nav_training.png', TrainingScreen()),
  _Tab('Progress', 'assets/cars/nav_progress.png', ProgressScreen()),
  _Tab('Settings', 'assets/cars/nav_settings.png', SettingsScreen()),
];

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [for (final tab in _tabs) tab.screen],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: ref.read(navIndexProvider.notifier).goTo,
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              // The car art is a wide rectangular crop, not a perfect
              // square, so BoxFit.contain keeps its true proportions inside
              // the fixed icon box instead of squishing it.
              icon: Image.asset(
                tab.carAsset,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}