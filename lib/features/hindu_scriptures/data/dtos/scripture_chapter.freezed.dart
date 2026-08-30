// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scripture_chapter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterSummary {

 String get id; String get textId; int get chapterNumber; String? get nameSanskrit; String? get nameEnglish; int get verseCount;
/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterSummaryCopyWith<ChapterSummary> get copyWith => _$ChapterSummaryCopyWithImpl<ChapterSummary>(this as ChapterSummary, _$identity);

  /// Serializes this ChapterSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.textId, textId) || other.textId == textId)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textId,chapterNumber,nameSanskrit,nameEnglish,verseCount);

@override
String toString() {
  return 'ChapterSummary(id: $id, textId: $textId, chapterNumber: $chapterNumber, nameSanskrit: $nameSanskrit, nameEnglish: $nameEnglish, verseCount: $verseCount)';
}


}

/// @nodoc
abstract mixin class $ChapterSummaryCopyWith<$Res>  {
  factory $ChapterSummaryCopyWith(ChapterSummary value, $Res Function(ChapterSummary) _then) = _$ChapterSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String textId, int chapterNumber, String? nameSanskrit, String? nameEnglish, int verseCount
});




}
/// @nodoc
class _$ChapterSummaryCopyWithImpl<$Res>
    implements $ChapterSummaryCopyWith<$Res> {
  _$ChapterSummaryCopyWithImpl(this._self, this._then);

  final ChapterSummary _self;
  final $Res Function(ChapterSummary) _then;

/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? textId = null,Object? chapterNumber = null,Object? nameSanskrit = freezed,Object? nameEnglish = freezed,Object? verseCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textId: null == textId ? _self.textId : textId // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterSummary].
extension ChapterSummaryPatterns on ChapterSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterSummary value)  $default,){
final _that = this;
switch (_that) {
case _ChapterSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String textId,  int chapterNumber,  String? nameSanskrit,  String? nameEnglish,  int verseCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterSummary() when $default != null:
return $default(_that.id,_that.textId,_that.chapterNumber,_that.nameSanskrit,_that.nameEnglish,_that.verseCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String textId,  int chapterNumber,  String? nameSanskrit,  String? nameEnglish,  int verseCount)  $default,) {final _that = this;
switch (_that) {
case _ChapterSummary():
return $default(_that.id,_that.textId,_that.chapterNumber,_that.nameSanskrit,_that.nameEnglish,_that.verseCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String textId,  int chapterNumber,  String? nameSanskrit,  String? nameEnglish,  int verseCount)?  $default,) {final _that = this;
switch (_that) {
case _ChapterSummary() when $default != null:
return $default(_that.id,_that.textId,_that.chapterNumber,_that.nameSanskrit,_that.nameEnglish,_that.verseCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterSummary implements ChapterSummary {
  const _ChapterSummary({required this.id, required this.textId, required this.chapterNumber, this.nameSanskrit, this.nameEnglish, required this.verseCount});
  factory _ChapterSummary.fromJson(Map<String, dynamic> json) => _$ChapterSummaryFromJson(json);

@override final  String id;
@override final  String textId;
@override final  int chapterNumber;
@override final  String? nameSanskrit;
@override final  String? nameEnglish;
@override final  int verseCount;

/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterSummaryCopyWith<_ChapterSummary> get copyWith => __$ChapterSummaryCopyWithImpl<_ChapterSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.textId, textId) || other.textId == textId)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textId,chapterNumber,nameSanskrit,nameEnglish,verseCount);

@override
String toString() {
  return 'ChapterSummary(id: $id, textId: $textId, chapterNumber: $chapterNumber, nameSanskrit: $nameSanskrit, nameEnglish: $nameEnglish, verseCount: $verseCount)';
}


}

/// @nodoc
abstract mixin class _$ChapterSummaryCopyWith<$Res> implements $ChapterSummaryCopyWith<$Res> {
  factory _$ChapterSummaryCopyWith(_ChapterSummary value, $Res Function(_ChapterSummary) _then) = __$ChapterSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String textId, int chapterNumber, String? nameSanskrit, String? nameEnglish, int verseCount
});




}
/// @nodoc
class __$ChapterSummaryCopyWithImpl<$Res>
    implements _$ChapterSummaryCopyWith<$Res> {
  __$ChapterSummaryCopyWithImpl(this._self, this._then);

  final _ChapterSummary _self;
  final $Res Function(_ChapterSummary) _then;

/// Create a copy of ChapterSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? textId = null,Object? chapterNumber = null,Object? nameSanskrit = freezed,Object? nameEnglish = freezed,Object? verseCount = null,}) {
  return _then(_ChapterSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textId: null == textId ? _self.textId : textId // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChapterDetail {

 String get id; String get textId; int get chapterNumber; String? get nameSanskrit; String? get nameEnglish; List<ScriptureVerse> get verses;
/// Create a copy of ChapterDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterDetailCopyWith<ChapterDetail> get copyWith => _$ChapterDetailCopyWithImpl<ChapterDetail>(this as ChapterDetail, _$identity);

  /// Serializes this ChapterDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.textId, textId) || other.textId == textId)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&const DeepCollectionEquality().equals(other.verses, verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textId,chapterNumber,nameSanskrit,nameEnglish,const DeepCollectionEquality().hash(verses));

@override
String toString() {
  return 'ChapterDetail(id: $id, textId: $textId, chapterNumber: $chapterNumber, nameSanskrit: $nameSanskrit, nameEnglish: $nameEnglish, verses: $verses)';
}


}

/// @nodoc
abstract mixin class $ChapterDetailCopyWith<$Res>  {
  factory $ChapterDetailCopyWith(ChapterDetail value, $Res Function(ChapterDetail) _then) = _$ChapterDetailCopyWithImpl;
@useResult
$Res call({
 String id, String textId, int chapterNumber, String? nameSanskrit, String? nameEnglish, List<ScriptureVerse> verses
});




}
/// @nodoc
class _$ChapterDetailCopyWithImpl<$Res>
    implements $ChapterDetailCopyWith<$Res> {
  _$ChapterDetailCopyWithImpl(this._self, this._then);

  final ChapterDetail _self;
  final $Res Function(ChapterDetail) _then;

/// Create a copy of ChapterDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? textId = null,Object? chapterNumber = null,Object? nameSanskrit = freezed,Object? nameEnglish = freezed,Object? verses = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textId: null == textId ? _self.textId : textId // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,verses: null == verses ? _self.verses : verses // ignore: cast_nullable_to_non_nullable
as List<ScriptureVerse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterDetail].
extension ChapterDetailPatterns on ChapterDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterDetail value)  $default,){
final _that = this;
switch (_that) {
case _ChapterDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String textId,  int chapterNumber,  String? nameSanskrit,  String? nameEnglish,  List<ScriptureVerse> verses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterDetail() when $default != null:
return $default(_that.id,_that.textId,_that.chapterNumber,_that.nameSanskrit,_that.nameEnglish,_that.verses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String textId,  int chapterNumber,  String? nameSanskrit,  String? nameEnglish,  List<ScriptureVerse> verses)  $default,) {final _that = this;
switch (_that) {
case _ChapterDetail():
return $default(_that.id,_that.textId,_that.chapterNumber,_that.nameSanskrit,_that.nameEnglish,_that.verses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String textId,  int chapterNumber,  String? nameSanskrit,  String? nameEnglish,  List<ScriptureVerse> verses)?  $default,) {final _that = this;
switch (_that) {
case _ChapterDetail() when $default != null:
return $default(_that.id,_that.textId,_that.chapterNumber,_that.nameSanskrit,_that.nameEnglish,_that.verses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterDetail implements ChapterDetail {
  const _ChapterDetail({required this.id, required this.textId, required this.chapterNumber, this.nameSanskrit, this.nameEnglish, final  List<ScriptureVerse> verses = const <ScriptureVerse>[]}): _verses = verses;
  factory _ChapterDetail.fromJson(Map<String, dynamic> json) => _$ChapterDetailFromJson(json);

@override final  String id;
@override final  String textId;
@override final  int chapterNumber;
@override final  String? nameSanskrit;
@override final  String? nameEnglish;
 final  List<ScriptureVerse> _verses;
@override@JsonKey() List<ScriptureVerse> get verses {
  if (_verses is EqualUnmodifiableListView) return _verses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_verses);
}


/// Create a copy of ChapterDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterDetailCopyWith<_ChapterDetail> get copyWith => __$ChapterDetailCopyWithImpl<_ChapterDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.textId, textId) || other.textId == textId)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&const DeepCollectionEquality().equals(other._verses, _verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textId,chapterNumber,nameSanskrit,nameEnglish,const DeepCollectionEquality().hash(_verses));

@override
String toString() {
  return 'ChapterDetail(id: $id, textId: $textId, chapterNumber: $chapterNumber, nameSanskrit: $nameSanskrit, nameEnglish: $nameEnglish, verses: $verses)';
}


}

/// @nodoc
abstract mixin class _$ChapterDetailCopyWith<$Res> implements $ChapterDetailCopyWith<$Res> {
  factory _$ChapterDetailCopyWith(_ChapterDetail value, $Res Function(_ChapterDetail) _then) = __$ChapterDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String textId, int chapterNumber, String? nameSanskrit, String? nameEnglish, List<ScriptureVerse> verses
});




}
/// @nodoc
class __$ChapterDetailCopyWithImpl<$Res>
    implements _$ChapterDetailCopyWith<$Res> {
  __$ChapterDetailCopyWithImpl(this._self, this._then);

  final _ChapterDetail _self;
  final $Res Function(_ChapterDetail) _then;

/// Create a copy of ChapterDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? textId = null,Object? chapterNumber = null,Object? nameSanskrit = freezed,Object? nameEnglish = freezed,Object? verses = null,}) {
  return _then(_ChapterDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textId: null == textId ? _self.textId : textId // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,verses: null == verses ? _self._verses : verses // ignore: cast_nullable_to_non_nullable
as List<ScriptureVerse>,
  ));
}


}

// dart format on
