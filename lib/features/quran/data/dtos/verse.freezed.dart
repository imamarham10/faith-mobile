// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Verse {

 String get id; int get surahId; int get verseNumber; String get textArabic; String? get textSimple; List<Translation> get translations;
/// Create a copy of Verse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseCopyWith<Verse> get copyWith => _$VerseCopyWithImpl<Verse>(this as Verse, _$identity);

  /// Serializes this Verse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Verse&&(identical(other.id, id) || other.id == id)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textSimple, textSimple) || other.textSimple == textSimple)&&const DeepCollectionEquality().equals(other.translations, translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,surahId,verseNumber,textArabic,textSimple,const DeepCollectionEquality().hash(translations));

@override
String toString() {
  return 'Verse(id: $id, surahId: $surahId, verseNumber: $verseNumber, textArabic: $textArabic, textSimple: $textSimple, translations: $translations)';
}


}

/// @nodoc
abstract mixin class $VerseCopyWith<$Res>  {
  factory $VerseCopyWith(Verse value, $Res Function(Verse) _then) = _$VerseCopyWithImpl;
@useResult
$Res call({
 String id, int surahId, int verseNumber, String textArabic, String? textSimple, List<Translation> translations
});




}
/// @nodoc
class _$VerseCopyWithImpl<$Res>
    implements $VerseCopyWith<$Res> {
  _$VerseCopyWithImpl(this._self, this._then);

  final Verse _self;
  final $Res Function(Verse) _then;

/// Create a copy of Verse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? surahId = null,Object? verseNumber = null,Object? textArabic = null,Object? textSimple = freezed,Object? translations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textSimple: freezed == textSimple ? _self.textSimple : textSimple // ignore: cast_nullable_to_non_nullable
as String?,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<Translation>,
  ));
}

}


