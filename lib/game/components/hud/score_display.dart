import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';

import '../../feline_dash_game.dart';

/// Screen-fixed component that displays the current score and multiplier.
///
/// Positioned at the top-left corner. Score updates are driven by a callback
/// from [ScoreSystem] — not polled every frame.
class ScoreDisplay extends PositionComponent
    with HasGameReference<FelineDashGame> {
  late TextComponent _scoreText;
  late TextComponent _multiplierText;

  static final _scoreStyle = TextPaint(
    style: const TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

  static final _multiplierStyle = TextPaint(
    style: const TextStyle(
      color: Color(0xFFFFD700),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  ScoreDisplay() : super(position: Vector2(16, 16));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: _scoreStyle,
    );
    _multiplierText = TextComponent(
      text: '',
      textRenderer: _multiplierStyle,
      position: Vector2(0, 26),
    );
    await addAll([_scoreText, _multiplierText]);
  }

  @override
  void onMount() {
    super.onMount();
    // Sync to current score immediately, then listen for future changes.
    _update(game.scoreSystem.score, game.scoreSystem.multiplier);
    game.scoreSystem.onScoreChanged = _update;
  }

  @override
  void onRemove() {
    if (game.scoreSystem.onScoreChanged == _update) {
      game.scoreSystem.onScoreChanged = null;
    }
    super.onRemove();
  }

  void _update(int score, int multiplier) {
    _scoreText.text = 'Score: $score';
    _multiplierText.text = multiplier > 1 ? 'x$multiplier' : '';
  }
}
