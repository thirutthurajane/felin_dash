# Feline Dash — GitHub Copilot Instructions

> Flutter Flame Engine endless runner game featuring a cat protagonist.
> These instructions guide Copilot on architecture, conventions, and domain rules.

---

## 1. Project Overview

**Feline Dash** is a 2D endless side-scrolling runner built with Flutter and the Flame game engine.
The player controls a cat character that runs automatically, can jump/double-jump, slide,
and must dodge obstacles while collecting fish tokens and power-ups.

**Core gameplay loop:**
- Cat runs at increasing speed over time
- Player taps to jump, swipes down to slide
- Obstacles (dogs, bins, fences, puddles) must be avoided
- Fish tokens collected → score multiplier
- Power-ups (catnip = invincibility, yarn ball = slowdown, milk = extra life) are limited pickups
- Game ends on collision with obstacle (unless shielded by a power-up)

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| UI shell | Flutter 3.x (Material 3) |
| Game engine | Flame 1.x (`flame`, `flame_audio`, `flame_tiled`) |
| State management | Riverpod 2.x (outside game world); Flame's own component tree inside |
| Local persistence | `hive` or `shared_preferences` for high scores / settings |
| Audio | `flame_audio` wrapping `audioplayers` |
| Ads / monetisation | *(TBD — leave extension points, do not hard-code)* |
| Animations | Sprite sheets (Aseprite export) loaded via `SpriteAnimationComponent` |
| Tiled maps | Tiled `.tmx` files loaded via `TiledComponent` for background parallax layers |
| Testing | `flutter_test`, `flame_test` |

---

## 3. Directory Structure

```
feline_dash/
├── assets/
│   ├── audio/
│   │   ├── bgm/          # looping background music tracks
│   │   └── sfx/          # jump, land, collect, death, power-up sounds
│   ├── images/
│   │   ├── characters/   # cat sprite sheets (run, jump, slide, die, idle)
│   │   ├── obstacles/    # dog, bin, fence, puddle sprites
│   │   ├── collectibles/ # fish, yarn, catnip, milk sprites
│   │   ├── environment/  # background layers, ground tile
│   │   └── ui/           # HUD elements, buttons, icons
│   └── maps/             # Tiled .tmx files for parallax layers
├── lib/
│   ├── main.dart
│   ├── app.dart                  # MaterialApp + Riverpod ProviderScope
│   ├── core/
│   │   ├── constants.dart        # game constants (gravity, speeds, sizes)
│   │   ├── extensions.dart       # helper extensions
│   │   └── utils.dart
│   ├── data/
│   │   ├── models/               # pure Dart data classes (no Flutter/Flame deps)
│   │   │   ├── score_record.dart
│   │   │   ├── player_stats.dart
│   │   │   └── settings.dart
│   │   └── repositories/
│   │       ├── score_repository.dart
│   │       └── settings_repository.dart
│   ├── game/
│   │   ├── feline_dash_game.dart # FlameGame root — entry point for the game world
│   │   ├── components/
│   │   │   ├── player/
│   │   │   │   ├── cat_component.dart
│   │   │   │   ├── cat_state.dart          # enum: idle | running | jumping | sliding | dead
│   │   │   │   └── cat_animator.dart
│   │   │   ├── obstacles/
│   │   │   │   ├── obstacle_component.dart # abstract base
│   │   │   │   ├── dog_obstacle.dart
│   │   │   │   ├── bin_obstacle.dart
│   │   │   │   ├── fence_obstacle.dart
│   │   │   │   └── puddle_obstacle.dart
│   │   │   ├── collectibles/
│   │   │   │   ├── collectible_component.dart # abstract base
│   │   │   │   ├── fish_token.dart
│   │   │   │   ├── yarn_ball.dart
│   │   │   │   ├── catnip_powerup.dart
│   │   │   │   └── milk_bottle.dart
│   │   │   ├── environment/
│   │   │   │   ├── parallax_background.dart
│   │   │   │   ├── ground_component.dart
│   │   │   │   └── cloud_component.dart
│   │   │   └── hud/
│   │   │       ├── hud_component.dart
│   │   │       ├── score_display.dart
│   │   │       └── life_display.dart
│   │   ├── systems/
│   │   │   ├── spawn_system.dart        # obstacle & collectible spawning logic
│   │   │   ├── difficulty_system.dart   # speed ramp-up over time
│   │   │   ├── collision_system.dart    # collision callbacks
│   │   │   └── score_system.dart        # scoring & multiplier logic
│   │   └── overlays/
│   │       ├── pause_overlay.dart
│   │       ├── game_over_overlay.dart
│   │       └── countdown_overlay.dart
│   ├── ui/
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── game_screen.dart
│   │   │   ├── leaderboard_screen.dart
│   │   │   └── settings_screen.dart
│   │   └── widgets/
│   │       └── ...
│   └── providers/
│       ├── game_providers.dart
│       ├── score_providers.dart
│       └── settings_providers.dart
└── test/
    ├── game/
    └── data/
```

