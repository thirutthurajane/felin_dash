import 'package:flame/components.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Medium-height trash bin obstacle.
/// Dodge method: jump over.
class BinObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.binHitboxWidth, SpriteConfig.binHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    final image = await gameRef.images.load(ImageAssets.binObstacle);
    add(SpriteComponent(
      sprite: Sprite(image),
      size: Vector2(SpriteConfig.binWidth, SpriteConfig.binHeight),
    ));

    size = Vector2(SpriteConfig.binWidth, SpriteConfig.binHeight);
    position = Vector2(gameRef.size.x, 0);
    placeOnGround();
  }
}
