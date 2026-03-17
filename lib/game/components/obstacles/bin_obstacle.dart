import 'package:flame/components.dart';

import 'obstacle_component.dart';

/// A rubbish bin — medium height, must be jumped over.
class BinObstacle extends ObstacleComponent {
  /// 48 × 48 px — shorter than the dog, wider stance.
  @override
  Vector2 get obstacleSize => Vector2(48.0, 48.0);
}
