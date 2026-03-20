import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Short wide fence obstacle.
/// Dodge method: jump over OR slide under.
/// Rendered procedurally with geometric shapes matching the game's theme.
class FenceObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.fenceHitboxWidth, SpriteConfig.fenceHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    size = Vector2(SpriteConfig.fenceWidth, SpriteConfig.fenceHeight);
    position = Vector2(game.size.x, 0);

    // Left post
    add(RectangleComponent(
      position: Vector2(0, 0),
      size: Vector2(8, 32),
      paint: Paint()..color = ThemeColors.outlineVariant,
    ));

    // Right post
    add(RectangleComponent(
      position: Vector2(72, 0),
      size: Vector2(8, 32),
      paint: Paint()..color = ThemeColors.outlineVariant,
    ));

    // Left post cap
    add(RectangleComponent(
      position: Vector2(-1, 0),
      size: Vector2(10, 4),
      paint: Paint()..color = ThemeColors.outline,
    ));

    // Right post cap
    add(RectangleComponent(
      position: Vector2(71, 0),
      size: Vector2(10, 4),
      paint: Paint()..color = ThemeColors.outline,
    ));

    // Three horizontal slats
    add(RectangleComponent(
      position: Vector2(4, 6),
      size: Vector2(72, 6),
      paint: Paint()..color = ThemeColors.surfaceContainerHighest,
    ));
    add(RectangleComponent(
      position: Vector2(4, 15),
      size: Vector2(72, 6),
      paint: Paint()..color = ThemeColors.surfaceContainerHighest,
    ));
    add(RectangleComponent(
      position: Vector2(4, 24),
      size: Vector2(72, 6),
      paint: Paint()..color = ThemeColors.surfaceContainerHighest,
    ));

    placeOnGround();
  }
}
