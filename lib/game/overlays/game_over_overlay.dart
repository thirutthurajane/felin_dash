import 'package:flutter/material.dart';

import '../feline_dash_game.dart';

class GameOverOverlay extends StatelessWidget {
  final FelineDashGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${game.finalScore}',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove(kGameOverOverlay);
                game.resumeEngine();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
