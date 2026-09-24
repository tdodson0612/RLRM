// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The bundled typeface is open-licensed. Its license text is shown on the
  // Open-source licenses page next to every package's.
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Atkinson Hyperlegible (font)'], text);
  });

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const RoadmapApp(),
    ),
  );
}