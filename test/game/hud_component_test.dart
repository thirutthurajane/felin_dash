import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/collectibles/power_up_type.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:feline_dash/game/overlays/hud_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FelineDashGame game;

  setUp(() {
    game = FelineDashGame();
    game.sfxEnabled = false;
  });

  group('HudOverlay', () {
    testWidgets('renders distance counter', (tester) async {
      game.distanceNotifier.value = 145;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HudOverlay(game: game),
          ),
        ),
      );
      expect(find.text('145'), findsOneWidget);
      expect(find.text('m'), findsOneWidget);
    });

    testWidgets('renders fish counter', (tester) async {
      game.fishCountNotifier.value = 12;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HudOverlay(game: game),
          ),
        ),
      );
      expect(find.text('x12'), findsOneWidget);
    });

    testWidgets('distance counter updates when notifier changes',
        (tester) async {
      game.distanceNotifier.value = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HudOverlay(game: game),
          ),
        ),
      );
      expect(find.text('0'), findsOneWidget);

      game.distanceNotifier.value = 250;
      await tester.pump();
      expect(find.text('250'), findsOneWidget);
    });

    testWidgets('fish counter updates when notifier changes', (tester) async {
      game.fishCountNotifier.value = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HudOverlay(game: game),
          ),
        ),
      );
      expect(find.text('x0'), findsOneWidget);

      game.fishCountNotifier.value = 5;
      await tester.pump();
      expect(find.text('x5'), findsOneWidget);
    });

    testWidgets('shows input hint labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HudOverlay(game: game),
          ),
        ),
      );
      expect(find.text('JUMP'), findsOneWidget);
      expect(find.text('SLIDE'), findsOneWidget);
    });
  });
}
