// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'divine_name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DivineName {

 int get id; String get nameArabic; String get nameTranslit; String get nameEnglish; String? get meaning; String? get description; String? get audioUrl;
/// Create a copy of DivineName
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DivineNameCopyWith<DivineName> get copyWith => _$DivineNameCopyWithImpl<DivineName>(this as DivineName, _$identity);

  /// Serializes this DivineName to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DivineName&&(identical(other.id, id) || other.id == id)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.nameTranslit, nameTranslit) || other.nameTranslit == nameTranslit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.description, description) || other.description == description)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameArabic,nameTranslit,nameEnglish,meaning,description,audioUrl);

@override
String toString() {
  return 'DivineName(id: $id, nameArabic: $nameArabic, nameTranslit: $nameTranslit, nameEnglish: $nameEnglish, meaning: $meaning, description: $description, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class $DivineNameCopyWith<$Res>  {
  factory $DivineNameCopyWith(DivineName value, $Res Function(DivineName) _then) = _$DivineNameCopyWithImpl;
@useResult
$Res call({
 int id, String nameArabic, String nameTranslit, String nameEnglish, String? meaning, String? description, String? audioUrl
});




}
/// @nodoc
class _$DivineNameCopyWithImpl<$Res>
    implements $DivineNameCopyWith<$Res> {
  _$DivineNameCopyWithImpl(this._self, this._then);

  final DivineName _self;
  final $Res Function(DivineName) _then;

/// Create a copy of DivineName
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameArabic = null,Object? nameTranslit = null,Object? nameEnglish = null,Object? meaning = freezed,Object? description = freezed,Object? audioUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nameArabic: null == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String,nameTranslit: null == nameTranslit ? _self.nameTranslit : nameTranslit // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DivineName].
extension DivineNamePatterns on DivineName {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DivineName value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DivineName() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DivineName value)  $default,){
final _that = this;
switch (_that) {
case _DivineName():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DivineName value)?  $default,){
final _that = this;
switch (_that) {
case _DivineName() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nameArabic,  String nameTranslit,  String nameEnglish,  String? meaning,  String? description,  String? audioUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DivineName() when $default != null:
return $default(_that.id,_that.nameArabic,_that.nameTranslit,_that.nameEnglish,_that.meaning,_that.description,_that.audioUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nameArabic,  String nameTranslit,  String nameEnglish,  String? meaning,  String? description,  String? audioUrl)  $default,) {final _that = this;
switch (_that) {
case _DivineName():
return $default(_that.id,_that.nameArabic,_that.nameTranslit,_that.nameEnglish,_that.meaning,_that.description,_that.audioUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nameArabic,  String nameTranslit,  String nameEnglish,  String? meaning,  String? description,  String? audioUrl)?  $default,) {final _that = this;
switch (_that) {
case _DivineName() when $default != null:
return $default(_that.id,_that.nameArabic,_that.nameTranslit,_that.nameEnglish,_that.meaning,_that.description,_that.audioUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DivineName implements DivineName {
  const _DivineName({required this.id, required this.nameArabic, required this.nameTranslit, required this.nameEnglish, this.meaning, this.description, this.audioUrl});
  factory _DivineName.fromJson(Map<String, dynamic> json) => _$DivineNameFromJson(json);

@override final  int id;
@override final  String nameArabic;
@override final  String nameTranslit;
@override final  String nameEnglish;
@override final  String? meaning;
@override final  String? description;
@override final  String? audioUrl;

/// Create a copy of DivineName
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DivineNameCopyWith<_DivineName> get copyWith => __$DivineNameCopyWithImpl<_DivineName>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DivineNameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DivineName&&(identical(other.id, id) || other.id == id)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.nameTranslit, nameTranslit) || other.nameTranslit == nameTranslit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.description, description) || other.description == description)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameArabic,nameTranslit,nameEnglish,meaning,description,audioUrl);

@override
String toString() {
  return 'DivineName(id: $id, nameArabic: $nameArabic, nameTranslit: $nameTranslit, nameEnglish: $nameEnglish, meaning: $meaning, description: $description, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class _$DivineNameCopyWith<$Res> implements $DivineNameCopyWith<$Res> {
  factory _$DivineNameCopyWith(_DivineName value, $Res Function(_DivineName) _then) = __$DivineNameCopyWithImpl;
@override @useResult
$Res call({
 int id, String nameArabic, String nameTranslit, String nameEnglish, String? meaning, String? description, String? audioUrl
});




}
/// @nodoc
class __$DivineNameCopyWithImpl<$Res>
    implements _$DivineNameCopyWith<$Res> {
  __$DivineNameCopyWithImpl(this._self, this._then);

  final _DivineName _self;
  final $Res Function(_DivineName) _then;

/// Create a copy of DivineName
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameArabic = null,Object? nameTranslit = null,Object? nameEnglish = null,Object? meaning = freezed,Object? description = freezed,Object? audioUrl = freezed,}) {
  return _then(_DivineName(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nameArabic: null == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String,nameTranslit: null == nameTranslit ? _self.nameTranslit : nameTranslit // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
