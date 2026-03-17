import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../../../core/constants.dart';
import 'collectible_component.dart';

/// Milk bottle power-up: adds one extra life (instant, capped at maxLives).
///
/// Collision is handled by [CatComponent] which calls
/// [FelineDashGame.activatePowerUp(PowerUpType.milkBottle)].
class MilkBottle extends CollectibleComponent {
  MilkBottle({required double spawnX})
      : super(
          spawnX: spawnX,
          size: Vector2.all(SpriteConfig.powerUpSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final img = await gameRef.images.load(ImageAssets.milkBottle);
    sprite = Sprite(img);

    position.y = GameConstants.groundY - SpriteConfig.powerUpSize;

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
