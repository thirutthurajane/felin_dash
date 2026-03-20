import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'collectible_component.dart';

/// A fish token that the player collects for points.
///
/// Uses a [CircleHitbox] with [isSolid] = false so the cat passes through it
/// while still firing [onCollisionStart] callbacks. Collision is handled by
/// [CatComponent] which calls [FelineDashGame.onFishCollected].
/// Rendered procedurally with geometric shapes matching the game's theme.
class FishToken extends CollectibleComponent {
  FishToken({required double spawnX})
      : super(
          spawnX: spawnX,
          size: Vector2.all(SpriteConfig.fishTokenSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Place token so its bottom edge rests on the ground.
    position.y = GameConstants.groundY - SpriteConfig.fishTokenSize;

    // Fish body (main)
    add(RectangleComponent(
      position: Vector2(6, 9),
      size: Vector2(22, 14),
      paint: Paint()..color = ThemeColors.primaryContainer,
    ));

    // Tail
    add(RectangleComponent(
      position: Vector2(0, 10),
      size: Vector2(10, 12),
      paint: Paint()..color = ThemeColors.catBody,
    ));

    // Top fin
    add(RectangleComponent(
      position: Vector2(14, 4),
      size: Vector2(8, 6),
      paint: Paint()..color = ThemeColors.catBodyDark,
    ));

    // Eye
    add(CircleComponent(
      position: Vector2(22, 12),
      radius: 2.5,
      paint: Paint()..color = ThemeColors.catEye,
    ));

    add(
      CircleHitbox(
        radius: SpriteConfig.fishTokenHitboxRadius,
        isSolid: false,
      ),
    );
  }
}
