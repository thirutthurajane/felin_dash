import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../game/feline_dash_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final FelineDashGame _game;

  @override
  void initState() {
    super.initState();
    _game = FelineDashGame();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget<FelineDashGame>(
      game: _game,
      overlayBuilderMap: const {},
    );
  }
}
