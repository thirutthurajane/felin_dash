import 'package:flame/components.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Very short, very wide puddle on the ground.
/// Dodge method: jump only (too flat to slide under).
class PuddleObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.puddleHitboxWidth, SpriteConfig.puddleHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    final image = await gameRef.images.load(ImageAssets.puddleObstacle);
    add(SpriteComponent(
      sprite: Sprite(image),
      size: Vector2(SpriteConfig.puddleWidth, SpriteConfig.puddleHeight),
    ));

    size = Vector2(SpriteConfig.puddleWidth, SpriteConfig.puddleHeight);
    position = Vector2(gameRef.size.x, 0);
    placeOnGround();
  }
}
