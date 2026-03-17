import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/player/cat_state.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// Swipe threshold used in FelineDashGame — must exceed this to trigger slide.
const double _swipeThreshold = 50.0;

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
      'has TapCallbacks mixin',
      verify: (game, tester) async {
        expect(game, isA<TapCallbacks>());
      },
    );

    gameTester.testGameWidget(
      'debugMode matches kDebugMode',
      verify: (game, tester) async {
        expect(game.debugMode, equals(kDebugMode));
      },
    );

    gameTester.testGameWidget(
      'backgroundColor is sky blue',
      verify: (game, tester) async {
        expect(game.backgroundColor().value, equals(0xFF87CEEB));
      },
    );

    // ── Input handling tests ────────────────────────────────────────────────

    gameTester.testGameWidget(
      'onTapDown triggers cat jump (state becomes jumping)',
      verify: (game, tester) async {
        // Disable SFX so FlameAudio does not attempt to load files in tests
        game.sfxEnabled = false;
        expect(game.cat.isOnGround, isTrue);
        await tester.tapAt(const Offset(200, 300));
        expect(game.cat.state, equals(CatState.jumping));
      },
    );

    gameTester.testGameWidget(
      'onTapDown records jump SFX request when cat is on ground',
      verify: (game, tester) async {
        game.sfxEnabled = false;
        expect(game.cat.isOnGround, isTrue);
        await tester.tapAt(const Offset(200, 300));
        expect(game.lastSfxRequested, equals(AudioAssets.sfxJump));
      },
    );

    gameTester.testGameWidget(
      'onTapDown does not request SFX when cat is already airborne',
      verify: (game, tester) async {
        game.sfxEnabled = false;
        // Get cat airborne first
        game.cat.jump();
        game.update(0.05);
        // Clear any previously recorded SFX
        game.clearSfxLog();
        // Tap again — cat is in air, should not trigger jump or SFX
        await tester.tapAt(const Offset(200, 300));
        expect(game.lastSfxRequested, isNull);
      },
    );

    // ── Swipe gesture tests ─────────────────────────────────────────────────

    gameTester.testGameWidget(
      'has DragCallbacks mixin',
      verify: (game, tester) async {
        expect(game, isA<DragCallbacks>());
      },
    );

    gameTester.testGameWidget(
      'downward swipe triggers cat slide when on ground',
      verify: (game, tester) async {
        game.sfxEnabled = false;
        expect(game.cat.isOnGround, isTrue);
        // Drag down by more than the swipe threshold
        await tester.drag(
          find.byType(GameWidget),
          const Offset(0, _swipeThreshold + 10),
        );
        await tester.pump();
        expect(game.cat.isSliding, isTrue);
        expect(game.cat.state, equals(CatState.sliding));
      },
    );

    gameTester.testGameWidget(
      'downward swipe does not trigger slide when cat is airborne',
      verify: (game, tester) async {
        game.sfxEnabled = false;
        game.cat.jump();
        game.update(0.05);
        await tester.drag(
          find.byType(GameWidget),
          const Offset(0, _swipeThreshold + 10),
        );
        await tester.pump();
        expect(game.cat.isSliding, isFalse);
      },
    );

    gameTester.testGameWidget(
      'upward swipe ends slide early',
      verify: (game, tester) async {
        game.sfxEnabled = false;
        game.cat.slide();
        expect(game.cat.isSliding, isTrue);
        // Drag up by more than the swipe threshold
        await tester.drag(
          find.byType(GameWidget),
          const Offset(0, -(_swipeThreshold + 10)),
        );
        await tester.pump();
        expect(game.cat.isSliding, isFalse);
        expect(game.cat.state, equals(CatState.running));
      },
    );

    gameTester.testGameWidget(
      'drag shorter than threshold does not trigger slide',
      verify: (game, tester) async {
        game.sfxEnabled = false;
        await tester.drag(
          find.byType(GameWidget),
          const Offset(0, _swipeThreshold - 10),
        );
        await tester.pump();
        expect(game.cat.isSliding, isFalse);
      },
    );
  });
}
