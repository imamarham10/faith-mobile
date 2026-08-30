// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scripture_bookmark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScriptureBookmark {

 String get id; String get verseId; String? get note; String? get textSlug; String? get textName; int? get chapterNumber; String? get sanskritText; int? get verseNumber; String? get translation; DateTime? get createdAt;
/// Create a copy of ScriptureBookmark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptureBookmarkCopyWith<ScriptureBookmark> get copyWith => _$ScriptureBookmarkCopyWithImpl<ScriptureBookmark>(this as ScriptureBookmark, _$identity);

  /// Serializes this ScriptureBookmark to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptureBookmark&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.note, note) || other.note == note)&&(identical(other.textSlug, textSlug) || other.textSlug == textSlug)&&(identical(other.textName, textName) || other.textName == textName)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verseId,note,textSlug,textName,chapterNumber,sanskritText,verseNumber,translation,createdAt);

@override
String toString() {
  return 'ScriptureBookmark(id: $id, verseId: $verseId, note: $note, textSlug: $textSlug, textName: $textName, chapterNumber: $chapterNumber, sanskritText: $sanskritText, verseNumber: $verseNumber, translation: $translation, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ScriptureBookmarkCopyWith<$Res>  {
  factory $ScriptureBookmarkCopyWith(ScriptureBookmark value, $Res Function(ScriptureBookmark) _then) = _$ScriptureBookmarkCopyWithImpl;
@useResult
$Res call({
 String id, String verseId, String? note, String? textSlug, String? textName, int? chapterNumber, String? sanskritText, int? verseNumber, String? translation, DateTime? createdAt
});




}
/// @nodoc
class _$ScriptureBookmarkCopyWithImpl<$Res>
    implements $ScriptureBookmarkCopyWith<$Res> {
  _$ScriptureBookmarkCopyWithImpl(this._self, this._then);

  final ScriptureBookmark _self;
  final $Res Function(ScriptureBookmark) _then;

/// Create a copy of ScriptureBookmark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? verseId = null,Object? note = freezed,Object? textSlug = freezed,Object? textName = freezed,Object? chapterNumber = freezed,Object? sanskritText = freezed,Object? verseNumber = freezed,Object? translation = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,textSlug: freezed == textSlug ? _self.textSlug : textSlug // ignore: cast_nullable_to_non_nullable
as String?,textName: freezed == textName ? _self.textName : textName // ignore: cast_nullable_to_non_nullable
as String?,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,sanskritText: freezed == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String?,verseNumber: freezed == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScriptureBookmark].
extension ScriptureBookmarkPatterns on ScriptureBookmark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScriptureBookmark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScriptureBookmark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScriptureBookmark value)  $default,){
final _that = this;
switch (_that) {
case _ScriptureBookmark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScriptureBookmark value)?  $default,){
final _that = this;
switch (_that) {
case _ScriptureBookmark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String verseId,  String? note,  String? textSlug,  String? textName,  int? chapterNumber,  String? sanskritText,  int? verseNumber,  String? translation,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScriptureBookmark() when $default != null:
return $default(_that.id,_that.verseId,_that.note,_that.textSlug,_that.textName,_that.chapterNumber,_that.sanskritText,_that.verseNumber,_that.translation,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String verseId,  String? note,  String? textSlug,  String? textName,  int? chapterNumber,  String? sanskritText,  int? verseNumber,  String? translation,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ScriptureBookmark():
return $default(_that.id,_that.verseId,_that.note,_that.textSlug,_that.textName,_that.chapterNumber,_that.sanskritText,_that.verseNumber,_that.translation,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String verseId,  String? note,  String? textSlug,  String? textName,  int? chapterNumber,  String? sanskritText,  int? verseNumber,  String? translation,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ScriptureBookmark() when $default != null:
return $default(_that.id,_that.verseId,_that.note,_that.textSlug,_that.textName,_that.chapterNumber,_that.sanskritText,_that.verseNumber,_that.translation,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScriptureBookmark implements ScriptureBookmark {
  const _ScriptureBookmark({required this.id, required this.verseId, this.note, this.textSlug, this.textName, this.chapterNumber, this.sanskritText, this.verseNumber, this.translation, this.createdAt});
  factory _ScriptureBookmark.fromJson(Map<String, dynamic> json) => _$ScriptureBookmarkFromJson(json);

@override final  String id;
@override final  String verseId;
@override final  String? note;
@override final  String? textSlug;
@override final  String? textName;
@override final  int? chapterNumber;
@override final  String? sanskritText;
@override final  int? verseNumber;
@override final  String? translation;
@override final  DateTime? createdAt;

/// Create a copy of ScriptureBookmark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScriptureBookmarkCopyWith<_ScriptureBookmark> get copyWith => __$ScriptureBookmarkCopyWithImpl<_ScriptureBookmark>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScriptureBookmarkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScriptureBookmark&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.note, note) || other.note == note)&&(identical(other.textSlug, textSlug) || other.textSlug == textSlug)&&(identical(other.textName, textName) || other.textName == textName)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verseId,note,textSlug,textName,chapterNumber,sanskritText,verseNumber,translation,createdAt);

@override
String toString() {
  return 'ScriptureBookmark(id: $id, verseId: $verseId, note: $note, textSlug: $textSlug, textName: $textName, chapterNumber: $chapterNumber, sanskritText: $sanskritText, verseNumber: $verseNumber, translation: $translation, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ScriptureBookmarkCopyWith<$Res> implements $ScriptureBookmarkCopyWith<$Res> {
  factory _$ScriptureBookmarkCopyWith(_ScriptureBookmark value, $Res Function(_ScriptureBookmark) _then) = __$ScriptureBookmarkCopyWithImpl;
@override @useResult
$Res call({
 String id, String verseId, String? note, String? textSlug, String? textName, int? chapterNumber, String? sanskritText, int? verseNumber, String? translation, DateTime? createdAt
});




}
/// @nodoc
class __$ScriptureBookmarkCopyWithImpl<$Res>
    implements _$ScriptureBookmarkCopyWith<$Res> {
  __$ScriptureBookmarkCopyWithImpl(this._self, this._then);

  final _ScriptureBookmark _self;
  final $Res Function(_ScriptureBookmark) _then;

/// Create a copy of ScriptureBookmark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? verseId = null,Object? note = freezed,Object? textSlug = freezed,Object? textName = freezed,Object? chapterNumber = freezed,Object? sanskritText = freezed,Object? verseNumber = freezed,Object? translation = freezed,Object? createdAt = freezed,}) {
  return _then(_ScriptureBookmark(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,textSlug: freezed == textSlug ? _self.textSlug : textSlug // ignore: cast_nullable_to_non_nullable
as String?,textName: freezed == textName ? _self.textName : textName // ignore: cast_nullable_to_non_nullable
as String?,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,sanskritText: freezed == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String?,verseNumber: freezed == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
