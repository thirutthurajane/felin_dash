import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';

/// Procedural indoor parallax background with two scrolling layers:
/// - Far layer: walls with windows (slow)
/// - Mid layer: furniture — bookcases and potted plants (medium)
class ParallaxBackground extends PositionComponent
    with HasGameReference<FelineDashGame> {
  late _ScrollingLayer _farLayer;
  late _ScrollingLayer _midLayer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final screenW = game.size.x;
    final screenH = GameConstants.groundY;

    // Far layer: walls with windows
    _farLayer = _ScrollingLayer(
      speedFactor: 0.03,
      tileWidth: screenW,
      children: () => [_buildFarTile(screenW, screenH)],
    );
    add(_farLayer);

    // Mid layer: furniture
    _midLayer = _ScrollingLayer(
      speedFactor: 0.07,
      tileWidth: screenW,
      children: () => [_buildMidTile(screenW, screenH)],
    );
    add(_midLayer);
  }

  PositionComponent _buildFarTile(double w, double h) {
    final tile = PositionComponent(size: Vector2(w, h));

    // Background wall
    tile.add(RectangleComponent(
      size: Vector2(w, h),
      paint: Paint()..color = ThemeColors.gameBackground,
    ));

    // Window 1 (large rounded rectangle)
    _addWindow(tile, x: w * 0.15, y: h * 0.15, width: 128, height: 160);

    // Decorative arch
    tile.add(RectangleComponent(
      position: Vector2(w * 0.55, h * 0.25),
      size: Vector2(80, 120),
      paint: Paint()..color = ThemeColors.surfaceContainer.withValues(alpha: 0.3),
    ));

    // Window 2
    _addWindow(tile, x: w * 0.75, y: h * 0.2, width: 100, height: 140);

    return tile;
  }

  void _addWindow(PositionComponent parent,
      {required double x,
      required double y,
      required double width,
      required double height}) {
    // Window frame
    parent.add(RectangleComponent(
      position: Vector2(x, y),
      size: Vector2(width, height),
      paint: Paint()
        ..color = ThemeColors.surfaceContainer.withValues(alpha: 0.3),
    ));

    // Window border
    parent.add(RectangleComponent(
      position: Vector2(x - 2, y - 2),
      size: Vector2(width + 4, height + 4),
      paint: Paint()
        ..color = ThemeColors.surfaceContainerHighest.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    ));

    // Inner glow panel (sunshine effect)
    parent.add(RectangleComponent(
      position: Vector2(x + 12, y + 12),
      size: Vector2(width - 24, height - 24),
      paint: Paint()..color = ThemeColors.tertiaryContainer.withValues(alpha: 0.05),
    ));
  }

  PositionComponent _buildMidTile(double w, double h) {
    final tile = PositionComponent(size: Vector2(w, h));

    // Bookcase (left side)
    _addBookcase(tile, x: w * 0.1, bottom: h, width: 64, height: 128);

    // Large plant (right side)
    _addPlant(tile, x: w * 0.65, bottom: h);

    // Another small bookcase
    _addBookcase(tile, x: w * 0.85, bottom: h, width: 48, height: 96);

    return tile;
  }

  void _addBookcase(PositionComponent parent,
      {required double x,
      required double bottom,
      required double width,
      required double height}) {
    final y = bottom - height - 16;

    // Bookcase frame
    parent.add(RectangleComponent(
      position: Vector2(x, y),
      size: Vector2(width, height),
      paint: Paint()..color = ThemeColors.surfaceContainerHighest,
    ));

    // Border
    parent.add(RectangleComponent(
      position: Vector2(x, y),
      size: Vector2(width, height),
      paint: Paint()
        ..color = ThemeColors.outline.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    ));

    // Shelf bars (colored books)
    final shelfColors = [
      ThemeColors.catBody.withValues(alpha: 0.2),
      ThemeColors.tertiaryContainer.withValues(alpha: 0.2),
      ThemeColors.secondary.withValues(alpha: 0.15),
    ];
    for (var i = 0; i < shelfColors.length; i++) {
      parent.add(RectangleComponent(
        position: Vector2(x + 8, y + 16 + i * 24.0),
        size: Vector2(width - 16, 8),
        paint: Paint()..color = shelfColors[i],
      ));
    }
  }

  void _addPlant(PositionComponent parent,
      {required double x, required double bottom}) {
    // Pot/stem
    parent.add(RectangleComponent(
      position: Vector2(x + 20, bottom - 80),
      size: Vector2(28, 64),
      paint: Paint()..color = ThemeColors.secondaryDark,
    ));

    // Crown (large circle)
    parent.add(CircleComponent(
      position: Vector2(x + 2, bottom - 120),
      radius: 32,
      paint: Paint()..color = ThemeColors.secondary,
    ));

    // Crown (smaller offset circle)
    parent.add(CircleComponent(
      position: Vector2(x + 30, bottom - 108),
      radius: 24,
      paint: Paint()..color = ThemeColors.secondary.withValues(alpha: 0.8),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final speed = game.effectiveSpeed;
    _farLayer.scroll(speed, dt);
    _midLayer.scroll(speed, dt);
  }
}

/// A horizontally-scrolling layer that tiles two copies of its content for
/// seamless infinite scrolling.
class _ScrollingLayer extends PositionComponent {
  final double speedFactor;
  final double tileWidth;
  final List<PositionComponent> Function() children;

  late PositionComponent _tileA;
  late PositionComponent _tileB;

  _ScrollingLayer({
    required this.speedFactor,
    required this.tileWidth,
    required this.children,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final childrenA = children();
    final childrenB = children();

    _tileA = PositionComponent(size: Vector2(tileWidth, 0));
    for (final c in childrenA) {
      _tileA.add(c);
    }

    _tileB = PositionComponent(
      position: Vector2(tileWidth, 0),
      size: Vector2(tileWidth, 0),
    );
    for (final c in childrenB) {
      _tileB.add(c);
    }

    addAll([_tileA, _tileB]);
  }

  void scroll(double worldSpeed, double dt) {
    final dx = worldSpeed * speedFactor * dt;
    for (final tile in [_tileA, _tileB]) {
      tile.position.x -= dx;
      if (tile.position.x + tileWidth <= 0) {
        tile.position.x += tileWidth * 2;
      }
    }
  }
}
