import 'package:flame/components.dart';

import '../../feline_dash_game.dart';
import 'life_display.dart';
import 'score_display.dart';

/// Screen-fixed HUD container added to [FelineDashGame.camera.viewport].
///
/// Hosts [ScoreDisplay] (top-left) and [LifeDisplay] (top-right) as children.
/// Because it lives in the viewport, all children remain fixed to the screen
/// regardless of world scroll position.
class HudComponent extends PositionComponent
    with HasGameReference<FelineDashGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([ScoreDisplay(), LifeDisplay()]);
  }
}
