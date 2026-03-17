import 'package:flutter/material.dart';

import 'ui/screens/game_screen.dart';

class FelineDashApp extends StatelessWidget {
  const FelineDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Feline Dash',
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}
