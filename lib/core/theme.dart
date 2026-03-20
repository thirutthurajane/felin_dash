import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class FelineDashTheme {
  static ThemeData get themeData {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF8A4C00),
      onPrimary: const Color(0xFFFFF0E6),
      primaryContainer: const Color(0xFFFD9000),
      onPrimaryContainer: const Color(0xFF462400),
      secondary: const Color(0xFF006859),
      onSecondary: const Color(0xFFC2FFEF),
      secondaryContainer: const Color(0xFF68FADD),
      onSecondaryContainer: const Color(0xFF005D4F),
      tertiary: const Color(0xFF652FE7),
      onTertiary: const Color(0xFFF7F0FF),
      tertiaryContainer: const Color(0xFFB8A3FF),
      onTertiaryContainer: const Color(0xFF370096),
      error: const Color(0xFFB02500),
      onError: const Color(0xFFFFEFEC),
      errorContainer: const Color(0xFFF95630),
      onErrorContainer: const Color(0xFF520C00),
      surface: const Color(0xFFFFF5ED),
      onSurface: const Color(0xFF442900),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFFFEEDE),
      surfaceContainer: const Color(0xFFFFE4C7),
      surfaceContainerHigh: const Color(0xFFFFDDB8),
      surfaceContainerHighest: const Color(0xFFFFD6A7),
      outline: const Color(0xFF976F3E),
      outlineVariant: const Color(0xFFD3A56E),
      inverseSurface: const Color(0xFF180B00),
      onInverseSurface: const Color(0xFFC1955F),
      inversePrimary: const Color(0xFFFD9000),
      surfaceTint: const Color(0xFF8A4C00),
    );

    final headlineFont = GoogleFonts.plusJakartaSansTextTheme();
    final bodyFont = GoogleFonts.beVietnamProTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: bodyFont.copyWith(
        displayLarge: headlineFont.displayLarge,
        displayMedium: headlineFont.displayMedium,
        displaySmall: headlineFont.displaySmall,
        headlineLarge: headlineFont.headlineLarge,
        headlineMedium: headlineFont.headlineMedium,
        headlineSmall: headlineFont.headlineSmall,
        titleLarge: headlineFont.titleLarge,
        titleMedium: headlineFont.titleMedium,
        titleSmall: headlineFont.titleSmall,
        labelLarge: headlineFont.labelLarge,
        labelMedium: headlineFont.labelMedium,
        labelSmall: headlineFont.labelSmall,
      ),
    );
  }
}
