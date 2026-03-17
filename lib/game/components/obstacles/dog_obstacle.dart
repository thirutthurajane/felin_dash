import 'package:flame/components.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Tall animated dog that runs toward the player.
/// Dodge method: jump over.
class DogObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.dogHitboxWidth, SpriteConfig.dogHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    final sheet = await gameRef.images.load(ImageAssets.dogRun);
    final animation = SpriteAnimation.fromFrameData(
      sheet,
      SpriteAnimationData.sequenced(
        amount: SpriteConfig.dogRunFrames,
        stepTime: 0.1,
        textureSize:
            Vector2(SpriteConfig.dogFrameWidth, SpriteConfig.dogFrameHeight),
      ),
    );

    add(SpriteAnimationComponent(
      animation: animation,
      size: Vector2(SpriteConfig.dogFrameWidth, SpriteConfig.dogFrameHeight),
    ));

    size = Vector2(SpriteConfig.dogFrameWidth, SpriteConfig.dogFrameHeight);
    position = Vector2(gameRef.size.x, 0);
    placeOnGround();
  }
}
