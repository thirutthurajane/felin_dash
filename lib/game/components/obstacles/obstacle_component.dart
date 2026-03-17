import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';

/// Base class for all obstacles.
///
/// Each subclass declares its own [obstacleSize]. On [onLoad] a
/// [RectangleHitbox] is added automatically and the component is placed
/// just off the right edge of the screen so it scrolls toward the player.
abstract class ObstacleComponent extends PositionComponent
    with HasGameReference<FelineDashGame>, CollisionCallbacks {
  /// Visual / hitbox size in logical pixels. Subclasses provide this.
  Vector2 get obstacleSize;

  late final RectangleHitbox _hitbox;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = obstacleSize.clone();

    // Sit obstacle on the ground: top edge = groundY - height.
    position = Vector2(
      game.size.x + size.x, // spawn just off-screen right
      GameConstants.groundY - size.y,
    );

    _hitbox = RectangleHitbox(size: size.clone());
    add(_hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Scroll left at world speed.
    position.x -= game.difficultySystem.speed * dt;

    // Recycle into the pool and remove once fully off the left edge.
    if (position.x < -size.x) {
      game.spawnSystem.recycle(this);
      removeFromParent();
    }
  }
}
