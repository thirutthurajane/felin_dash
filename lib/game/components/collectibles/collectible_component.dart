import 'package:flame/components.dart';

import '../../feline_dash_game.dart';

/// Base class for all collectibles and power-ups.
///
/// Scrolls left at the world's effective speed each frame and removes itself
/// once it passes the left edge of the screen.
abstract class CollectibleComponent extends SpriteComponent
    with HasGameReference<FelineDashGame> {
  CollectibleComponent({required double spawnX, required Vector2 size})
      : super(size: size) {
    position.x = spawnX;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.effectiveSpeed * dt;
    if (position.x < -width) removeFromParent();
  }
}
