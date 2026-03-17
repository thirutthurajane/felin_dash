import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/player/cat_component.dart';
import 'package:feline_dash/game/components/player/cat_state.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tester = FlameTester(FelineDashGame.new);

  group('CatComponent', () {
    tester.testGameWidget(
      'starts in running state',
      verify: (game, _) async {
        expect(game.cat.state, equals(CatState.running));
      },
    );

    tester.testGameWidget(
      'is fixed at CatComponent.fixedX on the x-axis',
      verify: (game, _) async {
        expect(game.cat.position.x, closeTo(CatComponent.fixedX, 0.1));
      },
    );

    tester.testGameWidget(
      'top edge sits at groundY minus cat height',
      verify: (game, _) async {
        final expectedY = GameConstants.groundY - game.cat.size.y;
        expect(game.cat.position.y, closeTo(expectedY, 1.0));
      },
    );

    tester.testGameWidget(
      'has a non-null animation with 8 frames',
      verify: (game, _) async {
        expect(game.cat.animation, isNotNull);
        expect(game.cat.animation!.frames.length,
            equals(SpriteConfig.catRunFrames));
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox child',
      verify: (game, _) async {
        final hitboxes = game.cat.children.whereType<RectangleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );
  });
}
