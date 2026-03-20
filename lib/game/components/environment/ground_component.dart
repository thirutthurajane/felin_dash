import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';

/// Procedural warm-toned floor surface matching the indoor living room theme.
class GroundComponent extends PositionComponent
    with HasGameReference<FelineDashGame> {
  static const double _floorHeight = 80.0;
  static const double _borderHeight = 4.0;
  static const double _shadowHeight = 8.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final screenWidth = game.size.x;

    position = Vector2(0, GameConstants.groundY);
    size = Vector2(screenWidth, _floorHeight + game.size.y - GameConstants.groundY);

    // Top border line (matching mockup's border-t-4 border-outline-variant/30)
    add(RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(screenWidth, _borderHeight),
      paint: Paint()..color = ThemeColors.outlineVariant.withValues(alpha: 0.3),
    ));

    // Subtle shadow gradient below border
    add(RectangleComponent(
      position: Vector2(0, _borderHeight),
      size: Vector2(screenWidth, _shadowHeight),
      paint: Paint()..color = ThemeColors.onSurface.withValues(alpha: 0.05),
    ));

    // Floor surface
    add(RectangleComponent(
      position: Vector2(0, _borderHeight),
      size: Vector2(screenWidth, _floorHeight + game.size.y - GameConstants.groundY),
      paint: Paint()..color = ThemeColors.floor,
    ));
  }
}
