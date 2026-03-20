import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import 'obstacle_component.dart';

/// Tall animated dog that runs toward the player.
/// Dodge method: jump over.
/// Rendered procedurally with geometric shapes matching the game's theme.
class DogObstacle extends ObstacleComponent {
  @override
  Vector2 get hitboxSize =>
      Vector2(SpriteConfig.dogHitboxWidth, SpriteConfig.dogHitboxHeight);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // adds RectangleHitbox via ObstacleComponent

    size = Vector2(SpriteConfig.dogFrameWidth, SpriteConfig.dogFrameHeight);
    position = Vector2(game.size.x, 0);

    // Body
    add(RectangleComponent(
      position: Vector2(12, 20),
      size: Vector2(40, 28),
      paint: Paint()..color = ThemeColors.error,
    ));

    // Head
    add(CircleComponent(
      position: Vector2(2, 10),
      radius: 14,
      paint: Paint()..color = ThemeColors.error,
    ));

    // Snout
    add(RectangleComponent(
      position: Vector2(0, 20),
      size: Vector2(10, 8),
      paint: Paint()..color = ThemeColors.onSurface,
    ));

    // Eye
    add(CircleComponent(
      position: Vector2(8, 14),
      radius: 3,
      paint: Paint()..color = ThemeColors.catEye,
    ));

    // Ears
    add(RectangleComponent(
      position: Vector2(10, 2),
      size: Vector2(8, 12),
      paint: Paint()..color = ThemeColors.onSurface.withValues(alpha: 0.7),
    ));
    add(RectangleComponent(
      position: Vector2(20, 2),
      size: Vector2(8, 12),
      paint: Paint()..color = ThemeColors.onSurface.withValues(alpha: 0.7),
    ));

    // Front legs
    add(RectangleComponent(
      position: Vector2(14, 46),
      size: Vector2(8, 18),
      paint: Paint()..color = ThemeColors.onSurface,
    ));
    add(RectangleComponent(
      position: Vector2(24, 46),
      size: Vector2(8, 18),
      paint: Paint()..color = ThemeColors.onSurface,
    ));

    // Back legs
    add(RectangleComponent(
      position: Vector2(38, 46),
      size: Vector2(8, 18),
      paint: Paint()..color = ThemeColors.onSurface,
    ));
    add(RectangleComponent(
      position: Vector2(48, 46),
      size: Vector2(8, 18),
      paint: Paint()..color = ThemeColors.onSurface,
    ));

    // Tail
    add(RectangleComponent(
      position: Vector2(52, 16),
      size: Vector2(6, 16),
      paint: Paint()..color = ThemeColors.error.withValues(alpha: 0.8),
    ));

    placeOnGround();
  }
}
