// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dua_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DuaCategory {

 String get id; String get name; String? get nameArabic; String? get description; int get count;
/// Create a copy of DuaCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuaCategoryCopyWith<DuaCategory> get copyWith => _$DuaCategoryCopyWithImpl<DuaCategory>(this as DuaCategory, _$identity);

  /// Serializes this DuaCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuaCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.description, description) || other.description == description)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameArabic,description,count);

@override
String toString() {
  return 'DuaCategory(id: $id, name: $name, nameArabic: $nameArabic, description: $description, count: $count)';
}


}

/// @nodoc
abstract mixin class $DuaCategoryCopyWith<$Res>  {
  factory $DuaCategoryCopyWith(DuaCategory value, $Res Function(DuaCategory) _then) = _$DuaCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? nameArabic, String? description, int count
});




}
/// @nodoc
class _$DuaCategoryCopyWithImpl<$Res>
    implements $DuaCategoryCopyWith<$Res> {
  _$DuaCategoryCopyWithImpl(this._self, this._then);

  final DuaCategory _self;
  final $Res Function(DuaCategory) _then;

/// Create a copy of DuaCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameArabic = freezed,Object? description = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameArabic: freezed == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DuaCategory].
extension DuaCategoryPatterns on DuaCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuaCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuaCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuaCategory value)  $default,){
final _that = this;
switch (_that) {
case _DuaCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuaCategory value)?  $default,){
final _that = this;
switch (_that) {
case _DuaCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? nameArabic,  String? description,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuaCategory() when $default != null:
return $default(_that.id,_that.name,_that.nameArabic,_that.description,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? nameArabic,  String? description,  int count)  $default,) {final _that = this;
switch (_that) {
case _DuaCategory():
return $default(_that.id,_that.name,_that.nameArabic,_that.description,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? nameArabic,  String? description,  int count)?  $default,) {final _that = this;
switch (_that) {
case _DuaCategory() when $default != null:
return $default(_that.id,_that.name,_that.nameArabic,_that.description,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuaCategory implements DuaCategory {
  const _DuaCategory({required this.id, required this.name, this.nameArabic, this.description, this.count = 0});
  factory _DuaCategory.fromJson(Map<String, dynamic> json) => _$DuaCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? nameArabic;
@override final  String? description;
@override@JsonKey() final  int count;

/// Create a copy of DuaCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuaCategoryCopyWith<_DuaCategory> get copyWith => __$DuaCategoryCopyWithImpl<_DuaCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuaCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuaCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.description, description) || other.description == description)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameArabic,description,count);

@override
String toString() {
  return 'DuaCategory(id: $id, name: $name, nameArabic: $nameArabic, description: $description, count: $count)';
}


}

/// @nodoc
abstract mixin class _$DuaCategoryCopyWith<$Res> implements $DuaCategoryCopyWith<$Res> {
  factory _$DuaCategoryCopyWith(_DuaCategory value, $Res Function(_DuaCategory) _then) = __$DuaCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? nameArabic, String? description, int count
});




}
/// @nodoc
class __$DuaCategoryCopyWithImpl<$Res>
    implements _$DuaCategoryCopyWith<$Res> {
  __$DuaCategoryCopyWithImpl(this._self, this._then);

  final _DuaCategory _self;
  final $Res Function(_DuaCategory) _then;

/// Create a copy of DuaCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameArabic = freezed,Object? description = freezed,Object? count = null,}) {
  return _then(_DuaCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameArabic: freezed == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
