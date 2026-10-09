import 'package:freezed_annotation/freezed_annotation.dart';

part 'stotra_category.freezed.dart';
part 'stotra_category.g.dart';

/// Category metadata — `GET /categories`. Mirrors the backend
/// `hindu_stotra_categories` table (seeded by deity: aarti, devi, ganesha,
/// hanuman, shiva, vishnu-krishna).
@freezed
abstract class StotraCategory with _$StotraCategory {
  const factory StotraCategory({
    required String id,
    required String slug,
    required String name,
    String? deityKey,
    DateTime? createdAt,
    @Default(0) int stotraCount,
  }) = _StotraCategory;

  factory StotraCategory.fromJson(Map<String, dynamic> json) =>
      _$StotraCategoryFromJson(json);
}

/// Minimal category reference nested on stotra list/detail payloads.
@freezed
abstract class StotraCategoryRef with _$StotraCategoryRef {
  const factory StotraCategoryRef({
    required String slug,
    required String name,
  }) = _StotraCategoryRef;

  factory StotraCategoryRef.fromJson(Map<String, dynamic> json) =>
      _$StotraCategoryRefFromJson(json);
}
