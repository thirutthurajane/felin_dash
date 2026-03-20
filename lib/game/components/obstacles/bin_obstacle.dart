import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Medium-height trash bin obstacle.
/// Dodge method: jump over.
/// Rendered procedurally with geometric shapes matching the game's theme.
class BinObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.binHitboxWidth, SpriteConfig.binHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    size = Vector2(SpriteConfig.binWidth, SpriteConfig.binHeight);
    position = Vector2(game.size.x, 0);

    // Lid
    add(RectangleComponent(
      position: Vector2(4, 0),
      size: Vector2(40, 8),
      paint: Paint()..color = ThemeColors.outlineVariant,
    ));

    // Rim
    add(RectangleComponent(
      position: Vector2(5, 8),
      size: Vector2(38, 4),
      paint: Paint()..color = ThemeColors.onSurfaceVariant,
    ));

    // Body
    add(RectangleComponent(
      position: Vector2(6, 12),
      size: Vector2(36, 36),
      paint: Paint()..color = ThemeColors.outline,
    ));

    // Stripe detail
    add(RectangleComponent(
      position: Vector2(8, 28),
      size: Vector2(32, 3),
      paint: Paint()..color = ThemeColors.outlineVariant.withValues(alpha: 0.3),
    ));

    placeOnGround();
  }
}
