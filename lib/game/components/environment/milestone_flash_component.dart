import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

/// A brief white screen flash that plays when the player crosses a distance
/// milestone. Fades from semi-transparent white to fully transparent, then
/// removes itself.
class MilestoneFlashComponent extends RectangleComponent {
  static const double _duration = 0.3;
  static const double _startOpacity = 0.6;

  MilestoneFlashComponent({required Vector2 screenSize})
      : super(
          size: screenSize,
          paint: Paint()..color = const Color(0xFFFFFFFF),
          priority: 100,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    opacity = _startOpacity;
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: _duration),
      )..onComplete = removeFromParent,
    );
  }
}
