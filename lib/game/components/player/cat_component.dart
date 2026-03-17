import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';
import 'cat_state.dart';

class CatComponent extends SpriteAnimationComponent
    with HasGameRef<FelineDashGame> {
  /// Fixed horizontal position – the world scrolls, the cat stays here.
  static const double fixedX = 100.0;

  CatState state = CatState.running;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = await gameRef.images.load(ImageAssets.catRun);
    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: SpriteConfig.catRunFrames,
        stepTime: 0.08,
        textureSize: Vector2(
          SpriteConfig.catFrameWidth,
          SpriteConfig.catFrameHeight,
        ),
      ),
    );

    size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight);
    position = Vector2(
      fixedX,
      GameConstants.groundY - SpriteConfig.catFrameHeight,
    );

    add(RectangleHitbox());
  }
}
