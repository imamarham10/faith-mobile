import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_spacing.dart';
import '../telemetry/telemetry.dart';
import '../telemetry/telemetry_vocabulary.dart';
import 'location_disclosure.dart';
import 'location_service.dart';

/// The single entry point for obtaining location access.
///
/// Shows the Play-required prominent disclosure before the system dialog the
/// first time, then requests permission. Returns whether the app ended up
/// with location access.
///
/// Every "Enable location" affordance in the app calls this. Nothing else
/// may call [LocationService.requestPermission] directly: routing through one
/// function is what makes "the disclosure is always shown first" a property
/// of the code rather than a convention someone has to remember.
Future<bool> requestLocationAccess(BuildContext context, WidgetRef ref) async {
  final service = ref.read(locationServiceProvider);
  final disclosure = ref.read(locationDisclosureProvider);

  final step = nextLocationAccessStep(
    hasPermission: await service.hasPermission(),
    disclosureAccepted: await disclosure.wasAccepted,
  );

  final analytics = Telemetry.instance.analytics;

  switch (step) {
    case LocationAccessStep.ready:
      return true;

    case LocationAccessStep.showDisclosure:
      if (!context.mounted) return false;
      // A prompt flow is now actually starting, which is the denominator
      // worth having: how many people we ask, versus how many end up
      // granting. The coordinate itself is never involved — there is no
      // analytics parameter in this app capable of carrying one.
      unawaited(analytics.permissionRequested(AnalyticsPermission.location));
      final accepted = await showLocationDisclosure(context);
      if (!accepted) {
        // Declined at *our* disclosure, before the OS dialog was ever
        // shown. Worth separating from an OS denial: one is our copy
        // failing to persuade, the other is the system dialog.
        unawaited(
          analytics.permissionResolved(
            AnalyticsPermission.location,
            AnalyticsPermissionOutcome.dismissed,
          ),
        );
        return false;
      }
      await disclosure.accept();

    case LocationAccessStep.requestPermission:
      unawaited(analytics.permissionRequested(AnalyticsPermission.location));
  }

  final granted = await service.requestPermission();
  unawaited(
    analytics.permissionResolved(
      AnalyticsPermission.location,
      granted
          ? AnalyticsPermissionOutcome.granted
          : AnalyticsPermissionOutcome.denied,
    ),
  );
  return granted;
}

/// Presents the prominent disclosure. Resolves to whether the user agreed to
/// continue to the system permission dialog.
///
/// Dismissing by tapping outside counts as "not now" — a disclosure the user
/// swiped away is not consent.
Future<bool> showLocationDisclosure(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => const LocationDisclosureDialog(),
    ) ??
    false;

/// Google Play's Location Permissions policy requires an in-app disclosure,
/// shown before the runtime request and independently of the privacy policy,
/// that states what is accessed and which feature needs it.
///
/// The wording here is checked against what the code actually does:
///
///   * Prayer times, panchang and puja timings come from
///     `PrayersRepository.getTimes` / the Hindu repositories, which send
///     `lat` and `lng` as query parameters to Siraat's API — so coordinates
///     **do** leave the device, and the copy says so.
///   * The Qibla bearing is `QiblaRepository.computeLocally` — on-device,
///     never transmitted.
///   * Scheduled prayer reminders are computed on-device too
///     (`safePrayerDaysFor`), which is why they survive with no network.
///   * Nothing writes the `UserLocation` table — the only reference to it in
///     the backend is a cascade delete in `account.service.ts` — so
///     coordinates are not stored against the account.
///
/// If any of those change, this text is part of the change.
class LocationDisclosureDialog extends StatelessWidget {
  const LocationDisclosureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AlertDialog(
      icon: Icon(Icons.place_outlined, color: cs.primary),
      title: const Text('Siraat would like your location'),
      // Scrollable because the body is long and must stay fully readable at
      // large text scales — a disclosure the user cannot read in full is not
      // a disclosure.
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Prayer times change with where you are, and the Qibla compass '
              'needs to know where you are pointing from.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.base),
            const _DisclosurePoint(
              icon: Icons.schedule_rounded,
              text:
                  'Your approximate location is sent to Siraat’s servers to '
                  'work out prayer, panchang and puja times for your area. '
                  'It is not saved to your account, and it is never used for '
                  'advertising or shared with anyone else.',
            ),
            const SizedBox(height: AppSpacing.md),
            const _DisclosurePoint(
              icon: Icons.explore_outlined,
              text:
                  'The Qibla direction and your prayer reminders are worked '
                  'out on this device and are not sent anywhere.',
            ),
            const SizedBox(height: AppSpacing.md),
            const _DisclosurePoint(
              icon: Icons.visibility_outlined,
              text:
                  'Siraat only reads your location while you are using the '
                  'app — never in the background, and never while it is '
                  'closed.',
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'You can say no and keep using Siraat. Prayer times just won’t '
              'be local to you, and the Qibla compass won’t work.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop(false);
          },
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).pop(true);
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}

class _DisclosurePoint extends StatelessWidget {
  const _DisclosurePoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Decorative: the sentence beside it carries the whole meaning, so
        // leaving it unlabelled keeps a screen reader from announcing noise
        // before every point.
        ExcludeSemantics(
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}
