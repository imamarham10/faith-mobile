// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hindu_remedy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HinduRemedy {

 String get id; String get note; int get sequence; String get sanskritText; String? get transliteration; int get verseNumber; int? get chapterNumber; String? get textSlug; String? get textNameEnglish; String? get translationText;
/// Create a copy of HinduRemedy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HinduRemedyCopyWith<HinduRemedy> get copyWith => _$HinduRemedyCopyWithImpl<HinduRemedy>(this as HinduRemedy, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HinduRemedy&&(identical(other.id, id) || other.id == id)&&(identical(other.note, note) || other.note == note)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.textSlug, textSlug) || other.textSlug == textSlug)&&(identical(other.textNameEnglish, textNameEnglish) || other.textNameEnglish == textNameEnglish)&&(identical(other.translationText, translationText) || other.translationText == translationText));
}


@override
int get hashCode => Object.hash(runtimeType,id,note,sequence,sanskritText,transliteration,verseNumber,chapterNumber,textSlug,textNameEnglish,translationText);

@override
String toString() {
  return 'HinduRemedy(id: $id, note: $note, sequence: $sequence, sanskritText: $sanskritText, transliteration: $transliteration, verseNumber: $verseNumber, chapterNumber: $chapterNumber, textSlug: $textSlug, textNameEnglish: $textNameEnglish, translationText: $translationText)';
}


}

/// @nodoc
abstract mixin class $HinduRemedyCopyWith<$Res>  {
  factory $HinduRemedyCopyWith(HinduRemedy value, $Res Function(HinduRemedy) _then) = _$HinduRemedyCopyWithImpl;
@useResult
$Res call({
 String id, String note, int sequence, String sanskritText, String? transliteration, int verseNumber, int? chapterNumber, String? textSlug, String? textNameEnglish, String? translationText
});




}
/// @nodoc
class _$HinduRemedyCopyWithImpl<$Res>
    implements $HinduRemedyCopyWith<$Res> {
  _$HinduRemedyCopyWithImpl(this._self, this._then);

  final HinduRemedy _self;
  final $Res Function(HinduRemedy) _then;

/// Create a copy of HinduRemedy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? note = null,Object? sequence = null,Object? sanskritText = null,Object? transliteration = freezed,Object? verseNumber = null,Object? chapterNumber = freezed,Object? textSlug = freezed,Object? textNameEnglish = freezed,Object? translationText = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,sanskritText: null == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,textSlug: freezed == textSlug ? _self.textSlug : textSlug // ignore: cast_nullable_to_non_nullable
as String?,textNameEnglish: freezed == textNameEnglish ? _self.textNameEnglish : textNameEnglish // ignore: cast_nullable_to_non_nullable
as String?,translationText: freezed == translationText ? _self.translationText : translationText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HinduRemedy].
extension HinduRemedyPatterns on HinduRemedy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HinduRemedy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HinduRemedy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HinduRemedy value)  $default,){
final _that = this;
switch (_that) {
case _HinduRemedy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HinduRemedy value)?  $default,){
final _that = this;
switch (_that) {
case _HinduRemedy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String note,  int sequence,  String sanskritText,  String? transliteration,  int verseNumber,  int? chapterNumber,  String? textSlug,  String? textNameEnglish,  String? translationText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HinduRemedy() when $default != null:
return $default(_that.id,_that.note,_that.sequence,_that.sanskritText,_that.transliteration,_that.verseNumber,_that.chapterNumber,_that.textSlug,_that.textNameEnglish,_that.translationText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String note,  int sequence,  String sanskritText,  String? transliteration,  int verseNumber,  int? chapterNumber,  String? textSlug,  String? textNameEnglish,  String? translationText)  $default,) {final _that = this;
switch (_that) {
case _HinduRemedy():
return $default(_that.id,_that.note,_that.sequence,_that.sanskritText,_that.transliteration,_that.verseNumber,_that.chapterNumber,_that.textSlug,_that.textNameEnglish,_that.translationText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String note,  int sequence,  String sanskritText,  String? transliteration,  int verseNumber,  int? chapterNumber,  String? textSlug,  String? textNameEnglish,  String? translationText)?  $default,) {final _that = this;
switch (_that) {
case _HinduRemedy() when $default != null:
return $default(_that.id,_that.note,_that.sequence,_that.sanskritText,_that.transliteration,_that.verseNumber,_that.chapterNumber,_that.textSlug,_that.textNameEnglish,_that.translationText);case _:
  return null;

}
}

}

/// @nodoc


class _HinduRemedy extends HinduRemedy {
  const _HinduRemedy({required this.id, required this.note, this.sequence = 0, required this.sanskritText, this.transliteration, required this.verseNumber, this.chapterNumber, this.textSlug, this.textNameEnglish, this.translationText}): super._();
  

@override final  String id;
@override final  String note;
@override@JsonKey() final  int sequence;
@override final  String sanskritText;
@override final  String? transliteration;
@override final  int verseNumber;
@override final  int? chapterNumber;
@override final  String? textSlug;
@override final  String? textNameEnglish;
@override final  String? translationText;

/// Create a copy of HinduRemedy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HinduRemedyCopyWith<_HinduRemedy> get copyWith => __$HinduRemedyCopyWithImpl<_HinduRemedy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HinduRemedy&&(identical(other.id, id) || other.id == id)&&(identical(other.note, note) || other.note == note)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.textSlug, textSlug) || other.textSlug == textSlug)&&(identical(other.textNameEnglish, textNameEnglish) || other.textNameEnglish == textNameEnglish)&&(identical(other.translationText, translationText) || other.translationText == translationText));
}


@override
int get hashCode => Object.hash(runtimeType,id,note,sequence,sanskritText,transliteration,verseNumber,chapterNumber,textSlug,textNameEnglish,translationText);

@override
String toString() {
  return 'HinduRemedy(id: $id, note: $note, sequence: $sequence, sanskritText: $sanskritText, transliteration: $transliteration, verseNumber: $verseNumber, chapterNumber: $chapterNumber, textSlug: $textSlug, textNameEnglish: $textNameEnglish, translationText: $translationText)';
}


}

/// @nodoc
abstract mixin class _$HinduRemedyCopyWith<$Res> implements $HinduRemedyCopyWith<$Res> {
  factory _$HinduRemedyCopyWith(_HinduRemedy value, $Res Function(_HinduRemedy) _then) = __$HinduRemedyCopyWithImpl;
@override @useResult
$Res call({
 String id, String note, int sequence, String sanskritText, String? transliteration, int verseNumber, int? chapterNumber, String? textSlug, String? textNameEnglish, String? translationText
});




}
/// @nodoc
class __$HinduRemedyCopyWithImpl<$Res>
    implements _$HinduRemedyCopyWith<$Res> {
  __$HinduRemedyCopyWithImpl(this._self, this._then);

  final _HinduRemedy _self;
  final $Res Function(_HinduRemedy) _then;

/// Create a copy of HinduRemedy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? note = null,Object? sequence = null,Object? sanskritText = null,Object? transliteration = freezed,Object? verseNumber = null,Object? chapterNumber = freezed,Object? textSlug = freezed,Object? textNameEnglish = freezed,Object? translationText = freezed,}) {
  return _then(_HinduRemedy(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,sanskritText: null == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,textSlug: freezed == textSlug ? _self.textSlug : textSlug // ignore: cast_nullable_to_non_nullable
as String?,textNameEnglish: freezed == textNameEnglish ? _self.textNameEnglish : textNameEnglish // ignore: cast_nullable_to_non_nullable
as String?,translationText: freezed == translationText ? _self.translationText : translationText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
