import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';
import 'cat_state.dart';

class CatComponent extends SpriteAnimationComponent
    with HasGameReference<FelineDashGame> {
  /// Fixed horizontal position – the world scrolls, the cat stays here.
  static const double fixedX = 100.0;

  CatState state = CatState.running;

  double _velocityY = 0.0;
  bool _isOnGround = true;

  /// Current vertical velocity in px/s (negative = upward).
  double get velocityY => _velocityY;

  /// Whether the cat is currently on the ground.
  bool get isOnGround => _isOnGround;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = await game.images.load(ImageAssets.catRun);
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

  /// Apply jump impulse. No-op when already airborne.
  void jump() {
    if (!_isOnGround) return;
    _velocityY = GameConstants.jumpImpulse;
    _isOnGround = false;
    state = CatState.jumping;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isOnGround) {
      // Apply gravity, capped at terminal velocity.
      _velocityY = (_velocityY + GameConstants.gravity * dt)
          .clamp(-double.infinity, GameConstants.terminalVelocity);

      position.y += _velocityY * dt;

      // Ground collision
      final groundedY = GameConstants.groundY - size.y;
      if (position.y >= groundedY) {
        position.y = groundedY;
        _velocityY = 0.0;
        _isOnGround = true;
        state = CatState.running;
      }
    }
  }
}
