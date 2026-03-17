abstract final class GameConstants {
  // ── Physics ──────────────────────────────────────────────────────────────
  static const double gravity = 1800.0; // px/s²
  static const double jumpImpulse = -700.0; // px/s (negative = up)
  static const double doubleJumpImpulse = -550.0;
  static const double terminalVelocity = 800.0;
  static const double groundY = 520.0; // logical pixel Y of ground surface

  // ── Speed ─────────────────────────────────────────────────────────────────
  static const double initialSpeed = 300.0; // px/s
  static const double maxSpeed = 900.0;
  static const double speedIncrement = 15.0; // px/s per second

  // ── Scoring ───────────────────────────────────────────────────────────────
  static const int fishTokenValue = 10;
  static const double scorePerMeter = 1.0;
  static const int multiplierFishThreshold = 5;

  // ── Power-up durations (seconds) ──────────────────────────────────────────
  static const double catnipDuration = 5.0;
  static const double yarnDuration = 4.0;

  // ── Milestones ───────────────────────────────────────────────────────────
  static const double milestoneInterval = 500.0; // metres between milestones

  // ── Spawning ──────────────────────────────────────────────────────────────
  static const double minObstacleInterval = 0.8;
  static const double maxObstacleInterval = 2.5;

  // ── Lives ─────────────────────────────────────────────────────────────────
  static const int startingLives = 3;
  static const int maxLives = 5;

  // ── Slide ─────────────────────────────────────────────────────────────────
  static const double slideDuration = 0.8; // seconds
}

// ── Asset path constants ───────────────────────────────────────────────────

abstract final class AudioAssets {
  static const String bgmStreetRun = 'bgm/street_run.mp3';

  static const String sfxJump = 'sfx/jump.wav';
  static const String sfxLand = 'sfx/land.wav';
  static const String sfxCollectFish = 'sfx/collect_fish.wav';
  static const String sfxPowerUp = 'sfx/powerup.wav';
  static const String sfxDeath = 'sfx/death.wav';
}

abstract final class ImageAssets {
  // Characters
  static const String catRun = 'characters/cat_run.png';
  static const String catJump = 'characters/cat_jump.png';
  static const String catSlide = 'characters/cat_slide.png';
  static const String catDead = 'characters/cat_dead.png';
  static const String catIdle = 'characters/cat_idle.png';

  // Obstacles
  static const String dogRun = 'obstacles/dog_run.png';
  static const String binObstacle = 'obstacles/bin_obstacle.png';
  static const String fenceObstacle = 'obstacles/fence_obstacle.png';
  static const String puddleObstacle = 'obstacles/puddle_obstacle.png';

  // Collectibles
  static const String fishToken = 'collectibles/fish_token.png';
  static const String yarnBall = 'collectibles/yarn_ball.png';
  static const String catnipPowerUp = 'collectibles/catnip_powerup.png';
  static const String milkBottle = 'collectibles/milk_bottle.png';

  // Environment
  static const String sky = 'environment/sky.png';
  static const String buildingsFar = 'environment/buildings_far.png';
  static const String buildingsNear = 'environment/buildings_near.png';
  static const String groundDetail = 'environment/ground_detail.png';
  static const String ground = 'environment/ground.png';

  // UI
  static const String heart = 'ui/heart.png';
  static const String buttonPlay = 'ui/button_play.png';
  static const String buttonPause = 'ui/button_pause.png';
  static const String buttonRestart = 'ui/button_restart.png';
}

abstract final class SpriteConfig {
  // Cat animations
  static const int catRunFrames = 8;
  static const int catJumpFrames = 4;
  static const int catSlideFrames = 4;
  static const int catDeadFrames = 6;
  static const int catIdleFrames = 4;
  static const double catFrameWidth = 64.0;
  static const double catFrameHeight = 64.0;
  static const double catSlideFrameHeight = 32.0; // half-height during slide

  // ── Dog obstacle ──────────────────────────────────────────────────────────
  static const int dogRunFrames = 6;
  static const double dogFrameWidth = 64.0;
  static const double dogFrameHeight = 64.0;
  static const double dogHitboxWidth = 56.0;
  static const double dogHitboxHeight = 60.0;

  // ── Bin obstacle ──────────────────────────────────────────────────────────
  static const double binWidth = 48.0;
  static const double binHeight = 48.0;
  static const double binHitboxWidth = 44.0;
  static const double binHitboxHeight = 46.0;

  // ── Fence obstacle ────────────────────────────────────────────────────────
  static const double fenceWidth = 80.0;
  static const double fenceHeight = 32.0;
  static const double fenceHitboxWidth = 76.0;
  static const double fenceHitboxHeight = 28.0;

  // ── Puddle obstacle ───────────────────────────────────────────────────────
  static const double puddleWidth = 96.0;
  static const double puddleHeight = 18.0;
  static const double puddleHitboxWidth = 88.0;
  static const double puddleHitboxHeight = 14.0;
}
