import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gameTester = FlameTester(FelineDashGame.new);

  group('FelineDashGame', () {
    gameTester.testGameWidget(
      'has HasCollisionDetection mixin',
      verify: (game, tester) async {
        expect(game, isA<HasCollisionDetection>());
      },
    );

    gameTester.testGameWidget(
      'has KeyboardEvents mixin',
      verify: (game, tester) async {
        expect(game, isA<KeyboardEvents>());
      },
    );

    gameTester.testGameWidget(
      'debugMode matches kDebugMode',
      verify: (game, tester) async {
        expect(game.debugMode, equals(kDebugMode));
      },
    );

    gameTester.testGameWidget(
      'backgroundColor is grey',
      verify: (game, tester) async {
        expect(game.backgroundColor().value, equals(0xFF4A4A4A));
      },
    );
  });
}
