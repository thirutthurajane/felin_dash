import 'package:flame/components.dart';

import 'obstacle_component.dart';

/// A dog that blocks the path — tall, must be jumped over.
class DogObstacle extends ObstacleComponent {
  /// 64 × 64 px — same height as the cat's full hitbox.
  @override
  Vector2 get obstacleSize => Vector2(64.0, 64.0);
}
