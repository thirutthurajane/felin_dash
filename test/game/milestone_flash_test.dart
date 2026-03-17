import 'package:feline_dash/game/components/environment/milestone_flash_component.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gameTester = FlameTester(FelineDashGame.new);

  group('MilestoneFlashComponent', () {
    gameTester.testGameWidget(
      'is removed from parent after its duration elapses',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final flash = MilestoneFlashComponent(screenSize: game.size);
        await game.add(flash);
        await game.ready();

        expect(
          game.children.whereType<MilestoneFlashComponent>().length,
          equals(1),
        );

        // Advance past the flash duration (0.3s)
        game.update(0.15);
        game.update(0.15);
        game.update(0.1);

        // Allow component removal to process
        game.update(0);

        expect(
          game.children.whereType<MilestoneFlashComponent>().length,
          equals(0),
        );
      },
    );
  });
}
