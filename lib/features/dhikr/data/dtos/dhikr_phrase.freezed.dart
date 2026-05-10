// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dhikr_phrase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DhikrPhrase {

 String get id; String get phraseArabic; String get phraseTransliteration; String get meaning; int get recommendedCount;
/// Create a copy of DhikrPhrase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DhikrPhraseCopyWith<DhikrPhrase> get copyWith => _$DhikrPhraseCopyWithImpl<DhikrPhrase>(this as DhikrPhrase, _$identity);

  /// Serializes this DhikrPhrase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DhikrPhrase&&(identical(other.id, id) || other.id == id)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseTransliteration, phraseTransliteration) || other.phraseTransliteration == phraseTransliteration)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.recommendedCount, recommendedCount) || other.recommendedCount == recommendedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phraseArabic,phraseTransliteration,meaning,recommendedCount);

@override
String toString() {
  return 'DhikrPhrase(id: $id, phraseArabic: $phraseArabic, phraseTransliteration: $phraseTransliteration, meaning: $meaning, recommendedCount: $recommendedCount)';
}


}

/// @nodoc
abstract mixin class $DhikrPhraseCopyWith<$Res>  {
  factory $DhikrPhraseCopyWith(DhikrPhrase value, $Res Function(DhikrPhrase) _then) = _$DhikrPhraseCopyWithImpl;
@useResult
$Res call({
 String id, String phraseArabic, String phraseTransliteration, String meaning, int recommendedCount
});




}
/// @nodoc
class _$DhikrPhraseCopyWithImpl<$Res>
    implements $DhikrPhraseCopyWith<$Res> {
  _$DhikrPhraseCopyWithImpl(this._self, this._then);

  final DhikrPhrase _self;
  final $Res Function(DhikrPhrase) _then;

/// Create a copy of DhikrPhrase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phraseArabic = null,Object? phraseTransliteration = null,Object? meaning = null,Object? recommendedCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phraseArabic: null == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String,phraseTransliteration: null == phraseTransliteration ? _self.phraseTransliteration : phraseTransliteration // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,recommendedCount: null == recommendedCount ? _self.recommendedCount : recommendedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DhikrPhrase].
extension DhikrPhrasePatterns on DhikrPhrase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DhikrPhrase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DhikrPhrase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DhikrPhrase value)  $default,){
final _that = this;
switch (_that) {
case _DhikrPhrase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DhikrPhrase value)?  $default,){
final _that = this;
switch (_that) {
case _DhikrPhrase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phraseArabic,  String phraseTransliteration,  String meaning,  int recommendedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DhikrPhrase() when $default != null:
return $default(_that.id,_that.phraseArabic,_that.phraseTransliteration,_that.meaning,_that.recommendedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phraseArabic,  String phraseTransliteration,  String meaning,  int recommendedCount)  $default,) {final _that = this;
switch (_that) {
case _DhikrPhrase():
return $default(_that.id,_that.phraseArabic,_that.phraseTransliteration,_that.meaning,_that.recommendedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phraseArabic,  String phraseTransliteration,  String meaning,  int recommendedCount)?  $default,) {final _that = this;
switch (_that) {
case _DhikrPhrase() when $default != null:
return $default(_that.id,_that.phraseArabic,_that.phraseTransliteration,_that.meaning,_that.recommendedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DhikrPhrase implements DhikrPhrase {
  const _DhikrPhrase({required this.id, required this.phraseArabic, required this.phraseTransliteration, required this.meaning, this.recommendedCount = 33});
  factory _DhikrPhrase.fromJson(Map<String, dynamic> json) => _$DhikrPhraseFromJson(json);

@override final  String id;
@override final  String phraseArabic;
@override final  String phraseTransliteration;
@override final  String meaning;
@override@JsonKey() final  int recommendedCount;

/// Create a copy of DhikrPhrase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DhikrPhraseCopyWith<_DhikrPhrase> get copyWith => __$DhikrPhraseCopyWithImpl<_DhikrPhrase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DhikrPhraseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DhikrPhrase&&(identical(other.id, id) || other.id == id)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseTransliteration, phraseTransliteration) || other.phraseTransliteration == phraseTransliteration)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.recommendedCount, recommendedCount) || other.recommendedCount == recommendedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phraseArabic,phraseTransliteration,meaning,recommendedCount);

@override
String toString() {
  return 'DhikrPhrase(id: $id, phraseArabic: $phraseArabic, phraseTransliteration: $phraseTransliteration, meaning: $meaning, recommendedCount: $recommendedCount)';
}


}

/// @nodoc
abstract mixin class _$DhikrPhraseCopyWith<$Res> implements $DhikrPhraseCopyWith<$Res> {
  factory _$DhikrPhraseCopyWith(_DhikrPhrase value, $Res Function(_DhikrPhrase) _then) = __$DhikrPhraseCopyWithImpl;
@override @useResult
$Res call({
 String id, String phraseArabic, String phraseTransliteration, String meaning, int recommendedCount
});




}
/// @nodoc
class __$DhikrPhraseCopyWithImpl<$Res>
    implements _$DhikrPhraseCopyWith<$Res> {
  __$DhikrPhraseCopyWithImpl(this._self, this._then);

  final _DhikrPhrase _self;
  final $Res Function(_DhikrPhrase) _then;

/// Create a copy of DhikrPhrase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phraseArabic = null,Object? phraseTransliteration = null,Object? meaning = null,Object? recommendedCount = null,}) {
  return _then(_DhikrPhrase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phraseArabic: null == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String,phraseTransliteration: null == phraseTransliteration ? _self.phraseTransliteration : phraseTransliteration // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,recommendedCount: null == recommendedCount ? _self.recommendedCount : recommendedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
