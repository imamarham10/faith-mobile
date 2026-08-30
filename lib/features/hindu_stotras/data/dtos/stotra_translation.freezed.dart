// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stotra_translation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StotraTranslation {

 String get languageCode; String get text;
/// Create a copy of StotraTranslation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StotraTranslationCopyWith<StotraTranslation> get copyWith => _$StotraTranslationCopyWithImpl<StotraTranslation>(this as StotraTranslation, _$identity);

  /// Serializes this StotraTranslation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StotraTranslation&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,text);

@override
String toString() {
  return 'StotraTranslation(languageCode: $languageCode, text: $text)';
}


}

/// @nodoc
abstract mixin class $StotraTranslationCopyWith<$Res>  {
  factory $StotraTranslationCopyWith(StotraTranslation value, $Res Function(StotraTranslation) _then) = _$StotraTranslationCopyWithImpl;
@useResult
$Res call({
 String languageCode, String text
});




}
/// @nodoc
class _$StotraTranslationCopyWithImpl<$Res>
    implements $StotraTranslationCopyWith<$Res> {
  _$StotraTranslationCopyWithImpl(this._self, this._then);

  final StotraTranslation _self;
  final $Res Function(StotraTranslation) _then;

/// Create a copy of StotraTranslation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? languageCode = null,Object? text = null,}) {
  return _then(_self.copyWith(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StotraTranslation].
extension StotraTranslationPatterns on StotraTranslation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StotraTranslation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StotraTranslation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StotraTranslation value)  $default,){
final _that = this;
switch (_that) {
case _StotraTranslation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StotraTranslation value)?  $default,){
final _that = this;
switch (_that) {
case _StotraTranslation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String languageCode,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StotraTranslation() when $default != null:
return $default(_that.languageCode,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String languageCode,  String text)  $default,) {final _that = this;
switch (_that) {
case _StotraTranslation():
return $default(_that.languageCode,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String languageCode,  String text)?  $default,) {final _that = this;
switch (_that) {
case _StotraTranslation() when $default != null:
return $default(_that.languageCode,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StotraTranslation implements StotraTranslation {
  const _StotraTranslation({required this.languageCode, required this.text});
  factory _StotraTranslation.fromJson(Map<String, dynamic> json) => _$StotraTranslationFromJson(json);

@override final  String languageCode;
@override final  String text;

/// Create a copy of StotraTranslation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StotraTranslationCopyWith<_StotraTranslation> get copyWith => __$StotraTranslationCopyWithImpl<_StotraTranslation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StotraTranslationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StotraTranslation&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,text);

@override
String toString() {
  return 'StotraTranslation(languageCode: $languageCode, text: $text)';
}


}

/// @nodoc
abstract mixin class _$StotraTranslationCopyWith<$Res> implements $StotraTranslationCopyWith<$Res> {
  factory _$StotraTranslationCopyWith(_StotraTranslation value, $Res Function(_StotraTranslation) _then) = __$StotraTranslationCopyWithImpl;
@override @useResult
$Res call({
 String languageCode, String text
});




}
/// @nodoc
class __$StotraTranslationCopyWithImpl<$Res>
    implements _$StotraTranslationCopyWith<$Res> {
  __$StotraTranslationCopyWithImpl(this._self, this._then);

  final _StotraTranslation _self;
  final $Res Function(_StotraTranslation) _then;

/// Create a copy of StotraTranslation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? languageCode = null,Object? text = null,}) {
  return _then(_StotraTranslation(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