/// Adds pattern-matching-related methods to [Verse].
extension VersePatterns on Verse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Verse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Verse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Verse value)  $default,){
final _that = this;
switch (_that) {
case _Verse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Verse value)?  $default,){
final _that = this;
switch (_that) {
case _Verse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int surahId,  int verseNumber,  String textArabic,  String? textSimple,  List<Translation> translations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Verse() when $default != null:
return $default(_that.id,_that.surahId,_that.verseNumber,_that.textArabic,_that.textSimple,_that.translations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int surahId,  int verseNumber,  String textArabic,  String? textSimple,  List<Translation> translations)  $default,) {final _that = this;
switch (_that) {
case _Verse():
return $default(_that.id,_that.surahId,_that.verseNumber,_that.textArabic,_that.textSimple,_that.translations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int surahId,  int verseNumber,  String textArabic,  String? textSimple,  List<Translation> translations)?  $default,) {final _that = this;
switch (_that) {
case _Verse() when $default != null:
return $default(_that.id,_that.surahId,_that.verseNumber,_that.textArabic,_that.textSimple,_that.translations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Verse implements Verse {
  const _Verse({required this.id, required this.surahId, required this.verseNumber, required this.textArabic, this.textSimple, final  List<Translation> translations = const <Translation>[]}): _translations = translations;
  factory _Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);

@override final  String id;
@override final  int surahId;
@override final  int verseNumber;
@override final  String textArabic;
@override final  String? textSimple;
 final  List<Translation> _translations;
@override@JsonKey() List<Translation> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}


/// Create a copy of Verse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseCopyWith<_Verse> get copyWith => __$VerseCopyWithImpl<_Verse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Verse&&(identical(other.id, id) || other.id == id)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textSimple, textSimple) || other.textSimple == textSimple)&&const DeepCollectionEquality().equals(other._translations, _translations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,surahId,verseNumber,textArabic,textSimple,const DeepCollectionEquality().hash(_translations));

@override
String toString() {
  return 'Verse(id: $id, surahId: $surahId, verseNumber: $verseNumber, textArabic: $textArabic, textSimple: $textSimple, translations: $translations)';
}


}

/// @nodoc
abstract mixin class _$VerseCopyWith<$Res> implements $VerseCopyWith<$Res> {
  factory _$VerseCopyWith(_Verse value, $Res Function(_Verse) _then) = __$VerseCopyWithImpl;
@override @useResult
$Res call({
 String id, int surahId, int verseNumber, String textArabic, String? textSimple, List<Translation> translations
});




}
/// @nodoc
class __$VerseCopyWithImpl<$Res>
    implements _$VerseCopyWith<$Res> {
  __$VerseCopyWithImpl(this._self, this._then);

  final _Verse _self;
  final $Res Function(_Verse) _then;

/// Create a copy of Verse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? surahId = null,Object? verseNumber = null,Object? textArabic = null,Object? textSimple = freezed,Object? translations = null,}) {
  return _then(_Verse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textSimple: freezed == textSimple ? _self.textSimple : textSimple // ignore: cast_nullable_to_non_nullable
as String?,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<Translation>,
  ));
}


}


/// @nodoc
mixin _$SurahDetail {

 int get id; String get nameArabic; String get nameEnglish; List<Verse> get verses;
/// Create a copy of SurahDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurahDetailCopyWith<SurahDetail> get copyWith => _$SurahDetailCopyWithImpl<SurahDetail>(this as SurahDetail, _$identity);

  /// Serializes this SurahDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurahDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&const DeepCollectionEquality().equals(other.verses, verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameArabic,nameEnglish,const DeepCollectionEquality().hash(verses));

@override
String toString() {
  return 'SurahDetail(id: $id, nameArabic: $nameArabic, nameEnglish: $nameEnglish, verses: $verses)';
}


}

/// @nodoc
abstract mixin class $SurahDetailCopyWith<$Res>  {
  factory $SurahDetailCopyWith(SurahDetail value, $Res Function(SurahDetail) _then) = _$SurahDetailCopyWithImpl;
@useResult
$Res call({
 int id, String nameArabic, String nameEnglish, List<Verse> verses
});




}
/// @nodoc
class _$SurahDetailCopyWithImpl<$Res>
    implements $SurahDetailCopyWith<$Res> {
  _$SurahDetailCopyWithImpl(this._self, this._then);

  final SurahDetail _self;
  final $Res Function(SurahDetail) _then;

/// Create a copy of SurahDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nameArabic = null,Object? nameEnglish = null,Object? verses = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nameArabic: null == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,verses: null == verses ? _self.verses : verses // ignore: cast_nullable_to_non_nullable
as List<Verse>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurahDetail].
extension SurahDetailPatterns on SurahDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurahDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurahDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurahDetail value)  $default,){
final _that = this;
switch (_that) {
case _SurahDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurahDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SurahDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nameArabic,  String nameEnglish,  List<Verse> verses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurahDetail() when $default != null:
return $default(_that.id,_that.nameArabic,_that.nameEnglish,_that.verses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nameArabic,  String nameEnglish,  List<Verse> verses)  $default,) {final _that = this;
switch (_that) {
case _SurahDetail():
return $default(_that.id,_that.nameArabic,_that.nameEnglish,_that.verses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nameArabic,  String nameEnglish,  List<Verse> verses)?  $default,) {final _that = this;
switch (_that) {
case _SurahDetail() when $default != null:
return $default(_that.id,_that.nameArabic,_that.nameEnglish,_that.verses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurahDetail implements SurahDetail {
  const _SurahDetail({required this.id, required this.nameArabic, required this.nameEnglish, final  List<Verse> verses = const <Verse>[]}): _verses = verses;
  factory _SurahDetail.fromJson(Map<String, dynamic> json) => _$SurahDetailFromJson(json);

@override final  int id;
@override final  String nameArabic;
@override final  String nameEnglish;
 final  List<Verse> _verses;
@override@JsonKey() List<Verse> get verses {
  if (_verses is EqualUnmodifiableListView) return _verses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_verses);
}


/// Create a copy of SurahDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurahDetailCopyWith<_SurahDetail> get copyWith => __$SurahDetailCopyWithImpl<_SurahDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurahDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurahDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&const DeepCollectionEquality().equals(other._verses, _verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nameArabic,nameEnglish,const DeepCollectionEquality().hash(_verses));

@override
String toString() {
  return 'SurahDetail(id: $id, nameArabic: $nameArabic, nameEnglish: $nameEnglish, verses: $verses)';
}


}

/// @nodoc
abstract mixin class _$SurahDetailCopyWith<$Res> implements $SurahDetailCopyWith<$Res> {
  factory _$SurahDetailCopyWith(_SurahDetail value, $Res Function(_SurahDetail) _then) = __$SurahDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String nameArabic, String nameEnglish, List<Verse> verses
});




}
/// @nodoc
class __$SurahDetailCopyWithImpl<$Res>
    implements _$SurahDetailCopyWith<$Res> {
  __$SurahDetailCopyWithImpl(this._self, this._then);

  final _SurahDetail _self;
  final $Res Function(_SurahDetail) _then;

/// Create a copy of SurahDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nameArabic = null,Object? nameEnglish = null,Object? verses = null,}) {
  return _then(_SurahDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nameArabic: null == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,verses: null == verses ? _self._verses : verses // ignore: cast_nullable_to_non_nullable
as List<Verse>,
  ));
}


}

// dart format on
