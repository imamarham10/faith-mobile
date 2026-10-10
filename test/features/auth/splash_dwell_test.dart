import 'package:faith_mobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

/// The splash dwell is the second-largest item in the cold-start budget and
/// it buys exactly one thing: the brand reveal gets to finish. These tests
/// hold that bargain honest from both sides — the dwell must cover the
/// reveal, and it must not exceed it.
void main() {
  group('the splash dwell matches the brand reveal', () {
    test('no arrival is still animating when the router redirects', () {
      // Routing away mid-arrival shows a half-drawn lockup: a wordmark at
      // 60% opacity, or a tagline that never appears at all. That is worse
      // than the wait it saves.
      for (final arrival in splashArrivals) {
        expect(
          arrival.endsAtMs,
          lessThanOrEqualTo(kSplashDwell.inMilliseconds),
          reason:
              'the "${arrival.name}" arrival ends at ${arrival.endsAtMs}ms, '
              'after the ${kSplashDwell.inMilliseconds}ms dwell — it would '
              'be cut off mid-animation on every cold start',
        );
      }
    });

    test('the dwell is not padded past the slowest arrival', () {
      // The other direction, and the one that regresses quietly: a dwell
      // longer than the reveal is dead time with nothing on the wire. It
      // must be *equal* to the slowest beat, never merely greater.
      final slowest = splashArrivals
          .map((a) => a.endsAtMs)
          .reduce((a, b) => a > b ? a : b);

      expect(
        kSplashDwell.inMilliseconds,
        slowest,
        reason:
            'the dwell should end the instant the reveal does; '
            '${kSplashDwell.inMilliseconds - slowest}ms of it is a wait '
            'that shows the user nothing new',
      );
    });

    test('the reveal still staggers rather than landing all at once', () {
      // A half-second reveal only reads as deliberate because the three
      // elements arrive in sequence. Collapse the stagger and the same
      // duration reads as a flash, which is the failure mode that makes
      // shortening a splash feel broken rather than fast.
      final distinctEndings = splashArrivals.map((a) => a.endsAtMs).toSet();

      expect(
        distinctEndings.length,
        greaterThanOrEqualTo(3),
        reason:
            'the arrivals land at $distinctEndings — a staggered reveal '
            'needs at least three distinct beats',
      );
    });
  });
}
