import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/collectibles/power_up_type.dart';
import 'package:feline_dash/game/components/hud/hud_component.dart';
import 'package:feline_dash/game/components/hud/life_display.dart';
import 'package:feline_dash/game/components/hud/score_display.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tester = FlameTester(FelineDashGame.new);

  group('HudComponent', () {
    tester.testGameWidget(
      'is added to camera viewport',
      verify: (game, _) async {
        final huds =
            game.camera.viewport.children.whereType<HudComponent>();
        expect(huds, isNotEmpty);
      },
    );

    tester.testGameWidget(
      'contains a ScoreDisplay child',
      verify: (game, _) async {
        final hud =
            game.camera.viewport.children.whereType<HudComponent>().first;
        expect(hud.children.whereType<ScoreDisplay>(), isNotEmpty);
      },
    );

    tester.testGameWidget(
      'contains a LifeDisplay child',
      verify: (game, _) async {
        final hud =
            game.camera.viewport.children.whereType<HudComponent>().first;
        expect(hud.children.whereType<LifeDisplay>(), isNotEmpty);
      },
    );
  });

  group('ScoreDisplay', () {
    ScoreDisplay _scoreDisplay(FelineDashGame game) => game
        .camera.viewport.children
        .whereType<HudComponent>()
        .first
        .children
        .whereType<ScoreDisplay>()
        .first;

    tester.testGameWidget(
      'shows Score: 0 initially',
      verify: (game, _) async {
        final texts =
            _scoreDisplay(game).children.whereType<TextComponent>().toList();
        expect(texts.first.text, equals('Score: 0'));
      },
    );

    tester.testGameWidget(
      'updates score text when fish is collected',
      verify: (game, _) async {
        game.sfxEnabled = false;
        game.onFishCollected();
        final texts =
            _scoreDisplay(game).children.whereType<TextComponent>().toList();
        expect(texts.first.text,
            equals('Score: ${GameConstants.fishTokenValue}'));
      },
    );

    tester.testGameWidget(
      'shows multiplier badge text when multiplier exceeds 1',
      verify: (game, _) async {
        game.sfxEnabled = false;
        for (var i = 0; i < GameConstants.multiplierFishThreshold; i++) {
          game.onFishCollected();
        }
        final texts =
            _scoreDisplay(game).children.whereType<TextComponent>().toList();
        // second TextComponent is the multiplier badge
        expect(texts.last.text, equals('x2'));
      },
    );

    tester.testGameWidget(
      'multiplier badge is empty when multiplier is 1',
      verify: (game, _) async {
        final texts =
            _scoreDisplay(game).children.whereType<TextComponent>().toList();
        expect(texts.last.text, equals(''));
      },
    );
  });

  group('LifeDisplay', () {
    LifeDisplay _lifeDisplay(FelineDashGame game) => game
        .camera.viewport.children
        .whereType<HudComponent>()
        .first
        .children
        .whereType<LifeDisplay>()
        .first;

    tester.testGameWidget(
      'shows startingLives icons initially',
      verify: (game, _) async {
        final livesText =
            _lifeDisplay(game).children.whereType<TextComponent>().first;
        expect(
          livesText.text,
          equals(List.filled(GameConstants.startingLives, LifeDisplay.lifeIcon)
              .join(' ')),
        );
      },
    );

    tester.testGameWidget(
      'updates icon count when lives increase via milk bottle',
      verify: (game, _) async {
        game.sfxEnabled = false;
        game.activatePowerUp(PowerUpType.milkBottle);
        final livesText =
            _lifeDisplay(game).children.whereType<TextComponent>().first;
        expect(
          livesText.text,
          equals(
              List.filled(GameConstants.startingLives + 1, LifeDisplay.lifeIcon)
                  .join(' ')),
        );
      },
    );

    tester.testGameWidget(
      'LifeDisplay is positioned at the right edge of the screen',
      verify: (game, _) async {
        final ld = _lifeDisplay(game);
        // After resize the x position should be near the right edge
        expect(ld.position.x, greaterThan(game.size.x * 0.5));
      },
    );
  });
}
