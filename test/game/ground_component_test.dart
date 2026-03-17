import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/environment/ground_component.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tester = FlameTester(FelineDashGame.new);

  group('GroundComponent', () {
    tester.testGameWidget(
      'is positioned at GameConstants.groundY',
      verify: (game, _) async {
        // Components are added to world, not directly to game.
        final ground =
            game.world.children.whereType<GroundComponent>().first;
        expect(ground.position.y, closeTo(GameConstants.groundY, 0.1));
      },
    );

    tester.testGameWidget(
      'has two tile children for seamless scrolling',
      verify: (game, _) async {
        final ground =
            game.world.children.whereType<GroundComponent>().first;
        expect(ground.children.length, equals(2));
      },
    );
  });
}
