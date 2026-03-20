import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../../core/constants.dart';
import '../../feline_dash_game.dart';
import '../collectibles/catnip_powerup.dart';
import '../collectibles/fish_token.dart';
import '../collectibles/milk_bottle.dart';
import '../collectibles/power_up_type.dart';
import '../collectibles/yarn_ball.dart';
import '../obstacles/obstacle_component.dart';
import 'cat_state.dart';

class CatComponent extends PositionComponent
    with HasGameReference<FelineDashGame>, CollisionCallbacks {
  /// Fixed horizontal position – the world scrolls, the cat stays here.
  static const double fixedX = 100.0;

  /// Total duration of the death animation.
  static const double _deadAnimDuration = 0.5;

  // ── Procedural cat sizing ──────────────────────────────────────────────────

  static const double bodyWidth = 96.0;
  static const double bodyHeight = 64.0;
  static const double headRadius = 24.0;
  static const double earWidth = 16.0;
  static const double earHeight = 24.0;
  static const double eyeRadius = 4.0;
  static const double tailWidth = 32.0;
  static const double tailHeight = 16.0;
  static const double legWidth = 12.0;
  static const double legHeight = 24.0;
  static const double shadowWidth = 80.0;
  static const double shadowHeight = 16.0;

  CatState state = CatState.running;

  double _velocityY = 0.0;
  bool _isOnGround = true;
  bool _canDoubleJump = false;
  bool _isSliding = false;
  double _slideTimer = 0.0;
  bool _isDead = false;
  double _bounceTime = 0.0;

  late RectangleHitbox _hitbox;

  // ── Procedural shape components ────────────────────────────────────────────

  late PositionComponent _catBody;
  late RectangleComponent _bodyShape;
  late CircleComponent _headShape;
  late CircleComponent _eyeShape;
  late RectangleComponent _earLeft;
  late RectangleComponent _earRight;
  late RectangleComponent _tail;
  late RectangleComponent _legFront;
  late RectangleComponent _legBack;
  late RectangleComponent _shadow;

  double get velocityY => _velocityY;
  bool get isOnGround => _isOnGround;
  bool get canDoubleJump => _canDoubleJump;
  bool get canJump => !_isDead && (_isOnGround || _canDoubleJump);
  bool get isSliding => _isSliding;
  bool get isDead => _isDead;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2(SpriteConfig.catFrameWidth + 32, SpriteConfig.catFrameHeight + 32);
    position = Vector2(
      fixedX,
      GameConstants.groundY - size.y,
    );

    // Shadow (rendered below the cat body at ground level)
    _shadow = RectangleComponent(
      position: Vector2((size.x - shadowWidth) / 2, size.y - 6),
      size: Vector2(shadowWidth, shadowHeight),
      paint: Paint()..color = ThemeColors.onSurface.withValues(alpha: 0.1),
    );
    add(_shadow);

    // Cat body group (moves up/down for bounce)
    _catBody = PositionComponent(
      position: Vector2.zero(),
      size: size,
    );

    // Tail (behind body)
    _tail = RectangleComponent(
      position: Vector2(-4, 16),
      size: Vector2(tailWidth, tailHeight),
      paint: Paint()..color = ThemeColors.catBodyDark,
    );
    _catBody.add(_tail);

    // Body (oval shape)
    _bodyShape = RectangleComponent(
      position: Vector2(16, 12),
      size: Vector2(bodyWidth, bodyHeight),
      paint: Paint()..color = ThemeColors.catBody,
    );
    _catBody.add(_bodyShape);

    // Legs
    _legBack = RectangleComponent(
      position: Vector2(32, bodyHeight + 4),
      size: Vector2(legWidth, legHeight),
      paint: Paint()..color = ThemeColors.catBodyDark,
    );
    _catBody.add(_legBack);

    _legFront = RectangleComponent(
      position: Vector2(80, bodyHeight + 4),
      size: Vector2(legWidth, legHeight),
      paint: Paint()..color = ThemeColors.catBodyDark,
    );
    _catBody.add(_legFront);

    // Head
    _headShape = CircleComponent(
      position: Vector2(bodyWidth - 4, 0),
      radius: headRadius,
      paint: Paint()..color = ThemeColors.catHead,
    );
    _catBody.add(_headShape);

    // Eye
    _eyeShape = CircleComponent(
      position: Vector2(bodyWidth + headRadius + 4, 8),
      radius: eyeRadius,
      paint: Paint()..color = ThemeColors.catEye,
    );
    _catBody.add(_eyeShape);

    // Ears
    _earRight = RectangleComponent(
      position: Vector2(bodyWidth + 4, -12),
      size: Vector2(earWidth, earHeight),
      paint: Paint()..color = ThemeColors.catHead,
    );
    _catBody.add(_earRight);

    _earLeft = RectangleComponent(
      position: Vector2(bodyWidth + 20, -12),
      size: Vector2(earWidth, earHeight),
      paint: Paint()..color = ThemeColors.catHead,
    );
    _catBody.add(_earLeft);

    add(_catBody);

    // Hitbox
    _hitbox = RectangleHitbox(
      size: Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight),
      position: Vector2(16, 12),
    );
    add(_hitbox);
  }

  void jump() {
    if (_isDead) return;
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

  void slide() {
    if (_isDead) return;
    if (!_isOnGround || _isSliding) return;

    _isSliding = true;
    _slideTimer = GameConstants.slideDuration;
    state = CatState.sliding;

    // Compress cat visually
    _bodyShape.size = Vector2(bodyWidth, bodyHeight * 0.5);
    _bodyShape.position.y = bodyHeight * 0.5 + 12;
    _headShape.position.y = bodyHeight * 0.35;
    _eyeShape.position.y = bodyHeight * 0.35 + 8;
    _earLeft.size.y = earHeight * 0.5;
    _earRight.size.y = earHeight * 0.5;
    _earLeft.position.y = bodyHeight * 0.35 - 8;
    _earRight.position.y = bodyHeight * 0.35 - 8;
    _legFront.size.y = legHeight * 0.5;
    _legFront.position.y = bodyHeight + 4;
    _legBack.size.y = legHeight * 0.5;
    _legBack.position.y = bodyHeight + 4;

    // Update hitbox
    _hitbox.size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catSlideFrameHeight);
    _hitbox.position = Vector2(16, bodyHeight * 0.5 + 12);

    position.y = GameConstants.groundY - size.y;
  }

  void endSlide() {
    if (!_isSliding) return;

    _isSliding = false;
    _slideTimer = 0.0;
    state = CatState.running;

    // Restore full cat shape
    _bodyShape.size = Vector2(bodyWidth, bodyHeight);
    _bodyShape.position.y = 12;
    _headShape.position.y = 0;
    _eyeShape.position.y = 8;
    _earLeft.size.y = earHeight;
    _earRight.size.y = earHeight;
    _earLeft.position.y = -12;
    _earRight.position.y = -12;
    _legFront.size.y = legHeight;
    _legFront.position.y = bodyHeight + 4;
    _legBack.size.y = legHeight;
    _legBack.position.y = bodyHeight + 4;

    // Restore hitbox
    _hitbox.size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight);
    _hitbox.position = Vector2(16, 12);

    position.y = GameConstants.groundY - size.y;
  }

  void reset() {
    _isDead = false;
    _isOnGround = true;
    _velocityY = 0.0;
    _canDoubleJump = false;
    _isSliding = false;
    _slideTimer = 0.0;
    _bounceTime = 0.0;
    state = CatState.running;

    endSlide();
    _bodyShape.paint.color = ThemeColors.catBody;
    _eyeShape.paint.color = ThemeColors.catEye;

    position = Vector2(fixedX, GameConstants.groundY - size.y);
    _hitbox.size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight);
    _hitbox.position = Vector2(16, 12);
  }

  void die() {
    if (_isDead) return;

    _isDead = true;
    _isSliding = false;
    _velocityY = 0.0;
    state = CatState.dead;

    // Visual death effect: tint body red, X-eyes
    _bodyShape.paint.color = ThemeColors.error;
    _eyeShape.paint.color = ThemeColors.error;

    position.y = GameConstants.groundY - size.y;
    _hitbox.size = Vector2(SpriteConfig.catFrameWidth, SpriteConfig.catFrameHeight);
    _hitbox.position = Vector2(16, 12);

    Future.delayed(
      Duration(milliseconds: (_deadAnimDuration * 1000).round()),
      () {
        if (isMounted) game.onDeathAnimationComplete();
      },
    );
  }

  // ── Collision callbacks ──────────────────────────────────────────────────

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is ObstacleComponent && !_isDead) {
      game.handleCatDeath();
    } else if (other is FishToken) {
      game.onFishCollected();
      other.removeFromParent();
    } else if (other is CatnipPowerup) {
      game.activatePowerUp(PowerUpType.catnip);
      other.removeFromParent();
    } else if (other is YarnBall) {
      game.activatePowerUp(PowerUpType.yarnBall);
      other.removeFromParent();
    } else if (other is MilkBottle) {
      game.activatePowerUp(PowerUpType.milkBottle);
      other.removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isDead) return;

    // Slide timer countdown.
    if (_isSliding) {
      _slideTimer -= dt;
      if (_slideTimer <= 0) {
        endSlide();
      }
    }

    // Bouncing animation when running on ground
    if (_isOnGround && !_isSliding) {
      _bounceTime += dt;
      final bounceOffset = -8.0 * sin(_bounceTime * 2 * pi / 0.4).abs();
      _catBody.position.y = bounceOffset;
    } else {
      _catBody.position.y = 0;
    }

    if (!_isOnGround) {
      _velocityY = (_velocityY + GameConstants.gravity * dt)
          .clamp(-double.infinity, GameConstants.terminalVelocity);

      position.y += _velocityY * dt;

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
