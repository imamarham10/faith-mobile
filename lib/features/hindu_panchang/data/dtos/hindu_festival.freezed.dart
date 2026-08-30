// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hindu_festival.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HinduFestival {

 String get id; String get slug; String get nameEnglish; String? get nameSanskrit; String? get nameHindi; String? get deityKey; List<String> get regions; String? get description; DateTime? get createdAt;
/// Create a copy of HinduFestival
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HinduFestivalCopyWith<HinduFestival> get copyWith => _$HinduFestivalCopyWithImpl<HinduFestival>(this as HinduFestival, _$identity);

  /// Serializes this HinduFestival to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HinduFestival&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&const DeepCollectionEquality().equals(other.regions, regions)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameSanskrit,nameHindi,deityKey,const DeepCollectionEquality().hash(regions),description,createdAt);

@override
String toString() {
  return 'HinduFestival(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit, nameHindi: $nameHindi, deityKey: $deityKey, regions: $regions, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $HinduFestivalCopyWith<$Res>  {
  factory $HinduFestivalCopyWith(HinduFestival value, $Res Function(HinduFestival) _then) = _$HinduFestivalCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String nameEnglish, String? nameSanskrit, String? nameHindi, String? deityKey, List<String> regions, String? description, DateTime? createdAt
});




}
/// @nodoc
class _$HinduFestivalCopyWithImpl<$Res>
    implements $HinduFestivalCopyWith<$Res> {
  _$HinduFestivalCopyWithImpl(this._self, this._then);

  final HinduFestival _self;
  final $Res Function(HinduFestival) _then;

/// Create a copy of HinduFestival
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = freezed,Object? nameHindi = freezed,Object? deityKey = freezed,Object? regions = null,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,regions: null == regions ? _self.regions : regions // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HinduFestival].
extension HinduFestivalPatterns on HinduFestival {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HinduFestival value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HinduFestival() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HinduFestival value)  $default,){
final _that = this;
switch (_that) {
case _HinduFestival():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HinduFestival value)?  $default,){
final _that = this;
switch (_that) {
case _HinduFestival() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String? nameSanskrit,  String? nameHindi,  String? deityKey,  List<String> regions,  String? description,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HinduFestival() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.nameHindi,_that.deityKey,_that.regions,_that.description,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String? nameSanskrit,  String? nameHindi,  String? deityKey,  List<String> regions,  String? description,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _HinduFestival():
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.nameHindi,_that.deityKey,_that.regions,_that.description,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String nameEnglish,  String? nameSanskrit,  String? nameHindi,  String? deityKey,  List<String> regions,  String? description,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _HinduFestival() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.nameHindi,_that.deityKey,_that.regions,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HinduFestival implements HinduFestival {
  const _HinduFestival({required this.id, required this.slug, required this.nameEnglish, this.nameSanskrit, this.nameHindi, this.deityKey, final  List<String> regions = const <String>[], this.description, this.createdAt}): _regions = regions;
  factory _HinduFestival.fromJson(Map<String, dynamic> json) => _$HinduFestivalFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String nameEnglish;
@override final  String? nameSanskrit;
@override final  String? nameHindi;
@override final  String? deityKey;
 final  List<String> _regions;
@override@JsonKey() List<String> get regions {
  if (_regions is EqualUnmodifiableListView) return _regions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_regions);
}

@override final  String? description;
@override final  DateTime? createdAt;

/// Create a copy of HinduFestival
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HinduFestivalCopyWith<_HinduFestival> get copyWith => __$HinduFestivalCopyWithImpl<_HinduFestival>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HinduFestivalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HinduFestival&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&const DeepCollectionEquality().equals(other._regions, _regions)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameSanskrit,nameHindi,deityKey,const DeepCollectionEquality().hash(_regions),description,createdAt);

@override
String toString() {
  return 'HinduFestival(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit, nameHindi: $nameHindi, deityKey: $deityKey, regions: $regions, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HinduFestivalCopyWith<$Res> implements $HinduFestivalCopyWith<$Res> {
  factory _$HinduFestivalCopyWith(_HinduFestival value, $Res Function(_HinduFestival) _then) = __$HinduFestivalCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String nameEnglish, String? nameSanskrit, String? nameHindi, String? deityKey, List<String> regions, String? description, DateTime? createdAt
});




}
/// @nodoc
class __$HinduFestivalCopyWithImpl<$Res>
    implements _$HinduFestivalCopyWith<$Res> {
  __$HinduFestivalCopyWithImpl(this._self, this._then);

  final _HinduFestival _self;
  final $Res Function(_HinduFestival) _then;

/// Create a copy of HinduFestival
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = freezed,Object? nameHindi = freezed,Object? deityKey = freezed,Object? regions = null,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(_HinduFestival(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,regions: null == regions ? _self._regions : regions // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
