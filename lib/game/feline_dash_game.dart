import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../core/constants.dart';
import 'components/environment/ground_component.dart';
import 'components/player/cat_component.dart';
import 'systems/difficulty_system.dart';

class FelineDashGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapCallbacks {
  late final DifficultySystem difficultySystem;
  late final CatComponent cat;

  /// Set to false in tests to prevent FlameAudio from trying to load files.
  bool sfxEnabled = true;

  /// Last SFX path requested (useful for test assertions).
  String? lastSfxRequested;

  /// Clears [lastSfxRequested]; used in tests to reset between assertions.
  void clearSfxLog() => lastSfxRequested = null;

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = kDebugMode;

    difficultySystem = DifficultySystem();
    await add(difficultySystem);

    await add(GroundComponent());

    cat = CatComponent();
    await add(cat);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (cat.canJump) {
      cat.jump();
      _playSfx(AudioAssets.sfxJump);
    }
  }

  void _playSfx(String path) {
    lastSfxRequested = path;
    if (sfxEnabled) {
      FlameAudio.play(path);
    }
  }
}