---

## 4. Core Architecture Rules

### 4.1 FlameGame vs Flutter Widget boundary

- `FelineDashGame` extends `FlameGame with HasCollisionDetection, KeyboardEvents`.
- Everything **inside the game world** (cat, obstacles, ground, HUD) is a `Component`.
- Everything **outside** (menus, leaderboard, settings) is a Flutter `Widget` with Riverpod providers.
- Overlays (pause, game-over) are registered in `GameWidget(overlayBuilderMap: {...})` and triggered via `game.overlays.add('GameOver')`.
- **Never** use `BuildContext` inside a `Component`. Pass data in via constructor or a shared `GameState` notifier.

### 4.2 Component lifecycle

Always override in this order when needed:

```dart
@override
Future<void> onLoad() async {
  // load sprites, audio, children — always call super.onLoad()
  await super.onLoad();
}

@override
void onMount() {
  super.onMount();
  // register event listeners, add to collision detection
}

@override
void update(double dt) {
  super.update(dt);
  // game logic, movement — use dt for frame-rate independence
}

@override
void onRemove() {
  // cleanup
  super.onRemove();
}
```

### 4.3 Collision Detection

- Use `HasCollisionDetection` on `FelineDashGame`.
- Every collidable component uses `RectangleHitbox` (prefer over circle for performance).
- Implement `CollisionCallbacks` on `CatComponent` only — the cat is the single source of collision truth.
- Use `collidingWith` checks by type:

```dart
@override
void onCollisionStart(Set<Vector2> points, PositionComponent other) {
  super.onCollisionStart(points, other);
  if (other is ObstacleComponent && !_isInvincible) {
    gameRef.handleCatDeath();
  } else if (other is FishToken) {
    gameRef.scoreSystem.addFish();
    other.removeFromParent();
  }
}
```

### 4.4 Spawning System

- `SpawnSystem` extends `Component` and is added to `FelineDashGame`.
- Uses a timer-based approach with `TimerComponent` or manual `_elapsed` tracking.
- Spawn probability and gaps decrease as `DifficultySystem.currentSpeed` increases.
- Pool objects when possible — use a simple `List<ObstacleComponent>` recycled pool.

```dart
// Example pattern — do not hard-code spawn intervals
class SpawnSystem extends Component with HasGameRef<FelineDashGame> {
  double _elapsed = 0;

  @override
  void update(double dt) {
    _elapsed += dt;
    final interval = _computeSpawnInterval(gameRef.difficultySystem.speed);
    if (_elapsed >= interval) {
      _elapsed = 0;
      _spawnNext();
    }
  }
}
```

### 4.5 Difficulty Progression

- Speed starts at `GameConstants.initialSpeed` and ramps linearly via `DifficultySystem`.
- Hard cap at `GameConstants.maxSpeed` so the game remains playable.
- Milestone events (every 500m, every 1000m) trigger visible feedback (screen flash, speed burst).
- All numeric difficulty constants live in `core/constants.dart` — **never magic-number inline**.

---

## 5. Game Constants (`core/constants.dart`)

```dart
abstract final class GameConstants {
  // Physics
  static const double gravity = 1800.0;          // px/s²
  static const double jumpImpulse = -700.0;       // px/s (negative = up)
  static const double doubleJumpImpulse = -550.0;
  static const double groundY = 520.0;            // logical pixel Y of ground surface

  // Speed
  static const double initialSpeed = 300.0;       // px/s
  static const double maxSpeed = 900.0;
  static const double speedIncrement = 15.0;      // px/s per second

  // Scoring
  static const int fishTokenValue = 10;
  static const double scorePerMeter = 1.0;
  static const int multiplierFishThreshold = 5;   // fish to collect before multiplier kicks in

  // Power-up durations (seconds)
  static const double catnipDuration = 5.0;
  static const double yarnDuration = 4.0;

  // Spawning
  static const double minObstacleInterval = 0.8;
  static const double maxObstacleInterval = 2.5;

  // Lives
  static const int startingLives = 3;
  static const int maxLives = 5;
}
```

