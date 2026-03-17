import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../../../core/constants.dart';
import 'collectible_component.dart';

/// Catnip power-up: grants temporary invincibility.
///
/// Collision is handled by [CatComponent] which calls
/// [FelineDashGame.activatePowerUp(PowerUpType.catnip)].
class CatnipPowerup extends CollectibleComponent {
  CatnipPowerup({required double spawnX})
      : super(
          spawnX: spawnX,
          size: Vector2.all(SpriteConfig.powerUpSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final img = await gameRef.images.load(ImageAssets.catnipPowerUp);
    sprite = Sprite(img);

    position.y = GameConstants.groundY - SpriteConfig.powerUpSize;

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
