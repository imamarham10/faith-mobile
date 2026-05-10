import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/location/location_service.dart';
import '../../data/dtos/qibla_data.dart';
import '../../data/qibla_repository.dart';

part 'qibla_controller.freezed.dart';
part 'qibla_controller.g.dart';

/// Combined snapshot the compass screen renders against.
@freezed
abstract class QiblaSnapshot with _$QiblaSnapshot {
  const factory QiblaSnapshot({
    required QiblaData qibla,

    /// Smoothed device heading (degrees, 0..360, clockwise from north).
    /// `null` when the platform has no usable magnetometer (e.g. simulator).
    required double? deviceHeading,

    /// Whether the latest sensor sample reported low accuracy.
    required bool needsCalibration,
  }) = _QiblaSnapshot;
}

/// Sentinel error for the screen to render the "no compass" state.
class CompassUnavailableException implements Exception {
  const CompassUnavailableException();
  @override
  String toString() => 'CompassUnavailableException';
}

/// Sentinel error for the screen to render the "permission denied" state.
class LocationUnavailableException implements Exception {
  const LocationUnavailableException();
  @override
  String toString() => 'LocationUnavailableException';
}

/// Streams a [QiblaSnapshot] combining:
///   * one-shot location lookup (Qibla bearing is location-anchored, doesn't
///     need to track movement during a session)
///   * live, low-pass-filtered compass heading
///
/// The Riverpod auto-dispose handles subscription teardown when the screen
/// pops.
@riverpod
Stream<QiblaSnapshot> qiblaStream(Ref ref) async* {
  final location = ref.watch(locationServiceProvider);
  final repo = ref.watch(qiblaRepositoryProvider);

  final pos = await location.currentPosition();
  if (pos == null) {
    throw const LocationUnavailableException();
  }

  final qibla = repo.computeLocally(lat: pos.latitude, lng: pos.longitude);

  final compassEvents = FlutterCompass.events;
  if (compassEvents == null) {
    // Unsupported platform — emit a final snapshot without heading so the UI
    // can show distance/coords + a "no compass" hint.
    yield QiblaSnapshot(
      qibla: qibla,
      deviceHeading: null,
      needsCalibration: false,
    );
    return;
  }

  // Low-pass filter state — eased toward each new sample to suppress jitter.
  double? smoothed;
  const alpha = 0.3;

  await for (final event in compassEvents) {
    final raw = event.heading;
    final accuracy = event.accuracy;
    // `flutter_compass` only reports accuracy on iOS; on Android it's always
    // null. Treat null/negative as "we don't know" (don't flag), and only
    // flag when we explicitly have a poor reading (> 25°). raw == null below
    // is the real "no heading yet" signal.
    final needsCalibration =
        accuracy != null && accuracy >= 0 && accuracy > 25;

    if (raw == null) {
      yield QiblaSnapshot(
        qibla: qibla,
        deviceHeading: smoothed,
        needsCalibration: true,
      );
      continue;
    }

    // Wrap-aware low-pass: shift the new sample into the same revolution as
    // the smoothed value before blending so we don't average across the
    // 0/360 seam.
    final prev = smoothed;
    if (prev == null) {
      smoothed = raw;
    } else {
      var delta = raw - prev;
      if (delta > 180) delta -= 360;
      if (delta < -180) delta += 360;
      var next = (prev + alpha * delta) % 360;
      if (next < 0) next += 360;
      smoothed = next;
    }

    yield QiblaSnapshot(
      qibla: qibla,
      deviceHeading: smoothed,
      needsCalibration: needsCalibration,
    );
  }
}