---

## 6. Player (Cat) Component

### States

```dart
enum CatState { idle, running, jumping, doubleJumping, sliding, dead, invincible }
```

### Physics model

- `CatComponent` owns `_velocityY` (vertical only — horizontal is handled by world scroll speed).
- Apply gravity every frame: `_velocityY += GameConstants.gravity * dt`.
- Cap fall speed at terminal velocity (`800.0 px/s`).
- On jump input: only allow if `_isOnGround || _canDoubleJump`.
- Slide: override hitbox height to 50% for slide duration, restore on release or after `0.8s`.

### Input

- **Tap / Space** → jump (or double jump).
- **Swipe down / Arrow Down** → slide.
- Input is handled in `FelineDashGame.onTapDown` and delegated to `cat.jump()` / `cat.slide()`.
- Do **not** handle input directly inside `CatComponent` — keep input in game root for easier testing.

---

## 7. Obstacle Components

All obstacles extend `ObstacleComponent`:

```dart
abstract class ObstacleComponent extends PositionComponent
    with HasGameRef<FelineDashGame>, CollisionCallbacks {
  abstract double get scrollSpeed; // set from DifficultySystem, not stored locally

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.difficultySystem.speed * dt;
    if (position.x < -width) removeFromParent();
  }
}
```

| Obstacle | Collision Shape | Dodge Method |
|---|---|---|
| `DogObstacle` | Tall rectangle | Jump over |
| `BinObstacle` | Medium rectangle | Jump over |
| `FenceObstacle` | Short wide rectangle | Jump or slide |
| `PuddleObstacle` | Very short wide rectangle | Jump only |

---

## 8. Collectibles & Power-ups

- All extend `CollectibleComponent` (similar scroll pattern to obstacles).
- Fish tokens use a small `CircleHitbox` with `isSolid: false`.
- Power-ups are visually distinct — use pulsing scale animation (`ScaleEffect`).
- Power-up effects are applied via `FelineDashGame.activatePowerUp(PowerUpType type)`.
- Only one power-up active at a time — a new pickup replaces the current one.

---

## 9. Audio

Use `FlameAudio` helpers:

```dart
// Preload in FelineDashGame.onLoad
await FlameAudio.audioCache.loadAll([
  'bgm/street_run.mp3',
  'sfx/jump.wav',
  'sfx/land.wav',
  'sfx/collect_fish.wav',
  'sfx/powerup.wav',
  'sfx/death.wav',
]);

// Play
FlameAudio.play('sfx/jump.wav');
FlameAudio.bgm.play('bgm/street_run.mp3', volume: 0.6);
```

- BGM must be stopped and resumed on pause/resume lifecycle.
- Respect user settings: check `SettingsRepository.sfxEnabled` / `bgmEnabled` before playing.
- All audio file references are string constants in a `AudioAssets` abstract class.

---

## 10. HUD & Overlays

- `HudComponent` is a `PositionComponent` added with `camera.viewport.add(hudComponent)` so it stays screen-fixed.
- Score updates via a stream/callback from `ScoreSystem` → do **not** poll every frame.
- Overlays (Flutter widgets, not Flame components):
  - `'Pause'` → blur + pause menu buttons
  - `'GameOver'` → final score, high score, share, retry
  - `'Countdown'` → 3-2-1 before game starts / resumes

---

## 11. Parallax Background

Use Flame's built-in `ParallaxComponent`:

```dart
final parallax = await loadParallaxComponent(
  [
    ParallaxImageData('environment/sky.png'),
    ParallaxImageData('environment/buildings_far.png'),
    ParallaxImageData('environment/buildings_near.png'),
    ParallaxImageData('environment/ground_detail.png'),
  ],
  baseVelocity: Vector2(30, 0),
  velocityMultiplierDelta: Vector2(1.4, 0),
);
```

- Parallax `baseVelocity.x` must be updated each frame to match `DifficultySystem.speed * 0.1`.

---

## 12. State Management (Riverpod, outside game)

