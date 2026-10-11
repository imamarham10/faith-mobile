// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'below_fold_gate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$belowFoldGateHash() => r'bc606fd08d2c0db1e643f17cd9f8a43cd4236b55';

/// Whether the Today screen's below-the-fold cards may start fetching yet.
///
/// Half of the Today screen's cold-start requests are for content nobody
/// has scrolled to — the verse and hadith on Islam, the shloka and katha on
/// Hindu. They were going out in the same burst as `activity/today` and
/// `activity/history`, which gate the habit loop, and on a `max: 10`
/// serverless pool everything in that burst degrades together: measured
/// against production, eight concurrent requests turned a 0.99s read into
/// 3.49s and a 0.76s read into 6.21s.
///
/// So the below-the-fold reads wait for the thing the user is actually
/// waiting for. [open] is called once the habit loop has painted — by
/// `WeekStripSection` and by nothing else, because it is the topmost and
/// therefore the only always-built consumer of the dashboard on Today; see
/// that widget for why the release lives there rather than with the goal
/// card. The deadline above is the backstop.
///
/// **Session-scoped and one-way.** Once open it stays open, so this costs
/// nothing on a tab switch back to Today or any later rebuild — it is a
/// cold-start measure and only a cold start pays it. `keepAlive` is what
/// makes that true: an auto-disposed gate would slam shut every time the
/// Today branch was torn down and re-defer content the user has already
/// seen.
///
/// Copied from [BelowFoldGate].
@ProviderFor(BelowFoldGate)
final belowFoldGateProvider = NotifierProvider<BelowFoldGate, bool>.internal(
  BelowFoldGate.new,
  name: r'belowFoldGateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$belowFoldGateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BelowFoldGate = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
