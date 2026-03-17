import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';

/// Screen-fixed component that displays remaining lives as paw icons.
///
/// Positioned at the top-right corner. Updates are driven by an
/// [FelineDashGame.onLivesChanged] callback — not polled every frame.
class LifeDisplay extends PositionComponent
    with HasGameReference<FelineDashGame> {
  /// The icon used to represent each life.
  static const String lifeIcon = '♥';

  late TextComponent _livesText;

  static final _textStyle = TextPaint(
    style: const TextStyle(
      color: Color(0xFFFF4444),
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  );

  /// Right-anchored so [onGameResize] only needs to set the x position.
  LifeDisplay() : super(anchor: Anchor.topRight);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _livesText = TextComponent(
      text: _iconsFor(GameConstants.startingLives),
      textRenderer: _textStyle,
      anchor: Anchor.topRight,
    );
    await add(_livesText);
  }

  @override
  void onMount() {
    super.onMount();
    // Sync to current lives immediately, then listen for future changes.
    _updateLives(game.lives);
    game.onLivesChanged = _updateLives;
  }

  @override
  void onRemove() {
    if (game.onLivesChanged == _updateLives) {
      game.onLivesChanged = null;
    }
    super.onRemove();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    position = Vector2(gameSize.x - 16, 16);
  }

  void _updateLives(int lives) {
    _livesText.text = _iconsFor(lives);
  }

  String _iconsFor(int lives) {
    final count = lives.clamp(0, GameConstants.maxLives);
    if (count == 0) return '';
    return List.filled(count, lifeIcon).join(' ');
  }
}
