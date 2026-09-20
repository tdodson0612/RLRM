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
  const _Tab(this.label, this.icon, this.selectedIcon, this.screen);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget screen;
}

const _tabs = <_Tab>[
  _Tab('Home', Icons.home_outlined, Icons.home_rounded, HomeScreen()),
  _Tab('Roadmap', Icons.map_outlined, Icons.map_rounded, RoadmapScreen()),
  _Tab('Training', Icons.fitness_center_outlined, Icons.fitness_center_rounded,
      TrainingScreen()),
  _Tab('Progress', Icons.insights_outlined, Icons.insights_rounded,
      ProgressScreen()),
  _Tab('Settings', Icons.settings_outlined, Icons.settings_rounded,
      SettingsScreen()),
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
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}