import 'package:flame/components.dart';

import 'obstacle_component.dart';

/// A fence — short and wide, can be jumped over or slid under.
class FenceObstacle extends ObstacleComponent {
  /// 80 × 32 px — wide, low enough to slide under.
  @override
  Vector2 get obstacleSize => Vector2(80.0, 32.0);
}
