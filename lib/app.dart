// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'data/profile_provider.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/shell/app_shell.dart';

class RoadmapApp extends ConsumerWidget {
  const RoadmapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded = ref.watch(profileProvider.select((p) => p.onboarded));
    return MaterialApp(
      title: 'RLRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // becomes a Settings preference later
      home: onboarded ? const AppShell() : const OnboardingScreen(),
    );
  }
}