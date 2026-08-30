// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'japa_phrase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JapaPhrase {

 String get sanskrit; String get transliteration; String get english; String get category; String? get deityKey; int get recommendedCount;
/// Create a copy of JapaPhrase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JapaPhraseCopyWith<JapaPhrase> get copyWith => _$JapaPhraseCopyWithImpl<JapaPhrase>(this as JapaPhrase, _$identity);

  /// Serializes this JapaPhrase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JapaPhrase&&(identical(other.sanskrit, sanskrit) || other.sanskrit == sanskrit)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.english, english) || other.english == english)&&(identical(other.category, category) || other.category == category)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.recommendedCount, recommendedCount) || other.recommendedCount == recommendedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sanskrit,transliteration,english,category,deityKey,recommendedCount);

@override
String toString() {
  return 'JapaPhrase(sanskrit: $sanskrit, transliteration: $transliteration, english: $english, category: $category, deityKey: $deityKey, recommendedCount: $recommendedCount)';
}


}

/// @nodoc
abstract mixin class $JapaPhraseCopyWith<$Res>  {
  factory $JapaPhraseCopyWith(JapaPhrase value, $Res Function(JapaPhrase) _then) = _$JapaPhraseCopyWithImpl;
@useResult
$Res call({
 String sanskrit, String transliteration, String english, String category, String? deityKey, int recommendedCount
});




}
/// @nodoc
class _$JapaPhraseCopyWithImpl<$Res>
    implements $JapaPhraseCopyWith<$Res> {
  _$JapaPhraseCopyWithImpl(this._self, this._then);

  final JapaPhrase _self;
  final $Res Function(JapaPhrase) _then;

/// Create a copy of JapaPhrase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sanskrit = null,Object? transliteration = null,Object? english = null,Object? category = null,Object? deityKey = freezed,Object? recommendedCount = null,}) {
  return _then(_self.copyWith(
sanskrit: null == sanskrit ? _self.sanskrit : sanskrit // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,english: null == english ? _self.english : english // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,recommendedCount: null == recommendedCount ? _self.recommendedCount : recommendedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JapaPhrase].
extension JapaPhrasePatterns on JapaPhrase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JapaPhrase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JapaPhrase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JapaPhrase value)  $default,){
final _that = this;
switch (_that) {
case _JapaPhrase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JapaPhrase value)?  $default,){
final _that = this;
switch (_that) {
case _JapaPhrase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sanskrit,  String transliteration,  String english,  String category,  String? deityKey,  int recommendedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JapaPhrase() when $default != null:
return $default(_that.sanskrit,_that.transliteration,_that.english,_that.category,_that.deityKey,_that.recommendedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sanskrit,  String transliteration,  String english,  String category,  String? deityKey,  int recommendedCount)  $default,) {final _that = this;
switch (_that) {
case _JapaPhrase():
return $default(_that.sanskrit,_that.transliteration,_that.english,_that.category,_that.deityKey,_that.recommendedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sanskrit,  String transliteration,  String english,  String category,  String? deityKey,  int recommendedCount)?  $default,) {final _that = this;
switch (_that) {
case _JapaPhrase() when $default != null:
return $default(_that.sanskrit,_that.transliteration,_that.english,_that.category,_that.deityKey,_that.recommendedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JapaPhrase extends JapaPhrase {
  const _JapaPhrase({required this.sanskrit, required this.transliteration, required this.english, required this.category, this.deityKey, this.recommendedCount = 108}): super._();
  factory _JapaPhrase.fromJson(Map<String, dynamic> json) => _$JapaPhraseFromJson(json);

@override final  String sanskrit;
@override final  String transliteration;
@override final  String english;
@override final  String category;
@override final  String? deityKey;
@override@JsonKey() final  int recommendedCount;

/// Create a copy of JapaPhrase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JapaPhraseCopyWith<_JapaPhrase> get copyWith => __$JapaPhraseCopyWithImpl<_JapaPhrase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JapaPhraseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JapaPhrase&&(identical(other.sanskrit, sanskrit) || other.sanskrit == sanskrit)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.english, english) || other.english == english)&&(identical(other.category, category) || other.category == category)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.recommendedCount, recommendedCount) || other.recommendedCount == recommendedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sanskrit,transliteration,english,category,deityKey,recommendedCount);

@override
String toString() {
  return 'JapaPhrase(sanskrit: $sanskrit, transliteration: $transliteration, english: $english, category: $category, deityKey: $deityKey, recommendedCount: $recommendedCount)';
}


}

/// @nodoc
abstract mixin class _$JapaPhraseCopyWith<$Res> implements $JapaPhraseCopyWith<$Res> {
  factory _$JapaPhraseCopyWith(_JapaPhrase value, $Res Function(_JapaPhrase) _then) = __$JapaPhraseCopyWithImpl;
@override @useResult
$Res call({
 String sanskrit, String transliteration, String english, String category, String? deityKey, int recommendedCount
});




}
/// @nodoc
class __$JapaPhraseCopyWithImpl<$Res>
    implements _$JapaPhraseCopyWith<$Res> {
  __$JapaPhraseCopyWithImpl(this._self, this._then);

  final _JapaPhrase _self;
  final $Res Function(_JapaPhrase) _then;

/// Create a copy of JapaPhrase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sanskrit = null,Object? transliteration = null,Object? english = null,Object? category = null,Object? deityKey = freezed,Object? recommendedCount = null,}) {
  return _then(_JapaPhrase(
sanskrit: null == sanskrit ? _self.sanskrit : sanskrit // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,english: null == english ? _self.english : english // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,recommendedCount: null == recommendedCount ? _self.recommendedCount : recommendedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
