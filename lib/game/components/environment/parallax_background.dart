import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import '../../feline_dash_game.dart';

/// Multi-layer parallax background whose scroll speed is synced each frame to
/// [FelineDashGame.difficultySystem] speed.
class ParallaxBackground extends ParallaxComponent<FelineDashGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        // ParallaxImageData('environment/sky.png'),
        // ParallaxImageData('environment/buildings_far.png'),
        // ParallaxImageData('environment/buildings_near.png'),
        // ParallaxImageData('environment/ground_detail.png'),
      ],
      baseVelocity: Vector2(30, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = game.difficultySystem.speed * 0.1;
  }
}
