// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse_translation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerseTranslation {

 String get id; String get languageCode; String get authorName; String get text;
/// Create a copy of VerseTranslation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseTranslationCopyWith<VerseTranslation> get copyWith => _$VerseTranslationCopyWithImpl<VerseTranslation>(this as VerseTranslation, _$identity);

  /// Serializes this VerseTranslation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseTranslation&&(identical(other.id, id) || other.id == id)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,languageCode,authorName,text);

@override
String toString() {
  return 'VerseTranslation(id: $id, languageCode: $languageCode, authorName: $authorName, text: $text)';
}


}

/// @nodoc
abstract mixin class $VerseTranslationCopyWith<$Res>  {
  factory $VerseTranslationCopyWith(VerseTranslation value, $Res Function(VerseTranslation) _then) = _$VerseTranslationCopyWithImpl;
@useResult
$Res call({
 String id, String languageCode, String authorName, String text
});




}
/// @nodoc
class _$VerseTranslationCopyWithImpl<$Res>
    implements $VerseTranslationCopyWith<$Res> {
  _$VerseTranslationCopyWithImpl(this._self, this._then);

  final VerseTranslation _self;
  final $Res Function(VerseTranslation) _then;

/// Create a copy of VerseTranslation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? languageCode = null,Object? authorName = null,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VerseTranslation].
extension VerseTranslationPatterns on VerseTranslation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseTranslation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseTranslation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseTranslation value)  $default,){
final _that = this;
switch (_that) {
case _VerseTranslation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseTranslation value)?  $default,){
final _that = this;
switch (_that) {
case _VerseTranslation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String languageCode,  String authorName,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseTranslation() when $default != null:
return $default(_that.id,_that.languageCode,_that.authorName,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String languageCode,  String authorName,  String text)  $default,) {final _that = this;
switch (_that) {
case _VerseTranslation():
return $default(_that.id,_that.languageCode,_that.authorName,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String languageCode,  String authorName,  String text)?  $default,) {final _that = this;
switch (_that) {
case _VerseTranslation() when $default != null:
return $default(_that.id,_that.languageCode,_that.authorName,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerseTranslation implements VerseTranslation {
  const _VerseTranslation({required this.id, required this.languageCode, required this.authorName, required this.text});
  factory _VerseTranslation.fromJson(Map<String, dynamic> json) => _$VerseTranslationFromJson(json);

@override final  String id;
@override final  String languageCode;
@override final  String authorName;
@override final  String text;

/// Create a copy of VerseTranslation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseTranslationCopyWith<_VerseTranslation> get copyWith => __$VerseTranslationCopyWithImpl<_VerseTranslation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerseTranslationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseTranslation&&(identical(other.id, id) || other.id == id)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,languageCode,authorName,text);

@override
String toString() {
  return 'VerseTranslation(id: $id, languageCode: $languageCode, authorName: $authorName, text: $text)';
}


}

/// @nodoc
abstract mixin class _$VerseTranslationCopyWith<$Res> implements $VerseTranslationCopyWith<$Res> {
  factory _$VerseTranslationCopyWith(_VerseTranslation value, $Res Function(_VerseTranslation) _then) = __$VerseTranslationCopyWithImpl;
@override @useResult
$Res call({
 String id, String languageCode, String authorName, String text
});




}
/// @nodoc
class __$VerseTranslationCopyWithImpl<$Res>
    implements _$VerseTranslationCopyWith<$Res> {
  __$VerseTranslationCopyWithImpl(this._self, this._then);

  final _VerseTranslation _self;
  final $Res Function(_VerseTranslation) _then;

/// Create a copy of VerseTranslation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? languageCode = null,Object? authorName = null,Object? text = null,}) {
  return _then(_VerseTranslation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
