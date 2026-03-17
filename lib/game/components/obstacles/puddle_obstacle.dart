import 'package:flame/components.dart';

import 'obstacle_component.dart';

/// A puddle — very short and wide, must be jumped over (too flat to slide).
class PuddleObstacle extends ObstacleComponent {
  /// 96 × 16 px — very flat, only a jump clears it.
  @override
  Vector2 get obstacleSize => Vector2(96.0, 16.0);
}
