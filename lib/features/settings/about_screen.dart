// lib/features/settings/about_screen.dart

import 'package:flutter/material.dart';

import '../../core/legal/legal_text.dart';
import '../../core/widgets/app_card.dart';

const _sections = <(String, String)>[
  ('Unofficial fan project', LegalText.unofficialNotice),
  ('Fan-content notice', LegalText.epicDisclaimer),
  ('Free and non-commercial', LegalText.nonCommercialNotice),
  ('Your data', LegalText.privacyNotice),
  ('Community training packs', LegalText.communityPacksNotice),
  ('No promises', LegalText.noGuaranteeNotice),
  (
    'Epic Games Fan Content Policy',
    'Read it at ${LegalText.policyUrl} (last checked ${LegalText.policyCheckedOn}).',
  ),
];

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About & legal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(LegalText.appName, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(LegalText.subtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          for (final (title, body) in _sections) _Section(title, body),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.body);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            SelectableText(body, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}