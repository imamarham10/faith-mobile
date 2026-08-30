// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hindu_emotion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HinduEmotion {

 String get id; String get slug; String get nameEnglish; String? get nameHindi; String? get icon; int get remedyCount;
/// Create a copy of HinduEmotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HinduEmotionCopyWith<HinduEmotion> get copyWith => _$HinduEmotionCopyWithImpl<HinduEmotion>(this as HinduEmotion, _$identity);

  /// Serializes this HinduEmotion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HinduEmotion&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.remedyCount, remedyCount) || other.remedyCount == remedyCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameHindi,icon,remedyCount);

@override
String toString() {
  return 'HinduEmotion(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameHindi: $nameHindi, icon: $icon, remedyCount: $remedyCount)';
}


}

/// @nodoc
abstract mixin class $HinduEmotionCopyWith<$Res>  {
  factory $HinduEmotionCopyWith(HinduEmotion value, $Res Function(HinduEmotion) _then) = _$HinduEmotionCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String nameEnglish, String? nameHindi, String? icon, int remedyCount
});




}
/// @nodoc
class _$HinduEmotionCopyWithImpl<$Res>
    implements $HinduEmotionCopyWith<$Res> {
  _$HinduEmotionCopyWithImpl(this._self, this._then);

  final HinduEmotion _self;
  final $Res Function(HinduEmotion) _then;

/// Create a copy of HinduEmotion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameHindi = freezed,Object? icon = freezed,Object? remedyCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,remedyCount: null == remedyCount ? _self.remedyCount : remedyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HinduEmotion].
extension HinduEmotionPatterns on HinduEmotion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HinduEmotion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HinduEmotion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HinduEmotion value)  $default,){
final _that = this;
switch (_that) {
case _HinduEmotion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HinduEmotion value)?  $default,){
final _that = this;
switch (_that) {
case _HinduEmotion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String? nameHindi,  String? icon,  int remedyCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HinduEmotion() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameHindi,_that.icon,_that.remedyCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String? nameHindi,  String? icon,  int remedyCount)  $default,) {final _that = this;
switch (_that) {
case _HinduEmotion():
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameHindi,_that.icon,_that.remedyCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String nameEnglish,  String? nameHindi,  String? icon,  int remedyCount)?  $default,) {final _that = this;
switch (_that) {
case _HinduEmotion() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameHindi,_that.icon,_that.remedyCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HinduEmotion implements HinduEmotion {
  const _HinduEmotion({required this.id, required this.slug, required this.nameEnglish, this.nameHindi, this.icon, this.remedyCount = 0});
  factory _HinduEmotion.fromJson(Map<String, dynamic> json) => _$HinduEmotionFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String nameEnglish;
@override final  String? nameHindi;
@override final  String? icon;
@override@JsonKey() final  int remedyCount;

/// Create a copy of HinduEmotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HinduEmotionCopyWith<_HinduEmotion> get copyWith => __$HinduEmotionCopyWithImpl<_HinduEmotion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HinduEmotionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HinduEmotion&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.remedyCount, remedyCount) || other.remedyCount == remedyCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameHindi,icon,remedyCount);

@override
String toString() {
  return 'HinduEmotion(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameHindi: $nameHindi, icon: $icon, remedyCount: $remedyCount)';
}


}

/// @nodoc
abstract mixin class _$HinduEmotionCopyWith<$Res> implements $HinduEmotionCopyWith<$Res> {
  factory _$HinduEmotionCopyWith(_HinduEmotion value, $Res Function(_HinduEmotion) _then) = __$HinduEmotionCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String nameEnglish, String? nameHindi, String? icon, int remedyCount
});




}
/// @nodoc
class __$HinduEmotionCopyWithImpl<$Res>
    implements _$HinduEmotionCopyWith<$Res> {
  __$HinduEmotionCopyWithImpl(this._self, this._then);

  final _HinduEmotion _self;
  final $Res Function(_HinduEmotion) _then;

/// Create a copy of HinduEmotion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameHindi = freezed,Object? icon = freezed,Object? remedyCount = null,}) {
  return _then(_HinduEmotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,remedyCount: null == remedyCount ? _self.remedyCount : remedyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$HinduEmotionDetail {

 String get slug; String get nameEnglish; String? get nameHindi; String? get icon; List<HinduRemedy> get remedies;
/// Create a copy of HinduEmotionDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HinduEmotionDetailCopyWith<HinduEmotionDetail> get copyWith => _$HinduEmotionDetailCopyWithImpl<HinduEmotionDetail>(this as HinduEmotionDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HinduEmotionDetail&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.remedies, remedies));
}


@override
int get hashCode => Object.hash(runtimeType,slug,nameEnglish,nameHindi,icon,const DeepCollectionEquality().hash(remedies));

@override
String toString() {
  return 'HinduEmotionDetail(slug: $slug, nameEnglish: $nameEnglish, nameHindi: $nameHindi, icon: $icon, remedies: $remedies)';
}


}

/// @nodoc
abstract mixin class $HinduEmotionDetailCopyWith<$Res>  {
  factory $HinduEmotionDetailCopyWith(HinduEmotionDetail value, $Res Function(HinduEmotionDetail) _then) = _$HinduEmotionDetailCopyWithImpl;
@useResult
$Res call({
 String slug, String nameEnglish, String? nameHindi, String? icon, List<HinduRemedy> remedies
});




}
/// @nodoc
class _$HinduEmotionDetailCopyWithImpl<$Res>
    implements $HinduEmotionDetailCopyWith<$Res> {
  _$HinduEmotionDetailCopyWithImpl(this._self, this._then);

  final HinduEmotionDetail _self;
  final $Res Function(HinduEmotionDetail) _then;

/// Create a copy of HinduEmotionDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? nameEnglish = null,Object? nameHindi = freezed,Object? icon = freezed,Object? remedies = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,remedies: null == remedies ? _self.remedies : remedies // ignore: cast_nullable_to_non_nullable
as List<HinduRemedy>,
  ));
}

}


