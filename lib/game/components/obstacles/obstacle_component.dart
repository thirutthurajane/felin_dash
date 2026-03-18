import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';

/// Base class for all obstacles. Subclasses scroll left at the world speed
/// and are automatically removed when they pass off the left edge of the screen.
abstract class ObstacleComponent extends PositionComponent
    with HasGameReference<FelineDashGame>, CollisionCallbacks {
  /// Rectangle hitbox size for this obstacle type.
  Vector2 get hitboxSize;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(size: hitboxSize));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= game.effectiveSpeed * dt;
    if (position.x < -width) removeFromParent();
  }

  /// Convenience: place the obstacle so its bottom edge rests on the ground.
  void placeOnGround() {
    position.y = GameConstants.groundY - height;
  }
}
