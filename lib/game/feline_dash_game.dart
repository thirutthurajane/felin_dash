import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class FelineDashGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  FelineDashGame();

  @override
  Color backgroundColor() => const Color(0xFF4A4A4A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = kDebugMode;
  }
}
