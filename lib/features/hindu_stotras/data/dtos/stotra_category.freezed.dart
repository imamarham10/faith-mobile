// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stotra_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StotraCategory {

 String get id; String get slug; String get name; String? get deityKey; DateTime? get createdAt; int get stotraCount;
/// Create a copy of StotraCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StotraCategoryCopyWith<StotraCategory> get copyWith => _$StotraCategoryCopyWithImpl<StotraCategory>(this as StotraCategory, _$identity);

  /// Serializes this StotraCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StotraCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.stotraCount, stotraCount) || other.stotraCount == stotraCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,deityKey,createdAt,stotraCount);

@override
String toString() {
  return 'StotraCategory(id: $id, slug: $slug, name: $name, deityKey: $deityKey, createdAt: $createdAt, stotraCount: $stotraCount)';
}


}

/// @nodoc
abstract mixin class $StotraCategoryCopyWith<$Res>  {
  factory $StotraCategoryCopyWith(StotraCategory value, $Res Function(StotraCategory) _then) = _$StotraCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String? deityKey, DateTime? createdAt, int stotraCount
});




}
/// @nodoc
class _$StotraCategoryCopyWithImpl<$Res>
    implements $StotraCategoryCopyWith<$Res> {
  _$StotraCategoryCopyWithImpl(this._self, this._then);

  final StotraCategory _self;
  final $Res Function(StotraCategory) _then;

/// Create a copy of StotraCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? deityKey = freezed,Object? createdAt = freezed,Object? stotraCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stotraCount: null == stotraCount ? _self.stotraCount : stotraCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StotraCategory].
extension StotraCategoryPatterns on StotraCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StotraCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StotraCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StotraCategory value)  $default,){
final _that = this;
switch (_that) {
case _StotraCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StotraCategory value)?  $default,){
final _that = this;
switch (_that) {
case _StotraCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String? deityKey,  DateTime? createdAt,  int stotraCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StotraCategory() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.deityKey,_that.createdAt,_that.stotraCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String? deityKey,  DateTime? createdAt,  int stotraCount)  $default,) {final _that = this;
switch (_that) {
case _StotraCategory():
return $default(_that.id,_that.slug,_that.name,_that.deityKey,_that.createdAt,_that.stotraCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String? deityKey,  DateTime? createdAt,  int stotraCount)?  $default,) {final _that = this;
switch (_that) {
case _StotraCategory() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.deityKey,_that.createdAt,_that.stotraCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StotraCategory implements StotraCategory {
  const _StotraCategory({required this.id, required this.slug, required this.name, this.deityKey, this.createdAt, this.stotraCount = 0});
  factory _StotraCategory.fromJson(Map<String, dynamic> json) => _$StotraCategoryFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String name;
@override final  String? deityKey;
@override final  DateTime? createdAt;
@override@JsonKey() final  int stotraCount;

/// Create a copy of StotraCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StotraCategoryCopyWith<_StotraCategory> get copyWith => __$StotraCategoryCopyWithImpl<_StotraCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StotraCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StotraCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.stotraCount, stotraCount) || other.stotraCount == stotraCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,deityKey,createdAt,stotraCount);

@override
String toString() {
  return 'StotraCategory(id: $id, slug: $slug, name: $name, deityKey: $deityKey, createdAt: $createdAt, stotraCount: $stotraCount)';
}


}

/// @nodoc
abstract mixin class _$StotraCategoryCopyWith<$Res> implements $StotraCategoryCopyWith<$Res> {
  factory _$StotraCategoryCopyWith(_StotraCategory value, $Res Function(_StotraCategory) _then) = __$StotraCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String? deityKey, DateTime? createdAt, int stotraCount
});




}
/// @nodoc
class __$StotraCategoryCopyWithImpl<$Res>
    implements _$StotraCategoryCopyWith<$Res> {
  __$StotraCategoryCopyWithImpl(this._self, this._then);

  final _StotraCategory _self;
  final $Res Function(_StotraCategory) _then;

/// Create a copy of StotraCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? deityKey = freezed,Object? createdAt = freezed,Object? stotraCount = null,}) {
  return _then(_StotraCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stotraCount: null == stotraCount ? _self.stotraCount : stotraCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StotraCategoryRef {

 String get slug; String get name;
/// Create a copy of StotraCategoryRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StotraCategoryRefCopyWith<StotraCategoryRef> get copyWith => _$StotraCategoryRefCopyWithImpl<StotraCategoryRef>(this as StotraCategoryRef, _$identity);

  /// Serializes this StotraCategoryRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StotraCategoryRef&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name);

@override
String toString() {
  return 'StotraCategoryRef(slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class $StotraCategoryRefCopyWith<$Res>  {
  factory $StotraCategoryRefCopyWith(StotraCategoryRef value, $Res Function(StotraCategoryRef) _then) = _$StotraCategoryRefCopyWithImpl;
@useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class _$StotraCategoryRefCopyWithImpl<$Res>
    implements $StotraCategoryRefCopyWith<$Res> {
  _$StotraCategoryRefCopyWithImpl(this._self, this._then);

  final StotraCategoryRef _self;
  final $Res Function(StotraCategoryRef) _then;

/// Create a copy of StotraCategoryRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StotraCategoryRef].
extension StotraCategoryRefPatterns on StotraCategoryRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StotraCategoryRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StotraCategoryRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StotraCategoryRef value)  $default,){
final _that = this;
switch (_that) {
case _StotraCategoryRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StotraCategoryRef value)?  $default,){
final _that = this;
switch (_that) {
case _StotraCategoryRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StotraCategoryRef() when $default != null:
return $default(_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String name)  $default,) {final _that = this;
switch (_that) {
case _StotraCategoryRef():
return $default(_that.slug,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String name)?  $default,) {final _that = this;
switch (_that) {
case _StotraCategoryRef() when $default != null:
return $default(_that.slug,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StotraCategoryRef implements StotraCategoryRef {
  const _StotraCategoryRef({required this.slug, required this.name});
  factory _StotraCategoryRef.fromJson(Map<String, dynamic> json) => _$StotraCategoryRefFromJson(json);

@override final  String slug;
@override final  String name;

/// Create a copy of StotraCategoryRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StotraCategoryRefCopyWith<_StotraCategoryRef> get copyWith => __$StotraCategoryRefCopyWithImpl<_StotraCategoryRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StotraCategoryRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StotraCategoryRef&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name);

@override
String toString() {
  return 'StotraCategoryRef(slug: $slug, name: $name)';
}


}

/// @nodoc
abstract mixin class _$StotraCategoryRefCopyWith<$Res> implements $StotraCategoryRefCopyWith<$Res> {
  factory _$StotraCategoryRefCopyWith(_StotraCategoryRef value, $Res Function(_StotraCategoryRef) _then) = __$StotraCategoryRefCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name
});




}
/// @nodoc
class __$StotraCategoryRefCopyWithImpl<$Res>
    implements _$StotraCategoryRefCopyWith<$Res> {
  __$StotraCategoryRefCopyWithImpl(this._self, this._then);

  final _StotraCategoryRef _self;
  final $Res Function(_StotraCategoryRef) _then;

/// Create a copy of StotraCategoryRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,}) {
  return _then(_StotraCategoryRef(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
