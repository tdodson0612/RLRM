// lib/main.dart

import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();
  runApp(PumpChumpApp(state: state));
}

class PumpChumpApp extends StatelessWidget {
  const PumpChumpApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'Pump Chump',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const AppShell(),
      ),
    );
  }
}
