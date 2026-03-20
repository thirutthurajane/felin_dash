import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../feline_dash_game.dart';

/// Flutter widget overlay that renders the in-game HUD matching the mockup:
/// - Top-left: frosted glass distance counter
/// - Top-right: orange treat/fish counter
/// - Bottom-center: faded input hints (JUMP / SLIDE)
/// - Full-screen vignette effect
class HudOverlay extends StatelessWidget {
  final FelineDashGame game;

  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Vignette effect
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    colorScheme.primary.withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),
          ),
        ),

        // HUD elements
        SafeArea(
          child: Stack(
            children: [
              // Top-left: Distance counter
              Positioned(
                top: 16,
                left: 16,
                child: IgnorePointer(
                  child: _DistanceCounter(game: game),
                ),
              ),

              // Top-right: Treat counter
              Positioned(
                top: 16,
                right: 16,
                child: IgnorePointer(
                  child: _TreatCounter(game: game),
                ),
              ),

              // Bottom-center: Input hints
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: _InputHints(colorScheme: colorScheme),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DistanceCounter extends StatelessWidget {
  final FelineDashGame game;

  const _DistanceCounter({required this.game});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: game.distanceNotifier,
            builder: (context, distance, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.speed,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$distance',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'm',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TreatCounter extends StatelessWidget {
  final FelineDashGame game;

  const _TreatCounter({required this.game});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: game.fishCountNotifier,
        builder: (context, fishCount, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pets,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'x$fishCount',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InputHints extends StatelessWidget {
  final ColorScheme colorScheme;

  const _InputHints({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _HintItem(
            icon: Icons.expand_less,
            label: 'JUMP',
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 80),
          _HintItem(
            icon: Icons.expand_more,
            label: 'SLIDE',
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _HintItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _HintItem({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 48,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
