import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'collectible_component.dart';

/// Catnip power-up: grants temporary invincibility.
///
/// Collision is handled by [CatComponent] which calls
/// [FelineDashGame.activatePowerUp(PowerUpType.catnip)].
/// Rendered procedurally with geometric shapes matching the game's theme.
class CatnipPowerup extends CollectibleComponent {
  CatnipPowerup({required double spawnX})
      : super(
          spawnX: spawnX,
          size: Vector2.all(SpriteConfig.powerUpSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position.y = GameConstants.groundY - SpriteConfig.powerUpSize;

    // Stem
    add(RectangleComponent(
      position: Vector2(14, 22),
      size: Vector2(4, 10),
      paint: Paint()..color = ThemeColors.secondaryDark,
    ));

    // Leaf shape
    add(RectangleComponent(
      position: Vector2(7, 2),
      size: Vector2(18, 24),
      paint: Paint()..color = ThemeColors.secondary,
    ));

    // Inner detail (vein)
    add(RectangleComponent(
      position: Vector2(11, 6),
      size: Vector2(10, 16),
      paint: Paint()..color = ThemeColors.secondary.withValues(alpha: 0.6),
    ));

    add(
      RectangleHitbox(
        size: Vector2.all(SpriteConfig.powerUpHitboxSize),
        isSolid: false,
      ),
    );

    // Pulsing scale animation to signal the power-up to the player.
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
