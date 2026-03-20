import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'collectible_component.dart';

/// Milk bottle power-up: adds one extra life (instant, capped at maxLives).
///
/// Collision is handled by [CatComponent] which calls
/// [FelineDashGame.activatePowerUp(PowerUpType.milkBottle)].
/// Rendered procedurally with geometric shapes matching the game's theme.
class MilkBottle extends CollectibleComponent {
  MilkBottle({required double spawnX})
      : super(
          spawnX: spawnX,
          size: Vector2.all(SpriteConfig.powerUpSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position.y = GameConstants.groundY - SpriteConfig.powerUpSize;

    // Cap
    add(RectangleComponent(
      position: Vector2(10, 0),
      size: Vector2(12, 4),
      paint: Paint()..color = ThemeColors.outline,
    ));

    // Neck
    add(RectangleComponent(
      position: Vector2(11, 4),
      size: Vector2(10, 8),
      paint: Paint()..color = ThemeColors.surfaceContainerHighest,
    ));

    // Bottle body
    add(RectangleComponent(
      position: Vector2(7, 12),
      size: Vector2(18, 20),
      paint: Paint()..color = ThemeColors.surfaceContainer,
    ));

    // Label
    add(RectangleComponent(
      position: Vector2(9, 18),
      size: Vector2(14, 8),
      paint: Paint()..color = ThemeColors.primaryContainer.withValues(alpha: 0.3),
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
