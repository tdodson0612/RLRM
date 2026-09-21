// test/release_checks_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/core/legal/legal_text.dart';

List<File> filesUnder(String folder, {String? ending}) => [
      for (final e in Directory(folder).listSync(recursive: true))
        if (e is File && (ending == null || e.path.endsWith(ending))) e,
    ];

void main() {
  group('offline, free and no accounts', () {
    test('the app contains no network, ads, payment or account code', () {
      final banned = RegExp(
        'dart:io|package:http|package:dio|firebase|google_mobile_ads|'
        'in_app_purchase|NetworkImage|Image\\.network|HttpClient|WebSocket|'
        'url_launcher',
        caseSensitive: false,
      );
      for (final file in filesUnder('lib', ending: '.dart')) {
        expect(banned.hasMatch(file.readAsStringSync()), isFalse,
            reason: '${file.path} uses something that needs the internet');
      }
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final dependencies = pubspec.split('dev_dependencies:').first;
      expect(banned.hasMatch(dependencies), isFalse,
          reason: 'pubspec.yaml lists a network, ads or payment package');
    });

    test('the Android app does not ask for the internet or the camera', () {
      final manifest = File('android/app/src/main/AndroidManifest.xml');
      if (!manifest.existsSync()) return; // only present in the full project
      final text = manifest.readAsStringSync();
      expect(text.contains('android.permission.INTERNET'), isFalse);
      expect(text.contains('android.permission.CAMERA'), isFalse);
    });

    test('the iOS app does not ask to use the camera or photos', () {
      final plist = File('ios/Runner/Info.plist');
      if (!plist.existsSync()) return;
      final text = plist.readAsStringSync();
      expect(text.contains('NSCameraUsageDescription'), isFalse);
      expect(text.contains('NSPhotoLibraryUsageDescription'), isFalse);
    });
  });

  group('no game assets', () {
    test('the app bundles only its own data, font and icon', () {
      final allowed = {'.json', '.ttf', '.txt', '.png'};
      for (final file in filesUnder('assets')) {
        final path = file.path.replaceAll('\\', '/');
        final ext = path.substring(path.lastIndexOf('.'));
        expect(allowed.contains(ext), isTrue, reason: 'Unexpected asset $path');
        if (ext == '.png') {
          expect(path.endsWith('assets/icon/icon.png'), isTrue,
              reason: 'The only image is the original app icon, not $path');
        }
      }
    });
  });

  group('training packs are traceable', () {
    final data = jsonDecode(
      File('assets/curriculum/curriculum.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final packs = (data['trainingPacks'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final code = RegExp(r'^[0-9A-F]{4}(-[0-9A-F]{4}){3}$');

    test('every code is well-formed and used once', () {
      expect(packs, isNotEmpty);
      final codes = [for (final p in packs) p['code'] as String];
      for (final c in codes) {
        expect(code.hasMatch(c), isTrue, reason: c);
      }
      expect(codes.toSet().length, codes.length);
    });

    test('every pack names its creator, an official source and a check date',
        () {
      for (final p in packs) {
        expect(p['creator'], isNotNull, reason: '${p['id']} has no creator');
        expect(
          (p['sourceUrl'] as String).startsWith('https://www.rocketleague.com/'),
          isTrue,
          reason: '${p['id']} is not traced to an official post',
        );
        expect(p['lastChecked'], isNotNull, reason: '${p['id']}');
      }
    });

    test('only packs seen working in-game may be marked active', () {
      for (final p in packs) {
        if (p['status'] == 'active') {
          expect(p['verifiedDate'], isNotNull,
              reason: '${p['id']} is active without a verification date');
        }
        if (p['status'] == 'retired') {
          expect(p['replacementPackId'], isNotNull,
              reason: '${p['id']} is retired with no replacement');
        }
      }
    });
  });

  group('legal', () {
    test('the app name is RLRM and never the game title', () {
      expect(LegalText.appName, 'RLRM');
      expect(LegalText.appName.toLowerCase().contains('rocket'), isFalse);
    });

    test("Epic's required notice has been pasted in", () {
      expect(LegalText.epicDisclaimer.contains('TODO'), isFalse);
      expect(LegalText.epicDisclaimer.length, greaterThan(40));
    });

    test('nothing claims to be official, verified or licensed by the game', () {
      final banned = RegExp(
        r'\b(official (app|companion|rocket league app)|verified by|licensed by)\b',
        caseSensitive: false,
      );
      final sources = [
        for (final f in filesUnder('lib', ending: '.dart')) f,
        File('assets/curriculum/curriculum.json'),
      ];
      for (final file in sources) {
        expect(banned.hasMatch(file.readAsStringSync()), isFalse,
            reason: '${file.path} implies official status');
      }
    });

    test('the store listing and privacy policy exist', () {
      expect(File('docs/STORE_LISTING.md').existsSync(), isTrue);
      expect(File('docs/PRIVACY_POLICY.md').existsSync(), isTrue);
      expect(File('docs/LEGAL_CHECKLIST.md').existsSync(), isTrue);
    });
  });
}