import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// The brand reveal's arrival beats, in milliseconds.
///
/// These are the *arrivals* — the one-shot entrance of each element. The
/// ambient idle loops further down (the glow's breath, the logo's float)
/// are deliberately not counted: they `repeat(reverse: true)` forever, so
/// no dwell could ever contain them, and nothing about the brand is still
/// being revealed while they run.
///
/// The three arrivals are staggered rather than simultaneous — logo, then
/// wordmark, then tagline — which is what makes the reveal read as
/// deliberate at half a second. A simultaneous fade of the same length
/// reads as a flash.
const int _logoFadeMs = 240;
const int _logoScaleMs = 300;
const int _logoSettleMs = 60;
const int _wordmarkDelayMs = 140;
const int _wordmarkMs = 240;
const int _taglineDelayMs = 260;
const int _taglineMs = 260;

/// How long the router holds `/splash` before it is allowed to redirect.
///
/// This is not a padding figure — it is exactly when the last pixel of the
/// brand reveal stops moving (the tagline, the slowest arrival). Routing
/// away any earlier shows a half-drawn lockup; waiting any longer is dead
/// time on every cold start, paid before a single request is on the wire.
///
/// `splash_dwell_test.dart` holds the two in sync: it fails if any arrival
/// outlasts this, and it fails if this is padded beyond the slowest one.
const Duration kSplashDwell = Duration(
  milliseconds: _taglineDelayMs + _taglineMs,
);

/// Every arrival's completion time, for the test that keeps [kSplashDwell]
/// honest. Idle loops are excluded — see the note above.
@visibleForTesting
const List<({String name, int endsAtMs})> splashArrivals = [
  (name: 'logo fade', endsAtMs: _logoFadeMs),
  (name: 'logo scale', endsAtMs: _logoScaleMs),
  (name: 'wordmark', endsAtMs: _wordmarkDelayMs + _wordmarkMs),
  (name: 'tagline', endsAtMs: _taglineDelayMs + _taglineMs),
];

/// Shown while auth bootstraps from secure storage. Plays a brief, polished
/// reveal of the brand: logo eases in, gold dot breathes, wordmark + tagline
/// stagger up. Routing waits for both auth resolution and [kSplashDwell]
/// (so the reveal always plays through on cold start).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      // Match the launcher-icon background so the system→app transition is
      // visually continuous (no jarring color flash).
      backgroundColor: Color(0xFF101A2C),
      body: Stack(
        fit: StackFit.expand,
        children: [_BackgroundGlow(), _BrandReveal()],
      ),
    );
  }
}

/// Soft, slowly-breathing radial glow behind the logo. Centered, low-opacity,
/// adds warmth to the navy background without competing with the brand mark.
///
/// Ambient: it has no arrival of its own and never finishes, so it is not
/// part of [kSplashDwell]. It is simply present for however long the splash
/// is up.
class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Container(
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
          Image.asset('assets/brand/siraat_logo.png', width: 132, height: 132)
              .animate()
              .fadeIn(duration: _logoFadeMs.ms, curve: Curves.easeOut)
              .scaleXY(
                begin: 0.84,
                end: 1.0,
                duration: _logoScaleMs.ms,
                curve: Curves.easeOutCubic,
              )
              .then(delay: _logoSettleMs.ms)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(
                begin: 0,
                end: -4,
                duration: 2200.ms,
                curve: Curves.easeInOutSine,
              ),
          const SizedBox(height: 22),
          // Wordmark: fades + slides up while the logo is still settling.
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
              .fadeIn(delay: _wordmarkDelayMs.ms, duration: _wordmarkMs.ms)
              .moveY(
                begin: 8,
                end: 0,
                delay: _wordmarkDelayMs.ms,
                duration: _wordmarkMs.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 10),
          // Tagline: last to arrive, and therefore the beat the dwell is
          // measured against.
          Text(
            'A path home',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: gold.withValues(alpha: 0.85),
              letterSpacing: 4,
            ),
          ).animate().fadeIn(delay: _taglineDelayMs.ms, duration: _taglineMs.ms),
        ],
      ),
    );
  }
}
