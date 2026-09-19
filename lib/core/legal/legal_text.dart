// lib/core/legal/legal_text.dart

/// Every legal and brand string lives here so it can be audited in one place
/// and updated when Epic's policy changes. Keep game-title references here.
abstract final class LegalText {
  static const appName = 'RLRM';
  static const subtitle =
      'Beginner → SSL Training Checklist — Unofficial Companion';

  /// Epic's Fan Content Policy (section 1.10) prescribes this exact
  /// disclaimer. It was copied word-for-word from [policyUrl]. Do not retype
  /// or reword it. `test/legal_test.dart` fails while it is missing.
  static const epicDisclaimer =
      'Portions of the materials used are trademarks and/or copyrighted works of Epic Games, Inc. All rights reserved by Epic. This material is not official and is not endorsed by Epic.';

  static const policyUrl = 'https://legal.epicgames.com/epicgames/fan-art-policy';
  static const policyCheckedOn = '2026-09-19';

  static const unofficialNotice =
      'RLRM is an unofficial, fan-made training companion for '
      'Rocket League. It is not made, approved or endorsed by Epic Games or '
      'Psyonix.';
  static const nonCommercialNotice =
      'A free personal project: no ads, no purchases and no donation links.';
  static const privacyNotice =
      'Everything stays on your device. There is no account, no analytics and '
      'no server, and the app works offline.';
  static const communityPacksNotice =
      'Training packs are made by community creators. This app only lists '
      'their names, codes and credits; it does not own or host them.';
  static const noGuaranteeNotice =
      'Finishing the roadmap does not guarantee any rank. It is a practice '
      'guide, not a promise.';
}
