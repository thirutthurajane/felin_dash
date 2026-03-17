import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'components/environment/ground_component.dart';
import 'components/player/cat_component.dart';
import 'systems/difficulty_system.dart';

class FelineDashGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  late final DifficultySystem difficultySystem;
  late final CatComponent cat;

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
}
