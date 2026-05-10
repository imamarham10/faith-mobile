// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dua.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Dua {

 String get id; String get categoryId; String get titleArabic; String get titleEnglish; String get textArabic; String get textEnglish; String? get textTransliteration; String? get reference; String? get audioUrl; DuaCategory? get category;
/// Create a copy of Dua
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuaCopyWith<Dua> get copyWith => _$DuaCopyWithImpl<Dua>(this as Dua, _$identity);

  /// Serializes this Dua to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dua&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.titleArabic, titleArabic) || other.titleArabic == titleArabic)&&(identical(other.titleEnglish, titleEnglish) || other.titleEnglish == titleEnglish)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textEnglish, textEnglish) || other.textEnglish == textEnglish)&&(identical(other.textTransliteration, textTransliteration) || other.textTransliteration == textTransliteration)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,titleArabic,titleEnglish,textArabic,textEnglish,textTransliteration,reference,audioUrl,category);

@override
String toString() {
  return 'Dua(id: $id, categoryId: $categoryId, titleArabic: $titleArabic, titleEnglish: $titleEnglish, textArabic: $textArabic, textEnglish: $textEnglish, textTransliteration: $textTransliteration, reference: $reference, audioUrl: $audioUrl, category: $category)';
}


}

/// @nodoc
abstract mixin class $DuaCopyWith<$Res>  {
  factory $DuaCopyWith(Dua value, $Res Function(Dua) _then) = _$DuaCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String titleArabic, String titleEnglish, String textArabic, String textEnglish, String? textTransliteration, String? reference, String? audioUrl, DuaCategory? category
});


$DuaCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$DuaCopyWithImpl<$Res>
    implements $DuaCopyWith<$Res> {
  _$DuaCopyWithImpl(this._self, this._then);

  final Dua _self;
  final $Res Function(Dua) _then;

/// Create a copy of Dua
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? titleArabic = null,Object? titleEnglish = null,Object? textArabic = null,Object? textEnglish = null,Object? textTransliteration = freezed,Object? reference = freezed,Object? audioUrl = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,titleArabic: null == titleArabic ? _self.titleArabic : titleArabic // ignore: cast_nullable_to_non_nullable
as String,titleEnglish: null == titleEnglish ? _self.titleEnglish : titleEnglish // ignore: cast_nullable_to_non_nullable
as String,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textEnglish: null == textEnglish ? _self.textEnglish : textEnglish // ignore: cast_nullable_to_non_nullable
as String,textTransliteration: freezed == textTransliteration ? _self.textTransliteration : textTransliteration // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DuaCategory?,
  ));
}
/// Create a copy of Dua
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuaCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $DuaCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [Dua].
extension DuaPatterns on Dua {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dua value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dua() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dua value)  $default,){
final _that = this;
switch (_that) {
case _Dua():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dua value)?  $default,){
final _that = this;
switch (_that) {
case _Dua() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String titleArabic,  String titleEnglish,  String textArabic,  String textEnglish,  String? textTransliteration,  String? reference,  String? audioUrl,  DuaCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dua() when $default != null:
return $default(_that.id,_that.categoryId,_that.titleArabic,_that.titleEnglish,_that.textArabic,_that.textEnglish,_that.textTransliteration,_that.reference,_that.audioUrl,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String titleArabic,  String titleEnglish,  String textArabic,  String textEnglish,  String? textTransliteration,  String? reference,  String? audioUrl,  DuaCategory? category)  $default,) {final _that = this;
switch (_that) {
case _Dua():
return $default(_that.id,_that.categoryId,_that.titleArabic,_that.titleEnglish,_that.textArabic,_that.textEnglish,_that.textTransliteration,_that.reference,_that.audioUrl,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String titleArabic,  String titleEnglish,  String textArabic,  String textEnglish,  String? textTransliteration,  String? reference,  String? audioUrl,  DuaCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _Dua() when $default != null:
return $default(_that.id,_that.categoryId,_that.titleArabic,_that.titleEnglish,_that.textArabic,_that.textEnglish,_that.textTransliteration,_that.reference,_that.audioUrl,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dua implements Dua {
  const _Dua({required this.id, required this.categoryId, required this.titleArabic, required this.titleEnglish, required this.textArabic, required this.textEnglish, this.textTransliteration, this.reference, this.audioUrl, this.category});
  factory _Dua.fromJson(Map<String, dynamic> json) => _$DuaFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String titleArabic;
@override final  String titleEnglish;
@override final  String textArabic;
@override final  String textEnglish;
@override final  String? textTransliteration;
@override final  String? reference;
@override final  String? audioUrl;
@override final  DuaCategory? category;

/// Create a copy of Dua
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuaCopyWith<_Dua> get copyWith => __$DuaCopyWithImpl<_Dua>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dua&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.titleArabic, titleArabic) || other.titleArabic == titleArabic)&&(identical(other.titleEnglish, titleEnglish) || other.titleEnglish == titleEnglish)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textEnglish, textEnglish) || other.textEnglish == textEnglish)&&(identical(other.textTransliteration, textTransliteration) || other.textTransliteration == textTransliteration)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,titleArabic,titleEnglish,textArabic,textEnglish,textTransliteration,reference,audioUrl,category);

@override
String toString() {
  return 'Dua(id: $id, categoryId: $categoryId, titleArabic: $titleArabic, titleEnglish: $titleEnglish, textArabic: $textArabic, textEnglish: $textEnglish, textTransliteration: $textTransliteration, reference: $reference, audioUrl: $audioUrl, category: $category)';
}


}

/// @nodoc
abstract mixin class _$DuaCopyWith<$Res> implements $DuaCopyWith<$Res> {
  factory _$DuaCopyWith(_Dua value, $Res Function(_Dua) _then) = __$DuaCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String titleArabic, String titleEnglish, String textArabic, String textEnglish, String? textTransliteration, String? reference, String? audioUrl, DuaCategory? category
});


@override $DuaCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$DuaCopyWithImpl<$Res>
    implements _$DuaCopyWith<$Res> {
  __$DuaCopyWithImpl(this._self, this._then);

  final _Dua _self;
  final $Res Function(_Dua) _then;

/// Create a copy of Dua
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? titleArabic = null,Object? titleEnglish = null,Object? textArabic = null,Object? textEnglish = null,Object? textTransliteration = freezed,Object? reference = freezed,Object? audioUrl = freezed,Object? category = freezed,}) {
  return _then(_Dua(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,titleArabic: null == titleArabic ? _self.titleArabic : titleArabic // ignore: cast_nullable_to_non_nullable
as String,titleEnglish: null == titleEnglish ? _self.titleEnglish : titleEnglish // ignore: cast_nullable_to_non_nullable
as String,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textEnglish: null == textEnglish ? _self.textEnglish : textEnglish // ignore: cast_nullable_to_non_nullable
as String,textTransliteration: freezed == textTransliteration ? _self.textTransliteration : textTransliteration // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DuaCategory?,
  ));
}

/// Create a copy of Dua
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuaCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $DuaCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
