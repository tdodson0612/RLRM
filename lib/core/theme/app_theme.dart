// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

/// Original palette for RLRM. Rose is reserved for the next action
/// (primary buttons, selected tab, progress fill) so the hues used for skill
/// status later on always carry meaning. No game colors, fonts or assets.
abstract final class AppColors {
  static const night = Color(0xFF12141F);
  static const panel = Color(0xFF1B1F2E);
  static const panelHigh = Color(0xFF262B3F);
  static const line = Color(0xFF363C55);
  static const chalk = Color(0xFFF4F6FB);
  static const chalkMuted = Color(0xFFB7BDD3);
  static const rose = Color(0xFFFF6B9A);
  static const lavender = Color(0xFFB4A9FF);
  static const danger = Color(0xFFFF8A80);
}

/// Dark is the default identity; light exists for the Settings toggle.
abstract final class AppTheme {
  /// Atkinson Hyperlegible, bundled in assets/fonts (SIL Open Font License).
  static const fontFamily = 'AtkinsonHyperlegible';

  static final ThemeData dark = _build(
    const ColorScheme.dark(
      primary: AppColors.rose,
      onPrimary: AppColors.night,
      secondary: AppColors.lavender,
      onSecondary: AppColors.night,
      error: AppColors.danger,
      onError: AppColors.night,
      surface: AppColors.night,
      onSurface: AppColors.chalk,
      onSurfaceVariant: AppColors.chalkMuted,
      surfaceContainer: AppColors.panel,
      surfaceContainerHighest: AppColors.panelHigh,
      outlineVariant: AppColors.line,
      surfaceTint: Colors.transparent,
    ),
  );

  static final ThemeData light = _build(
    ColorScheme.fromSeed(seedColor: AppColors.rose),
  );

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(
      brightness: scheme.brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
    );
    final text = base.textTheme;
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      // Larger, heavier type than the Material defaults for glanceable reading.
      textTheme: text.copyWith(
        headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: text.bodyLarge?.copyWith(fontSize: 17, height: 1.4),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 16, height: 1.4),
      ),
      // Labels stay visible on every tab: navigation never relies on icons
      // or color alone.
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 56),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}