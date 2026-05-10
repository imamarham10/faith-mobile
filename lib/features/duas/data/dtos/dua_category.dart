import 'package:freezed_annotation/freezed_annotation.dart';

part 'dua_category.freezed.dart';
part 'dua_category.g.dart';

/// Category metadata for a dua collection.
///
/// Mirrors the backend `dua_categories` table. The optional `count`
/// field is computed client-side from the duas list when not provided
/// by the API.
@freezed
abstract class DuaCategory with _$DuaCategory {
  const factory DuaCategory({
    required String id,
    required String name,
    String? nameArabic,
    String? description,
    @Default(0) int count,
  }) = _DuaCategory;

  factory DuaCategory.fromJson(Map<String, dynamic> json) =>
      _$DuaCategoryFromJson(json);
}
