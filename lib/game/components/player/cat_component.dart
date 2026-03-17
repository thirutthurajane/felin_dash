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
  bool _canDoubleJump = false;
  bool _isSliding = false;
  double _slideTimer = 0.0;

  late RectangleHitbox _hitbox;
  late SpriteAnimation _runAnimation;
  late SpriteAnimation _slideAnimation;

  /// Current vertical velocity in px/s (negative = upward).
  double get velocityY => _velocityY;

  /// Whether the cat is currently on the ground.
  bool get isOnGround => _isOnGround;

  /// Whether a double jump is currently available.
  bool get canDoubleJump => _canDoubleJump;

  /// Whether a jump (or double jump) can be triggered right now.
  bool get canJump => _isOnGround || _canDoubleJump;

  /// Whether the cat is currently sliding.
  bool get isSliding => _isSliding;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final runSheet = await game.images.load(ImageAssets.catRun);
    _runAnimation = SpriteAnimation.fromFrameData(
      runSheet,
      SpriteAnimationData.sequenced(
        amount: SpriteConfig.catRunFrames,
        stepTime: 0.08,
        textureSize: Vector2(
          SpriteConfig.catFrameWidth,
          SpriteConfig.catFrameHeight,
        ),
      ),
    );

    final slideSheet = await game.images.load(ImageAssets.catSlide);
    _slideAnimation = SpriteAnimation.fromFrameData(
      slideSheet,
      SpriteAnimationData.sequenced(
        amount: SpriteConfig.catSlideFrames,
        stepTime: 0.08,
        textureSize: Vector2(
          SpriteConfig.catFrameWidth,
          SpriteConfig.catSlideFrameHeight,
        ),
      ),
    );

    animation = _runAnimation;
    size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight);
    position = Vector2(
      fixedX,
      GameConstants.groundY - SpriteConfig.catFrameHeight,
    );

    _hitbox = RectangleHitbox(
      size: Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight),
    );
    add(_hitbox);
  }

  /// Apply jump or double-jump impulse.
  /// First call from ground: normal jump.
  /// Second call while airborne: double jump.
  /// Third call while airborne: ignored.
  void jump() {
    if (_isOnGround) {
      _velocityY = GameConstants.jumpImpulse;
      _isOnGround = false;
      _canDoubleJump = true;
      state = CatState.jumping;
    } else if (_canDoubleJump) {
      _velocityY = GameConstants.doubleJumpImpulse;
      _canDoubleJump = false;
      state = CatState.doubleJumping;
    }
  }

  /// Begin sliding. Blocked while airborne or already sliding.
  /// Auto-ends after [GameConstants.slideDuration] seconds.
  void slide() {
    if (!_isOnGround || _isSliding) return;

    _isSliding = true;
    _slideTimer = GameConstants.slideDuration;
    state = CatState.sliding;

    // Switch to slide animation and halve the component height.
    animation = _slideAnimation;
    size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catSlideFrameHeight);
    position.y = GameConstants.groundY - SpriteConfig.catSlideFrameHeight;

    // Resize hitbox to match the crouching silhouette.
    _hitbox.size =
        Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catSlideFrameHeight);
    _hitbox.position = Vector2.zero();
  }

  /// End the current slide immediately (also called automatically by the timer).
  void endSlide() {
    if (!_isSliding) return;

    _isSliding = false;
    _slideTimer = 0.0;
    state = CatState.running;

    // Restore full-height animation, size, and hitbox.
    animation = _runAnimation;
    size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight);
    position.y = GameConstants.groundY - SpriteConfig.catFrameHeight;

    _hitbox.size =
        Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight);
    _hitbox.position = Vector2.zero();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Slide timer countdown.
    if (_isSliding) {
      _slideTimer -= dt;
      if (_slideTimer <= 0) {
        endSlide();
      }
    }

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
        _canDoubleJump = false;
        state = CatState.running;
      }
    }
  }
}
