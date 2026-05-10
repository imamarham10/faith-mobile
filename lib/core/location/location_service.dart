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
  /// Requests "when in use" permission. Returns whether it was granted.
  Future<bool> ensurePermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted || status.isLimited;
  }

  /// Returns the device's current position, or `null` if permission was
  /// denied or the device couldn't fix a location.
  Future<LatLng?> currentPosition() async {
    if (!await ensurePermission()) return null;
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
