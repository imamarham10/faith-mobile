// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emotion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Emotion {

 String get id; String get name; String get slug; String? get icon; String? get description;
/// Create a copy of Emotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmotionCopyWith<Emotion> get copyWith => _$EmotionCopyWithImpl<Emotion>(this as Emotion, _$identity);

  /// Serializes this Emotion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Emotion&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,icon,description);

@override
String toString() {
  return 'Emotion(id: $id, name: $name, slug: $slug, icon: $icon, description: $description)';
}


}

/// @nodoc
abstract mixin class $EmotionCopyWith<$Res>  {
  factory $EmotionCopyWith(Emotion value, $Res Function(Emotion) _then) = _$EmotionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String? icon, String? description
});




}
/// @nodoc
class _$EmotionCopyWithImpl<$Res>
    implements $EmotionCopyWith<$Res> {
  _$EmotionCopyWithImpl(this._self, this._then);

  final Emotion _self;
  final $Res Function(Emotion) _then;

/// Create a copy of Emotion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? icon = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Emotion].
extension EmotionPatterns on Emotion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Emotion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Emotion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Emotion value)  $default,){
final _that = this;
switch (_that) {
case _Emotion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Emotion value)?  $default,){
final _that = this;
switch (_that) {
case _Emotion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? icon,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Emotion() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.icon,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? icon,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Emotion():
return $default(_that.id,_that.name,_that.slug,_that.icon,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String? icon,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Emotion() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.icon,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Emotion implements Emotion {
  const _Emotion({required this.id, required this.name, required this.slug, this.icon, this.description});
  factory _Emotion.fromJson(Map<String, dynamic> json) => _$EmotionFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String? icon;
@override final  String? description;

/// Create a copy of Emotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmotionCopyWith<_Emotion> get copyWith => __$EmotionCopyWithImpl<_Emotion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmotionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Emotion&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,icon,description);

@override
String toString() {
  return 'Emotion(id: $id, name: $name, slug: $slug, icon: $icon, description: $description)';
}


}

/// @nodoc
abstract mixin class _$EmotionCopyWith<$Res> implements $EmotionCopyWith<$Res> {
  factory _$EmotionCopyWith(_Emotion value, $Res Function(_Emotion) _then) = __$EmotionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String? icon, String? description
});




}
/// @nodoc
class __$EmotionCopyWithImpl<$Res>
    implements _$EmotionCopyWith<$Res> {
  __$EmotionCopyWithImpl(this._self, this._then);

  final _Emotion _self;
  final $Res Function(_Emotion) _then;

/// Create a copy of Emotion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? icon = freezed,Object? description = freezed,}) {
  return _then(_Emotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