```dart
// providers/score_providers.dart
final highScoreProvider = StateNotifierProvider<HighScoreNotifier, int>((ref) {
  return HighScoreNotifier(ref.read(scoreRepositoryProvider));
});

// providers/settings_providers.dart
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier(ref.read(settingsRepositoryProvider));
});
```

- `GameScreen` creates `FelineDashGame` once and wraps it in `GameWidget`.
- Pass `highScore` into the game via constructor; the game calls back via a callback to update Riverpod state after game-over.

---

## 13. Naming Conventions

| Item | Convention | Example |
|---|---|---|
| Classes | `UpperCamelCase` | `CatComponent`, `SpawnSystem` |
| Files | `snake_case.dart` | `cat_component.dart` |
| Constants | `lowerCamelCase` inside `abstract final class` | `GameConstants.gravity` |
| Enums | `UpperCamelCase` + values `lowerCamelCase` | `CatState.jumping` |
| Private fields | `_lowerCamelCase` | `_velocityY`, `_isOnGround` |
| Asset paths | string constants in dedicated `*Assets` class | `AudioAssets.jump` |
| Providers | `*Provider` suffix | `settingsProvider` |
| Notifiers | `*Notifier` suffix | `HighScoreNotifier` |

---

## 14. Performance Rules

1. **Never allocate `Vector2` inside `update()`** — use instance fields and mutate in place (`position.x -= speed * dt`).
2. **Recycle components** — pool obstacles and collectibles instead of `removeFromParent` + recreate.
3. **Sprite sheets over individual images** — load one atlas per character/obstacle family.
4. **`debugMode = kDebugMode`** on `FelineDashGame` — hitboxes/FPS visible only in debug builds.
5. **Avoid `Children.addAll` with large lists** every frame — batch-add on spawn events only.
6. **`RectangleHitbox` over `PolygonHitbox`** for all game objects unless visual accuracy demands otherwise.

---

## 15. Testing Guidelines

- Use `flame_test`'s `FlameTester` for component unit tests.
- Test `CatComponent` physics independently: verify jump velocity, gravity accumulation, ground clamping.
- Test `SpawnSystem` deterministically by injecting a mock `DifficultySystem`.
- Test `ScoreSystem` separately — it is a pure Dart class with no Flame dependency.
- Integration test: simulate a 30-second game run, verify no exceptions, score increases, speed increases.

```dart
// Example component test
testWithFlameGame<FelineDashGame>(
  'cat jumps and returns to ground',
  (game) async {
    await game.ready();
    game.cat.jump();
    expect(game.cat.state, CatState.jumping);
    // advance frames until cat lands
    game.update(1.5);
    expect(game.cat.isOnGround, isTrue);
  },
);
```

---

## 16. Asset Naming Conventions

```
images/characters/cat_run.png        # sprite sheet, 8 frames, 64×64 px per frame
images/characters/cat_jump.png       # sprite sheet, 4 frames
images/characters/cat_slide.png      # sprite sheet, 4 frames
images/characters/cat_dead.png       # sprite sheet, 6 frames
images/obstacles/dog_run.png         # sprite sheet, 6 frames
images/collectibles/fish_token.png   # single 32×32 sprite
audio/bgm/street_run.mp3
audio/sfx/jump.wav
audio/sfx/collect_fish.wav
```

- All sprite sheets are horizontal strip (frames left → right).
- Sprite sheet metadata (frame count, size) lives in a `SpriteConfig` constant, not hard-coded at load site.

---

## 17. Do / Don't Quick Reference

| ✅ Do | ❌ Don't |
|---|---|
|Use `TDD` Method Write Test from criteria first then code|-
| Use `dt` in every `update()` call | Hard-code pixel offsets without `dt` |
| Store game-wide state in `FelineDashGame` fields | Use global singletons or static mutable state |
| Use `gameRef` to access game from components | Pass game instance as constructor arg through many layers |
| Keep `CatComponent` logic self-contained | Scatter cat physics across multiple files |
| Load assets in `onLoad`, not in constructors | `await` asset loading inside `update()` |
| Register overlays in `GameWidget.overlayBuilderMap` | Show Flutter dialogs from inside game components |
| Use `removeFromParent()` then pool recycle | `dispose()` components manually |
| Keep `constants.dart` as single source of truth | Magic numbers anywhere in game logic |
| Test components in isolation with `flame_test` | Skip unit tests for physics / scoring logic |