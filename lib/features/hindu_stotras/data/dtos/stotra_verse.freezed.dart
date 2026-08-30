// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stotra_verse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StotraVerse {

 String get id; String get stotraId; int get verseNumber; String get sanskritText; String? get transliteration; List<StotraTranslation> get translations;
/// Create a copy of StotraVerse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StotraVerseCopyWith<StotraVerse> get copyWith => _$StotraVerseCopyWithImpl<StotraVerse>(this as StotraVerse, _$identity);

  /// Serializes this StotraVerse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StotraVerse&&(identical(other.id, id) || other.id == id)&&(identical(other.stotraId, stotraId) || other.stotraId == stotraId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&const DeepCollectionEquality().equals(other.translations, translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stotraId,verseNumber,sanskritText,transliteration,const DeepCollectionEquality().hash(translations));

@override
String toString() {
  return 'StotraVerse(id: $id, stotraId: $stotraId, verseNumber: $verseNumber, sanskritText: $sanskritText, transliteration: $transliteration, translations: $translations)';
}


}

/// @nodoc
abstract mixin class $StotraVerseCopyWith<$Res>  {
  factory $StotraVerseCopyWith(StotraVerse value, $Res Function(StotraVerse) _then) = _$StotraVerseCopyWithImpl;
@useResult
$Res call({
 String id, String stotraId, int verseNumber, String sanskritText, String? transliteration, List<StotraTranslation> translations
});




}
/// @nodoc
class _$StotraVerseCopyWithImpl<$Res>
    implements $StotraVerseCopyWith<$Res> {
  _$StotraVerseCopyWithImpl(this._self, this._then);

  final StotraVerse _self;
  final $Res Function(StotraVerse) _then;

/// Create a copy of StotraVerse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? stotraId = null,Object? verseNumber = null,Object? sanskritText = null,Object? transliteration = freezed,Object? translations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stotraId: null == stotraId ? _self.stotraId : stotraId // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,sanskritText: null == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<StotraTranslation>,
  ));
}

}


/// Adds pattern-matching-related methods to [StotraVerse].
extension StotraVersePatterns on StotraVerse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StotraVerse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StotraVerse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StotraVerse value)  $default,){
final _that = this;
switch (_that) {
case _StotraVerse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StotraVerse value)?  $default,){
final _that = this;
switch (_that) {
case _StotraVerse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String stotraId,  int verseNumber,  String sanskritText,  String? transliteration,  List<StotraTranslation> translations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StotraVerse() when $default != null:
return $default(_that.id,_that.stotraId,_that.verseNumber,_that.sanskritText,_that.transliteration,_that.translations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String stotraId,  int verseNumber,  String sanskritText,  String? transliteration,  List<StotraTranslation> translations)  $default,) {final _that = this;
switch (_that) {
case _StotraVerse():
return $default(_that.id,_that.stotraId,_that.verseNumber,_that.sanskritText,_that.transliteration,_that.translations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String stotraId,  int verseNumber,  String sanskritText,  String? transliteration,  List<StotraTranslation> translations)?  $default,) {final _that = this;
switch (_that) {
case _StotraVerse() when $default != null:
return $default(_that.id,_that.stotraId,_that.verseNumber,_that.sanskritText,_that.transliteration,_that.translations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StotraVerse implements StotraVerse {
  const _StotraVerse({required this.id, required this.stotraId, required this.verseNumber, required this.sanskritText, this.transliteration, final  List<StotraTranslation> translations = const <StotraTranslation>[]}): _translations = translations;
  factory _StotraVerse.fromJson(Map<String, dynamic> json) => _$StotraVerseFromJson(json);

@override final  String id;
@override final  String stotraId;
@override final  int verseNumber;
@override final  String sanskritText;
@override final  String? transliteration;
 final  List<StotraTranslation> _translations;
@override@JsonKey() List<StotraTranslation> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}


/// Create a copy of StotraVerse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StotraVerseCopyWith<_StotraVerse> get copyWith => __$StotraVerseCopyWithImpl<_StotraVerse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StotraVerseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StotraVerse&&(identical(other.id, id) || other.id == id)&&(identical(other.stotraId, stotraId) || other.stotraId == stotraId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&const DeepCollectionEquality().equals(other._translations, _translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stotraId,verseNumber,sanskritText,transliteration,const DeepCollectionEquality().hash(_translations));

@override
String toString() {
  return 'StotraVerse(id: $id, stotraId: $stotraId, verseNumber: $verseNumber, sanskritText: $sanskritText, transliteration: $transliteration, translations: $translations)';
}


}

/// @nodoc
abstract mixin class _$StotraVerseCopyWith<$Res> implements $StotraVerseCopyWith<$Res> {
  factory _$StotraVerseCopyWith(_StotraVerse value, $Res Function(_StotraVerse) _then) = __$StotraVerseCopyWithImpl;
@override @useResult
$Res call({
 String id, String stotraId, int verseNumber, String sanskritText, String? transliteration, List<StotraTranslation> translations
});




}
/// @nodoc
class __$StotraVerseCopyWithImpl<$Res>
    implements _$StotraVerseCopyWith<$Res> {
  __$StotraVerseCopyWithImpl(this._self, this._then);

  final _StotraVerse _self;
  final $Res Function(_StotraVerse) _then;

/// Create a copy of StotraVerse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? stotraId = null,Object? verseNumber = null,Object? sanskritText = null,Object? transliteration = freezed,Object? translations = null,}) {
  return _then(_StotraVerse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stotraId: null == stotraId ? _self.stotraId : stotraId // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,sanskritText: null == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<StotraTranslation>,
  ));
}


}

// dart format on
