class Settings {
  final bool sfxEnabled;
  final bool bgmEnabled;
  final bool allowLandscape;

  const Settings({
    this.sfxEnabled = true,
    this.bgmEnabled = true,
    this.allowLandscape = false,
  });

  Settings copyWith({bool? sfxEnabled, bool? bgmEnabled, bool? allowLandscape}) {
    return Settings(
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      bgmEnabled: bgmEnabled ?? this.bgmEnabled,
      allowLandscape: allowLandscape ?? this.allowLandscape,
    );
  }
}
