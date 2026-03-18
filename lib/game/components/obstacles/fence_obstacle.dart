import 'package:flame/components.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Short wide fence obstacle.
/// Dodge method: jump over OR slide under.
class FenceObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.fenceHitboxWidth, SpriteConfig.fenceHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    final image = await game.images.load(ImageAssets.fenceObstacle);
    add(SpriteComponent(
      sprite: Sprite(image),
      size: Vector2(SpriteConfig.fenceWidth, SpriteConfig.fenceHeight),
    ));

    size = Vector2(SpriteConfig.fenceWidth, SpriteConfig.fenceHeight);
    position = Vector2(game.size.x, 0);
    placeOnGround();
  }
}
