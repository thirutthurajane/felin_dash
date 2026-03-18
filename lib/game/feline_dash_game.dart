import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../core/constants.dart';
import 'components/collectibles/power_up_type.dart';
import 'components/environment/ground_component.dart';
import 'components/environment/milestone_flash_component.dart';
import 'components/environment/parallax_background.dart';
import 'components/hud/hud_component.dart';
import 'components/player/cat_component.dart';
import 'systems/difficulty_system.dart';
import 'systems/score_system.dart';
import 'components/collectibles/collectible_component.dart';
import 'components/obstacles/obstacle_component.dart';
import 'systems/spawn_system.dart';

/// Overlay key for the game-over screen.
const String kGameOverOverlay = 'GameOver';

class FelineDashGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapCallbacks, DragCallbacks {
  late final DifficultySystem difficultySystem;
  late final CatComponent cat;
  late final ScoreSystem scoreSystem;
  late final SpawnSystem spawnSystem;

  /// Remaining lives. Starts at [GameConstants.startingLives].
  int lives = GameConstants.startingLives;

  /// Whether the cat is currently invincible (catnip power-up active).
  bool isInvincible = false;

  /// Score (metres) captured when the cat dies.
  int finalScore = 0;

  /// Called whenever [lives] changes. Used by [LifeDisplay] to update icons.
  void Function(int lives)? onLivesChanged;

  /// Set to false in tests to prevent FlameAudio from trying to load files.
  bool sfxEnabled = true;

  /// Last SFX path requested (useful for test assertions).
  String? lastSfxRequested;

  /// Clears [lastSfxRequested]; used in tests to reset between assertions.
  void clearSfxLog() => lastSfxRequested = null;

  // ── Power-up state ────────────────────────────────────────────────────────

  PowerUpType? _activePowerUp;
  double _powerUpTimer = 0.0;
  double _speedMultiplier = 1.0;

  /// World scroll speed after applying any active power-up multiplier.
  double get effectiveSpeed => difficultySystem.speed * _speedMultiplier;

  // ── Swipe detection ──────────────────────────────────────────────────────

  /// Minimum downward or upward delta (px) required to recognise a swipe.
  static const double _swipeThreshold = 50.0;

  double _dragDeltaY = 0.0;

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = kDebugMode;

    scoreSystem = ScoreSystem();

    difficultySystem = DifficultySystem()
      ..onMilestone = _onMilestone;
    await add(difficultySystem);

    await add(ParallaxBackground());
    await add(GroundComponent());

    cat = CatComponent();
    await add(cat);

    spawnSystem = SpawnSystem();
    await add(spawnSystem);

    camera.viewport.add(HudComponent());
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreSystem.addDistanceScore(dt);
    _tickPowerUp(dt);
  }

  // ── Collectible callbacks ─────────────────────────────────────────────────

  /// Called by [CatComponent] when it overlaps a [FishToken].
  void onFishCollected() {
    scoreSystem.addFish();
    _playSfx(AudioAssets.sfxCollectFish);
  }

  /// Activates a power-up, cancelling any previously active one.
  ///
  /// Only one power-up is active at a time — a new pickup replaces the current.
  void activatePowerUp(PowerUpType type) {
    _deactivatePowerUp();
    _activePowerUp = type;

    switch (type) {
      case PowerUpType.catnip:
        isInvincible = true;
        _powerUpTimer = GameConstants.catnipDuration;
      case PowerUpType.yarnBall:
        _speedMultiplier = GameConstants.yarnSpeedMultiplier;
        _powerUpTimer = GameConstants.yarnDuration;
      case PowerUpType.milkBottle:
        lives = (lives + 1).clamp(0, GameConstants.maxLives);
        onLivesChanged?.call(lives);
        _activePowerUp = null; // instant — no timer
    }

    _playSfx(AudioAssets.sfxPowerUp);
  }

  // ── Game reset ───────────────────────────────────────────────────────────

  /// Resets all game state back to initial values so the player can retry.
  ///
  /// Removes all in-flight obstacles and collectibles, resets the cat, score,
  /// difficulty, and power-up state.
  void resetGame() {
    // Remove all obstacles and collectibles that are currently on screen.
    children
        .whereType<ObstacleComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());
    children
        .whereType<CollectibleComponent>()
        .toList()
        .forEach((c) => c.removeFromParent());

    // Reset systems.
    scoreSystem.reset();
    difficultySystem.reset();
    spawnSystem.reset();

    // Reset game-level state.
    lives = GameConstants.startingLives;
    isInvincible = false;
    finalScore = 0;
    _deactivatePowerUp();
    onLivesChanged?.call(lives);

    // Reset the cat last so it starts running again.
    cat.reset();
  }

  // ── Tap input ────────────────────────────────────────────────────────────

  @override
  void onTapDown(TapDownEvent event) {
    if (cat.canJump) {
      cat.jump();
      _playSfx(AudioAssets.sfxJump);
    }
  }

  // ── Drag / swipe input ───────────────────────────────────────────────────

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragDeltaY = 0.0;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _dragDeltaY += event.deviceDelta.y;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_dragDeltaY > _swipeThreshold) {
      // Swipe down → slide
      cat.slide();
    } else if (_dragDeltaY < -_swipeThreshold) {
      // Swipe up → end slide early
      cat.endSlide();
    }
    _dragDeltaY = 0.0;
  }

  // ── Keyboard input ───────────────────────────────────────────────────────

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      cat.slide();
      return KeyEventResult.handled;
    }
    if (event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      cat.endSlide();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── Death handling ───────────────────────────────────────────────────────

  /// Called by [CatComponent] when it first collides with an obstacle.
  ///
  /// No-op if the cat is already dead or currently invincible (catnip).
  void handleCatDeath() {
    if (cat.isDead || isInvincible) return;

    finalScore = difficultySystem.distanceTravelled.toInt();
    _playSfx(AudioAssets.sfxDeath);
    cat.die();
  }

  /// Called by [CatComponent] after the death animation finishes.
  void onDeathAnimationComplete() {
    overlays.add(kGameOverOverlay);
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  void _onMilestone(double distance) {
    add(MilestoneFlashComponent(screenSize: size));
  }

  void _playSfx(String path) {
    lastSfxRequested = path;
    if (sfxEnabled) {
      FlameAudio.play(path);
    }
  }

  void _tickPowerUp(double dt) {
    if (_activePowerUp == null) return;
    _powerUpTimer -= dt;
    if (_powerUpTimer <= 0) {
      _deactivatePowerUp();
    }
  }

  void _deactivatePowerUp() {
    switch (_activePowerUp) {
      case PowerUpType.catnip:
        isInvincible = false;
      case PowerUpType.yarnBall:
        _speedMultiplier = 1.0;
      case PowerUpType.milkBottle:
      case null:
        break;
    }
    _activePowerUp = null;
    _powerUpTimer = 0.0;
  }
}