/// Adds pattern-matching-related methods to [HinduEmotionDetail].
extension HinduEmotionDetailPatterns on HinduEmotionDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HinduEmotionDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HinduEmotionDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HinduEmotionDetail value)  $default,){
final _that = this;
switch (_that) {
case _HinduEmotionDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HinduEmotionDetail value)?  $default,){
final _that = this;
switch (_that) {
case _HinduEmotionDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String nameEnglish,  String? nameHindi,  String? icon,  List<HinduRemedy> remedies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HinduEmotionDetail() when $default != null:
return $default(_that.slug,_that.nameEnglish,_that.nameHindi,_that.icon,_that.remedies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String nameEnglish,  String? nameHindi,  String? icon,  List<HinduRemedy> remedies)  $default,) {final _that = this;
switch (_that) {
case _HinduEmotionDetail():
return $default(_that.slug,_that.nameEnglish,_that.nameHindi,_that.icon,_that.remedies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String nameEnglish,  String? nameHindi,  String? icon,  List<HinduRemedy> remedies)?  $default,) {final _that = this;
switch (_that) {
case _HinduEmotionDetail() when $default != null:
return $default(_that.slug,_that.nameEnglish,_that.nameHindi,_that.icon,_that.remedies);case _:
  return null;

}
}

}

/// @nodoc


class _HinduEmotionDetail implements HinduEmotionDetail {
  const _HinduEmotionDetail({required this.slug, required this.nameEnglish, this.nameHindi, this.icon, final  List<HinduRemedy> remedies = const <HinduRemedy>[]}): _remedies = remedies;
  

@override final  String slug;
@override final  String nameEnglish;
@override final  String? nameHindi;
@override final  String? icon;
 final  List<HinduRemedy> _remedies;
@override@JsonKey() List<HinduRemedy> get remedies {
  if (_remedies is EqualUnmodifiableListView) return _remedies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_remedies);
}


/// Create a copy of HinduEmotionDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HinduEmotionDetailCopyWith<_HinduEmotionDetail> get copyWith => __$HinduEmotionDetailCopyWithImpl<_HinduEmotionDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HinduEmotionDetail&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._remedies, _remedies));
}


@override
int get hashCode => Object.hash(runtimeType,slug,nameEnglish,nameHindi,icon,const DeepCollectionEquality().hash(_remedies));

@override
String toString() {
  return 'HinduEmotionDetail(slug: $slug, nameEnglish: $nameEnglish, nameHindi: $nameHindi, icon: $icon, remedies: $remedies)';
}


}

/// @nodoc
abstract mixin class _$HinduEmotionDetailCopyWith<$Res> implements $HinduEmotionDetailCopyWith<$Res> {
  factory _$HinduEmotionDetailCopyWith(_HinduEmotionDetail value, $Res Function(_HinduEmotionDetail) _then) = __$HinduEmotionDetailCopyWithImpl;
@override @useResult
$Res call({
 String slug, String nameEnglish, String? nameHindi, String? icon, List<HinduRemedy> remedies
});




}
/// @nodoc
class __$HinduEmotionDetailCopyWithImpl<$Res>
    implements _$HinduEmotionDetailCopyWith<$Res> {
  __$HinduEmotionDetailCopyWithImpl(this._self, this._then);

  final _HinduEmotionDetail _self;
  final $Res Function(_HinduEmotionDetail) _then;

/// Create a copy of HinduEmotionDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? nameEnglish = null,Object? nameHindi = freezed,Object? icon = freezed,Object? remedies = null,}) {
  return _then(_HinduEmotionDetail(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,remedies: null == remedies ? _self._remedies : remedies // ignore: cast_nullable_to_non_nullable
as List<HinduRemedy>,
  ));
}


}

// dart format on
