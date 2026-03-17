import 'package:feline_dash/game/components/environment/parallax_background.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gameTester = FlameTester(FelineDashGame.new);

  group('ParallaxBackground', () {
    gameTester.testGameWidget(
      'is added to the game on load',
      verify: (game, _) async {
        expect(
          game.children.whereType<ParallaxBackground>().length,
          equals(1),
        );
      },
    );

    gameTester.testGameWidget(
      'baseVelocity.x tracks difficulty speed',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final bg = game.children.whereType<ParallaxBackground>().first;

        // After a game update, parallax velocity should sync
        game.update(0.016);
        final expectedVelocity = game.difficultySystem.speed * 0.1;
        expect(bg.parallax!.baseVelocity.x, closeTo(expectedVelocity, 0.5));
      },
    );
  });
}
