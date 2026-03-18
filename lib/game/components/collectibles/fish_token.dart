import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/constants.dart';
import 'collectible_component.dart';

/// A fish token that the player collects for points.
///
/// Uses a [CircleHitbox] with [isSolid] = false so the cat passes through it
/// while still firing [onCollisionStart] callbacks. Collision is handled by
/// [CatComponent] which calls [FelineDashGame.onFishCollected].
class FishToken extends CollectibleComponent {
  FishToken({required double spawnX})
      : super(
          spawnX: spawnX,
          size: Vector2.all(SpriteConfig.fishTokenSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final img = await game.images.load(ImageAssets.fishToken);
    sprite = Sprite(img);

    // Place token so its bottom edge rests on the ground.
    position.y = GameConstants.groundY - SpriteConfig.fishTokenSize;

    add(
      CircleHitbox(
        radius: SpriteConfig.fishTokenHitboxRadius,
        isSolid: false,
      ),
    );
  }
}
