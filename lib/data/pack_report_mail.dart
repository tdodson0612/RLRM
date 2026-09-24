// lib/data/pack_report_mail.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/models/player_profile.dart';
import '../domain/models/training_pack_model.dart';
import 'pack_report_provider.dart';

const developerEmail = 'terryd0612@gmail.com';

/// Builds the mailto: draft for a pack difficulty report. Only ever a
/// mailto: link: the app never sends this itself, and never contacts any
/// server. The player's mail app opens with the message already written,
/// and nothing goes anywhere until they press Send there.
Uri packReportMailto({
  required TrainingPackModel pack,
  required ReportKind kind,
  required PlayerProfile profile,
}) {
  final issue = kind == ReportKind.tooHard ? 'too hard' : 'too easy';
  final subject = 'RLRM pack report: ${pack.name} ($issue)';
  final body = '''
Pack: ${pack.name}
Code: ${pack.code}
Creator: ${pack.creator ?? 'unknown'}
Listed difficulty: ${pack.difficulty.label}
Reported as: $issue for my rank
My rank: ${profile.rank.label}

(Add anything else that might help below.)
''';
  return Uri(
    scheme: 'mailto',
    path: developerEmail,
    query: 'subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(body)}',
  );
}

/// The one place that actually opens a link, so tests can swap it for a fake
/// instead of touching a real mail app.
final mailLauncherProvider = Provider<Future<bool> Function(Uri)>(
  (ref) => (uri) => launchUrl(uri),
);