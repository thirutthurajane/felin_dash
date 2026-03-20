import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'collectible_component.dart';

/// Yarn ball power-up: temporarily slows the world scroll speed.
///
/// Collision is handled by [CatComponent] which calls
/// [FelineDashGame.activatePowerUp(PowerUpType.yarnBall)].
/// Rendered procedurally with geometric shapes matching the game's theme.
class YarnBall extends CollectibleComponent {
  YarnBall({required double spawnX})
      : super(
          spawnX: spawnX,
          size: Vector2.all(SpriteConfig.powerUpSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position.y = GameConstants.groundY - SpriteConfig.powerUpSize;

    // Main ball
    add(CircleComponent(
      position: Vector2(2, 2),
      radius: 14,
      paint: Paint()..color = ThemeColors.tertiary,
    ));

    // Inner detail
    add(CircleComponent(
      position: Vector2(8, 8),
      radius: 8,
      paint: Paint()..color = ThemeColors.tertiaryContainer,
    ));

    // Highlight
    add(CircleComponent(
      position: Vector2(10, 6),
      radius: 4,
      paint: Paint()..color = ThemeColors.tertiaryContainer.withValues(alpha: 0.5),
    ));

    add(
      RectangleHitbox(
        size: Vector2.all(SpriteConfig.powerUpHitboxSize),
        isSolid: false,
      ),
    );

    add(
      ScaleEffect.by(
        Vector2.all(1.15),
        EffectController(
          duration: 0.4,
          reverseDuration: 0.4,
          infinite: true,
        ),
      ),
    );
  }
}
