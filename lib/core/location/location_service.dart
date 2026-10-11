import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

/// Coordinate pair returned by [LocationService].
typedef LatLng = ({double latitude, double longitude});

/// Shared location boundary. Owned by `core/` because Prayers and Qibla
/// both consume it — neither feature should re-implement permission flow.
class LocationService {
  /// Whether "when in use" location access is already held. **Never
  /// prompts.**
  ///
  /// The non-prompting split is what makes the Play prominent-disclosure
  /// requirement enforceable. [currentPosition] is called from controller
  /// `build()` methods — `prayerTimesController`, `qiblaStream`, the
  /// panchang and puja controllers — which run with no `BuildContext` and
  /// no opportunity to explain anything. When that path could request
  /// permission, the first thing a new user saw on opening the app was a
  /// bare system location dialog: exactly the unexplained ask the policy
  /// forbids. Those controllers now resolve to "no location", the UI shows
  /// its existing enable-location affordance, and the request happens only
  /// behind `requestLocationAccess`, which shows the disclosure first.
  Future<bool> hasPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted || status.isLimited;
  }

  /// Shows the OS permission dialog. Returns whether access was granted.
  ///
  /// Call only via `requestLocationAccess`, which guarantees the prominent
  /// disclosure has been accepted first.
  Future<bool> requestPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted || status.isLimited;
  }

  /// Returns the device's current position, or `null` if permission is not
  /// held or the device couldn't fix a location. Never prompts.
  Future<LatLng?> currentPosition() async {
    if (!await hasPermission()) return null;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return (latitude: pos.latitude, longitude: pos.longitude);
    } on Object catch (e, st) {
      developer.log(
        'location lookup failed',
        name: 'location',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => LocationService();
