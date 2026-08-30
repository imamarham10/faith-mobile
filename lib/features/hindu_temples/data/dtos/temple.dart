import 'package:freezed_annotation/freezed_annotation.dart';

part 'temple.freezed.dart';
part 'temple.g.dart';

/// A temple — `GET /`, `GET /nearby`, `GET /:id`. Net-new module, no Islam
/// precedent. `distanceKm` is only ever populated by the `/nearby` endpoint
/// (server-computed, pre-sorted); the plain list/detail/favorites endpoints
/// never include it, hence nullable rather than a separate DTO.
///
/// `state`/`city`/`deityKey` are free-form nullable strings, not enums —
/// the backend has no fixed taxonomy for either (a `/states` endpoint
/// exists to enumerate real values; there's no equivalent `/deities`
/// endpoint, so deity filter values must be derived client-side from
/// whichever `deityKey`s appear across the loaded temple list).
@freezed
abstract class Temple with _$Temple {
  const factory Temple({
    required String id,
    required String name,
    String? deityKey,
    required double lat,
    required double lng,
    required String address,
    String? city,
    String? state,
    required String country,
    String? description,
    String? significance,
    @Default(<String>[]) List<String> photos,
    String? googlePlaceId,
    required String source,
    DateTime? createdAt,
    double? distanceKm,
  }) = _Temple;

  factory Temple.fromJson(Map<String, dynamic> json) => _$TempleFromJson(json);
}
