import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shown while auth bootstraps from secure storage. Plays a brief, polished
/// reveal of the brand: logo eases in, gold dot breathes, wordmark + tagline
/// stagger up. Routing waits for both auth resolution and a minimum dwell
/// time (so the animation always plays through on cold start).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Match the launcher-icon background so the system→app transition is
      // visually continuous (no jarring color flash).
      backgroundColor: const Color(0xFF101A2C),
      body: const Stack(
        fit: StackFit.expand,
        children: [
          _BackgroundGlow(),
          _BrandReveal(),
        ],
      ),
    );
  }
}

/// Soft, slowly-breathing radial glow behind the logo. Centered, low-opacity,
/// adds warmth to the navy background without competing with the brand mark.
class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
            width: 420,
            height: 420,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0x33C9A95F), // soft gold
                  Color(0x00101A2C),
                ],
              ),
            ),
          )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(
            begin: 0.92,
            end: 1.06,
            duration: 2400.ms,
            curve: Curves.easeInOutSine,
          )
          .fade(begin: 0.7, end: 1.0, duration: 2400.ms),
    );
  }
}

/// Logo + wordmark + tagline, staggered.
class _BrandReveal extends StatelessWidget {
  const _BrandReveal();

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFC9A95F);
    const ivory = Color(0xFFE9E2C6);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo: scale-in with a brief overshoot, then a quiet floating idle.
          Image.asset(
                'assets/brand/siraat_logo.png',
                width: 132,
                height: 132,
              )
              .animate()
              .fadeIn(duration: 600.ms, curve: Curves.easeOut)
              .scaleXY(
                begin: 0.84,
                end: 1.0,
                duration: 700.ms,
                curve: Curves.easeOutCubic,
              )
              .then(delay: 100.ms)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(
                begin: 0,
                end: -4,
                duration: 2200.ms,
                curve: Curves.easeInOutSine,
              ),
          const SizedBox(height: 22),
          // Wordmark: fades + slides up after the logo settles.
          Text(
                'Siraat',
                style: GoogleFonts.fraunces(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: ivory,
                  letterSpacing: 4,
                ),
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .moveY(
                begin: 8,
                end: 0,
                delay: 500.ms,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 10),
          // Tagline: last to arrive, slowest to bloom.
          Text(
                'A path home',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: gold.withValues(alpha: 0.85),
                  letterSpacing: 4,
                ),
              )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 700.ms),
        ],
      ),
    );
  }
}
