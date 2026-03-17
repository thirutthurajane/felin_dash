import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../core/constants.dart';
import 'components/environment/ground_component.dart';
import 'components/player/cat_component.dart';
import 'systems/difficulty_system.dart';

class FelineDashGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  late final DifficultySystem difficultySystem;
  late final CatComponent cat;

  // Fixed virtual resolution: groundY=520 sits comfortably at ~87% of height.
  @override
  final world = World();

  @override
  late final camera = CameraComponent.withFixedResolution(
    world: world,
    width: GameConstants.virtualWidth,
    height: GameConstants.virtualHeight,
  );

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = kDebugMode;

    difficultySystem = DifficultySystem();
    await world.add(difficultySystem);

    await world.add(GroundComponent());

    cat = CatComponent();
    await world.add(cat);
  }
}
