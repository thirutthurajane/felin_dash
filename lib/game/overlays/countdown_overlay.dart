import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../feline_dash_game.dart';

class CountdownOverlay extends StatefulWidget {
  final FelineDashGame game;

  const CountdownOverlay({super.key, required this.game});

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay>
    with SingleTickerProviderStateMixin {
  int _count = 3;
  Timer? _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer timer) {
    if (_count <= 1) {
      timer.cancel();
      widget.game.overlays.remove(kCountdownOverlay);
      widget.game.resumeEngine();
    } else {
      setState(() {
        _count--;
        _controller
          ..reset()
          ..forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.onSurface.withValues(alpha: 0.3),
      child: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 2.0, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeIn),
            ),
            child: Text(
              '$_count',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 96,
                fontWeight: FontWeight.w800,
                color: colorScheme.primaryContainer,
                shadows: [
                  Shadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
