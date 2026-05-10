// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remedy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Remedy {

 String get id;/// `verse` | `dua` | `hadith`. `null` when the API doesn't classify.
 String? get kind; String get arabicText; String? get transliteration; String get translation; String? get source;
/// Create a copy of Remedy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemedyCopyWith<Remedy> get copyWith => _$RemedyCopyWithImpl<Remedy>(this as Remedy, _$identity);

  /// Serializes this Remedy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Remedy&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,arabicText,transliteration,translation,source);

@override
String toString() {
  return 'Remedy(id: $id, kind: $kind, arabicText: $arabicText, transliteration: $transliteration, translation: $translation, source: $source)';
}


}

/// @nodoc
abstract mixin class $RemedyCopyWith<$Res>  {
  factory $RemedyCopyWith(Remedy value, $Res Function(Remedy) _then) = _$RemedyCopyWithImpl;
@useResult
$Res call({
 String id, String? kind, String arabicText, String? transliteration, String translation, String? source
});




}
/// @nodoc
class _$RemedyCopyWithImpl<$Res>
    implements $RemedyCopyWith<$Res> {
  _$RemedyCopyWithImpl(this._self, this._then);

  final Remedy _self;
  final $Res Function(Remedy) _then;

/// Create a copy of Remedy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = freezed,Object? arabicText = null,Object? transliteration = freezed,Object? translation = null,Object? source = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Remedy].
extension RemedyPatterns on Remedy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Remedy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Remedy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Remedy value)  $default,){
final _that = this;
switch (_that) {
case _Remedy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Remedy value)?  $default,){
final _that = this;
switch (_that) {
case _Remedy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? kind,  String arabicText,  String? transliteration,  String translation,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Remedy() when $default != null:
return $default(_that.id,_that.kind,_that.arabicText,_that.transliteration,_that.translation,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? kind,  String arabicText,  String? transliteration,  String translation,  String? source)  $default,) {final _that = this;
switch (_that) {
case _Remedy():
return $default(_that.id,_that.kind,_that.arabicText,_that.transliteration,_that.translation,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? kind,  String arabicText,  String? transliteration,  String translation,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _Remedy() when $default != null:
return $default(_that.id,_that.kind,_that.arabicText,_that.transliteration,_that.translation,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Remedy implements Remedy {
  const _Remedy({required this.id, this.kind, required this.arabicText, this.transliteration, required this.translation, this.source});
  factory _Remedy.fromJson(Map<String, dynamic> json) => _$RemedyFromJson(json);

@override final  String id;
/// `verse` | `dua` | `hadith`. `null` when the API doesn't classify.
@override final  String? kind;
@override final  String arabicText;
@override final  String? transliteration;
@override final  String translation;
@override final  String? source;

/// Create a copy of Remedy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemedyCopyWith<_Remedy> get copyWith => __$RemedyCopyWithImpl<_Remedy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RemedyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Remedy&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,arabicText,transliteration,translation,source);

@override
String toString() {
  return 'Remedy(id: $id, kind: $kind, arabicText: $arabicText, transliteration: $transliteration, translation: $translation, source: $source)';
}


}

/// @nodoc
abstract mixin class _$RemedyCopyWith<$Res> implements $RemedyCopyWith<$Res> {
  factory _$RemedyCopyWith(_Remedy value, $Res Function(_Remedy) _then) = __$RemedyCopyWithImpl;
@override @useResult
$Res call({
 String id, String? kind, String arabicText, String? transliteration, String translation, String? source
});




}
/// @nodoc
class __$RemedyCopyWithImpl<$Res>
    implements _$RemedyCopyWith<$Res> {
  __$RemedyCopyWithImpl(this._self, this._then);

  final _Remedy _self;
  final $Res Function(_Remedy) _then;

/// Create a copy of Remedy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = freezed,Object? arabicText = null,Object? transliteration = freezed,Object? translation = null,Object? source = freezed,}) {
  return _then(_Remedy(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EmotionDetail {

 String get slug; String get name; String? get icon; String? get description; List<Remedy> get remedies;
/// Create a copy of EmotionDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmotionDetailCopyWith<EmotionDetail> get copyWith => _$EmotionDetailCopyWithImpl<EmotionDetail>(this as EmotionDetail, _$identity);

  /// Serializes this EmotionDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmotionDetail&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.remedies, remedies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,icon,description,const DeepCollectionEquality().hash(remedies));

@override
String toString() {
  return 'EmotionDetail(slug: $slug, name: $name, icon: $icon, description: $description, remedies: $remedies)';
}


}

/// @nodoc
abstract mixin class $EmotionDetailCopyWith<$Res>  {
  factory $EmotionDetailCopyWith(EmotionDetail value, $Res Function(EmotionDetail) _then) = _$EmotionDetailCopyWithImpl;
@useResult
$Res call({
 String slug, String name, String? icon, String? description, List<Remedy> remedies
});




}
/// @nodoc
class _$EmotionDetailCopyWithImpl<$Res>
    implements $EmotionDetailCopyWith<$Res> {
  _$EmotionDetailCopyWithImpl(this._self, this._then);

  final EmotionDetail _self;
  final $Res Function(EmotionDetail) _then;

/// Create a copy of EmotionDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,Object? icon = freezed,Object? description = freezed,Object? remedies = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remedies: null == remedies ? _self.remedies : remedies // ignore: cast_nullable_to_non_nullable
as List<Remedy>,
  ));
}

}


/// Adds pattern-matching-related methods to [EmotionDetail].
extension EmotionDetailPatterns on EmotionDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmotionDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmotionDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmotionDetail value)  $default,){
final _that = this;
switch (_that) {
case _EmotionDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmotionDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EmotionDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String name,  String? icon,  String? description,  List<Remedy> remedies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmotionDetail() when $default != null:
return $default(_that.slug,_that.name,_that.icon,_that.description,_that.remedies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String name,  String? icon,  String? description,  List<Remedy> remedies)  $default,) {final _that = this;
switch (_that) {
case _EmotionDetail():
return $default(_that.slug,_that.name,_that.icon,_that.description,_that.remedies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String name,  String? icon,  String? description,  List<Remedy> remedies)?  $default,) {final _that = this;
switch (_that) {
case _EmotionDetail() when $default != null:
return $default(_that.slug,_that.name,_that.icon,_that.description,_that.remedies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmotionDetail implements EmotionDetail {
  const _EmotionDetail({required this.slug, required this.name, this.icon, this.description, final  List<Remedy> remedies = const <Remedy>[]}): _remedies = remedies;
  factory _EmotionDetail.fromJson(Map<String, dynamic> json) => _$EmotionDetailFromJson(json);

@override final  String slug;
@override final  String name;
@override final  String? icon;
@override final  String? description;
 final  List<Remedy> _remedies;
@override@JsonKey() List<Remedy> get remedies {
  if (_remedies is EqualUnmodifiableListView) return _remedies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_remedies);
}


/// Create a copy of EmotionDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmotionDetailCopyWith<_EmotionDetail> get copyWith => __$EmotionDetailCopyWithImpl<_EmotionDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmotionDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmotionDetail&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._remedies, _remedies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,icon,description,const DeepCollectionEquality().hash(_remedies));

@override
String toString() {
  return 'EmotionDetail(slug: $slug, name: $name, icon: $icon, description: $description, remedies: $remedies)';
}


}

/// @nodoc
abstract mixin class _$EmotionDetailCopyWith<$Res> implements $EmotionDetailCopyWith<$Res> {
  factory _$EmotionDetailCopyWith(_EmotionDetail value, $Res Function(_EmotionDetail) _then) = __$EmotionDetailCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name, String? icon, String? description, List<Remedy> remedies
});




}
/// @nodoc
class __$EmotionDetailCopyWithImpl<$Res>
    implements _$EmotionDetailCopyWith<$Res> {
  __$EmotionDetailCopyWithImpl(this._self, this._then);

  final _EmotionDetail _self;
  final $Res Function(_EmotionDetail) _then;

/// Create a copy of EmotionDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,Object? icon = freezed,Object? description = freezed,Object? remedies = null,}) {
  return _then(_EmotionDetail(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remedies: null == remedies ? _self._remedies : remedies // ignore: cast_nullable_to_non_nullable
as List<Remedy>,
  ));
}


}

// dart format on
