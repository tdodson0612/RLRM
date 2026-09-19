// lib/features/shell/app_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/stage_placeholder.dart';
import '../settings/settings_screen.dart';

/// Which bottom-navigation tab is showing. Any screen can jump to another tab
/// with `ref.read(navIndexProvider.notifier).goTo(index)`.
class NavIndex extends Notifier<int> {
  @override
  int build() => 0;

  void goTo(int index) => state = index;
}

final navIndexProvider = NotifierProvider<NavIndex, int>(NavIndex.new);

/// One destination. `stage` and `plan` describe the build stage that replaces
/// the placeholder; once it lands, the real widget goes in `screen`.
class _Tab {
  const _Tab(this.label, this.icon, this.selectedIcon, this.stage, this.plan,
      {this.screen});

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int stage;
  final String plan;
  final Widget? screen;
}

const _tabs = <_Tab>[
  _Tab('Home', Icons.home_outlined, Icons.home_rounded, 10,
      "Today's training, your focus skill and exactly what to practice next."),
  _Tab('Roadmap', Icons.map_outlined, Icons.map_rounded, 4,
      'Beginner to SSL, stage by stage, with every skill one tap away.'),
  _Tab('Training', Icons.fitness_center_outlined, Icons.fitness_center_rounded,
      5, 'Community training packs we have checked, with copyable codes, plus timed sessions.'),
  _Tab('Progress', Icons.insights_outlined, Icons.insights_rounded, 7,
      'Skills, drills, mastery and match-application tests, tracked offline.'),
  _Tab('Settings', Icons.settings_outlined, Icons.settings_rounded, 12,
      'Profile, controller bindings and theme join in later stages.',
      screen: SettingsScreen()),
];

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          for (final tab in _tabs)
            tab.screen ??
                StagePlaceholder(
                  title: tab.label,
                  icon: tab.selectedIcon,
                  description: tab.plan,
                  stage: tab.stage,
                ),
        ],
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