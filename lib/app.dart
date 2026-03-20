import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'providers/settings_providers.dart';
import 'ui/screens/game_screen.dart';

class FelineDashApp extends ConsumerWidget {
  const FelineDashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowLandscape = ref.watch(settingsProvider).allowLandscape;

    final orientations = allowLandscape
        ? [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]
        : [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ];

    SystemChrome.setPreferredOrientations(orientations);

    return MaterialApp(
      title: 'Feline Dash',
      debugShowCheckedModeBanner: false,
      theme: FelineDashTheme.themeData,
      home: const GameScreen(),
    );
  }
}
