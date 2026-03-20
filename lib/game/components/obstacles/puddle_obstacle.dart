import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Very short, very wide puddle on the ground.
/// Dodge method: jump only (too flat to slide under).
/// Rendered procedurally with geometric shapes matching the game's theme.
class PuddleObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.puddleHitboxWidth, SpriteConfig.puddleHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    size = Vector2(SpriteConfig.puddleWidth, SpriteConfig.puddleHeight);
    position = Vector2(game.size.x, 0);

    // Base water
    add(RectangleComponent(
      position: Vector2(0, 4),
      size: Vector2(96, 14),
      paint: Paint()..color = ThemeColors.secondary.withValues(alpha: 0.5),
    ));

    // Edge detail
    add(RectangleComponent(
      position: Vector2(8, 12),
      size: Vector2(80, 3),
      paint: Paint()..color = ThemeColors.secondaryDark.withValues(alpha: 0.3),
    ));

    // Highlight / reflection
    add(RectangleComponent(
      position: Vector2(18, 6),
      size: Vector2(60, 6),
      paint: Paint()..color = ThemeColors.secondary.withValues(alpha: 0.25),
    ));

    placeOnGround();
  }
}
