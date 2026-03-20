import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../game/feline_dash_game.dart';
import '../../game/overlays/countdown_overlay.dart';
import '../../game/overlays/game_over_overlay.dart';
import '../../game/overlays/hud_overlay.dart';
import '../../game/overlays/pause_overlay.dart';

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
      overlayBuilderMap: {
        kHudOverlay: (context, game) => HudOverlay(game: game),
        kGameOverOverlay: (context, game) => GameOverOverlay(game: game),
        kPauseOverlay: (context, game) => PauseOverlay(game: game),
        kCountdownOverlay: (context, game) => CountdownOverlay(game: game),
      },
      initialActiveOverlays: const [kHudOverlay],
    );
  }
}
