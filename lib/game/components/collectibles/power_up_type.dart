/// Identifies the type of power-up collectible.
enum PowerUpType {
  /// Grants invincibility for [GameConstants.catnipDuration] seconds.
  catnip,

  /// Slows the world scroll speed for [GameConstants.yarnDuration] seconds.
  yarnBall,

  /// Adds one life (instant, capped at [GameConstants.maxLives]).
  milkBottle,
}
