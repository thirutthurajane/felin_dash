import 'package:flame/components.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';

class GroundComponent extends PositionComponent
    with HasGameRef<FelineDashGame> {
  static const double _tileHeight = 80.0;

  late double _tileWidth;
  late final SpriteComponent _tileA;
  late final SpriteComponent _tileB;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _tileWidth = gameRef.size.x;
    final sprite = await Sprite.load(ImageAssets.ground);
    final tileSize = Vector2(_tileWidth, _tileHeight);

    _tileA = SpriteComponent(sprite: sprite, size: tileSize)
      ..position = Vector2(0, 0);
    _tileB = SpriteComponent(sprite: sprite, size: tileSize)
      ..position = Vector2(_tileWidth, 0);

    addAll([_tileA, _tileB]);

    position = Vector2(0, GameConstants.groundY);
    size = Vector2(_tileWidth * 2, _tileHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final speed = gameRef.difficultySystem.speed;

    for (final tile in [_tileA, _tileB]) {
      tile.position.x -= speed * dt;
      if (tile.position.x + _tileWidth <= 0) {
        tile.position.x += _tileWidth * 2;
      }
    }
  }
}
