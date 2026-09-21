// lib/core/widgets/app_card.dart

import 'package:flutter/material.dart';

/// Rounded panel used for content blocks. Pass [onTap] to make the whole
/// card a large tappable target.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.highlight = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// A rounder card with an accent border, for the one thing to do next.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(highlight ? 28 : 20),
        side: BorderSide(
          color: highlight ? scheme.primary : scheme.outlineVariant,
          width: highlight ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}