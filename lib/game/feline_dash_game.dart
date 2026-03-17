import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../core/constants.dart';
import 'components/environment/ground_component.dart';
import 'components/environment/milestone_flash_component.dart';
import 'components/environment/parallax_background.dart';
import 'components/player/cat_component.dart';
import 'systems/difficulty_system.dart';
import 'systems/spawn_system.dart';

class FelineDashGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapCallbacks, DragCallbacks {
  late final DifficultySystem difficultySystem;
  late final SpawnSystem spawnSystem;
  late final CatComponent cat;

  /// Set to false in tests to prevent FlameAudio from trying to load files.
  bool sfxEnabled = true;

  /// Last SFX path requested (useful for test assertions).
  String? lastSfxRequested;

  /// Clears [lastSfxRequested]; used in tests to reset between assertions.
  void clearSfxLog() => lastSfxRequested = null;

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

    difficultySystem = DifficultySystem()
      ..onMilestone = _onMilestone;
    await add(difficultySystem);

    await add(ParallaxBackground());
    await add(GroundComponent());

    spawnSystem = SpawnSystem();
    await add(spawnSystem);

    cat = CatComponent();
    await add(cat);
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
    _dragDeltaY = 0.0;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _dragDeltaY += event.delta.y;
  }

  @override
  void onDragEnd(DragEndEvent event) {
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
}
