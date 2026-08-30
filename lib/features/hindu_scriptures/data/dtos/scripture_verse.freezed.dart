// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scripture_verse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScriptureVerse {

 String get id; String get textId; String get chapterId; int get verseNumber; String get sanskritText; String? get transliteration; bool get isFeatured; List<VerseTranslation> get translations; VerseChapterRef? get chapter; VerseTextRef? get text;
/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptureVerseCopyWith<ScriptureVerse> get copyWith => _$ScriptureVerseCopyWithImpl<ScriptureVerse>(this as ScriptureVerse, _$identity);

  /// Serializes this ScriptureVerse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptureVerse&&(identical(other.id, id) || other.id == id)&&(identical(other.textId, textId) || other.textId == textId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&const DeepCollectionEquality().equals(other.translations, translations)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textId,chapterId,verseNumber,sanskritText,transliteration,isFeatured,const DeepCollectionEquality().hash(translations),chapter,text);

@override
String toString() {
  return 'ScriptureVerse(id: $id, textId: $textId, chapterId: $chapterId, verseNumber: $verseNumber, sanskritText: $sanskritText, transliteration: $transliteration, isFeatured: $isFeatured, translations: $translations, chapter: $chapter, text: $text)';
}


}

/// @nodoc
abstract mixin class $ScriptureVerseCopyWith<$Res>  {
  factory $ScriptureVerseCopyWith(ScriptureVerse value, $Res Function(ScriptureVerse) _then) = _$ScriptureVerseCopyWithImpl;
@useResult
$Res call({
 String id, String textId, String chapterId, int verseNumber, String sanskritText, String? transliteration, bool isFeatured, List<VerseTranslation> translations, VerseChapterRef? chapter, VerseTextRef? text
});


$VerseChapterRefCopyWith<$Res>? get chapter;$VerseTextRefCopyWith<$Res>? get text;

}
/// @nodoc
class _$ScriptureVerseCopyWithImpl<$Res>
    implements $ScriptureVerseCopyWith<$Res> {
  _$ScriptureVerseCopyWithImpl(this._self, this._then);

  final ScriptureVerse _self;
  final $Res Function(ScriptureVerse) _then;

/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? textId = null,Object? chapterId = null,Object? verseNumber = null,Object? sanskritText = null,Object? transliteration = freezed,Object? isFeatured = null,Object? translations = null,Object? chapter = freezed,Object? text = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textId: null == textId ? _self.textId : textId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,sanskritText: null == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<VerseTranslation>,chapter: freezed == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as VerseChapterRef?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as VerseTextRef?,
  ));
}
/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseChapterRefCopyWith<$Res>? get chapter {
    if (_self.chapter == null) {
    return null;
  }

  return $VerseChapterRefCopyWith<$Res>(_self.chapter!, (value) {
    return _then(_self.copyWith(chapter: value));
  });
}/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseTextRefCopyWith<$Res>? get text {
    if (_self.text == null) {
    return null;
  }

  return $VerseTextRefCopyWith<$Res>(_self.text!, (value) {
    return _then(_self.copyWith(text: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScriptureVerse].
extension ScriptureVersePatterns on ScriptureVerse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScriptureVerse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScriptureVerse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScriptureVerse value)  $default,){
final _that = this;
switch (_that) {
case _ScriptureVerse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScriptureVerse value)?  $default,){
final _that = this;
switch (_that) {
case _ScriptureVerse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String textId,  String chapterId,  int verseNumber,  String sanskritText,  String? transliteration,  bool isFeatured,  List<VerseTranslation> translations,  VerseChapterRef? chapter,  VerseTextRef? text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScriptureVerse() when $default != null:
return $default(_that.id,_that.textId,_that.chapterId,_that.verseNumber,_that.sanskritText,_that.transliteration,_that.isFeatured,_that.translations,_that.chapter,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String textId,  String chapterId,  int verseNumber,  String sanskritText,  String? transliteration,  bool isFeatured,  List<VerseTranslation> translations,  VerseChapterRef? chapter,  VerseTextRef? text)  $default,) {final _that = this;
switch (_that) {
case _ScriptureVerse():
return $default(_that.id,_that.textId,_that.chapterId,_that.verseNumber,_that.sanskritText,_that.transliteration,_that.isFeatured,_that.translations,_that.chapter,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String textId,  String chapterId,  int verseNumber,  String sanskritText,  String? transliteration,  bool isFeatured,  List<VerseTranslation> translations,  VerseChapterRef? chapter,  VerseTextRef? text)?  $default,) {final _that = this;
switch (_that) {
case _ScriptureVerse() when $default != null:
return $default(_that.id,_that.textId,_that.chapterId,_that.verseNumber,_that.sanskritText,_that.transliteration,_that.isFeatured,_that.translations,_that.chapter,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScriptureVerse implements ScriptureVerse {
  const _ScriptureVerse({required this.id, required this.textId, required this.chapterId, required this.verseNumber, required this.sanskritText, this.transliteration, this.isFeatured = false, final  List<VerseTranslation> translations = const <VerseTranslation>[], this.chapter, this.text}): _translations = translations;
  factory _ScriptureVerse.fromJson(Map<String, dynamic> json) => _$ScriptureVerseFromJson(json);

@override final  String id;
@override final  String textId;
@override final  String chapterId;
@override final  int verseNumber;
@override final  String sanskritText;
@override final  String? transliteration;
@override@JsonKey() final  bool isFeatured;
 final  List<VerseTranslation> _translations;
@override@JsonKey() List<VerseTranslation> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}

@override final  VerseChapterRef? chapter;
@override final  VerseTextRef? text;

/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScriptureVerseCopyWith<_ScriptureVerse> get copyWith => __$ScriptureVerseCopyWithImpl<_ScriptureVerse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScriptureVerseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScriptureVerse&&(identical(other.id, id) || other.id == id)&&(identical(other.textId, textId) || other.textId == textId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.sanskritText, sanskritText) || other.sanskritText == sanskritText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&const DeepCollectionEquality().equals(other._translations, _translations)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textId,chapterId,verseNumber,sanskritText,transliteration,isFeatured,const DeepCollectionEquality().hash(_translations),chapter,text);

@override
String toString() {
  return 'ScriptureVerse(id: $id, textId: $textId, chapterId: $chapterId, verseNumber: $verseNumber, sanskritText: $sanskritText, transliteration: $transliteration, isFeatured: $isFeatured, translations: $translations, chapter: $chapter, text: $text)';
}


}

/// @nodoc
abstract mixin class _$ScriptureVerseCopyWith<$Res> implements $ScriptureVerseCopyWith<$Res> {
  factory _$ScriptureVerseCopyWith(_ScriptureVerse value, $Res Function(_ScriptureVerse) _then) = __$ScriptureVerseCopyWithImpl;
@override @useResult
$Res call({
 String id, String textId, String chapterId, int verseNumber, String sanskritText, String? transliteration, bool isFeatured, List<VerseTranslation> translations, VerseChapterRef? chapter, VerseTextRef? text
});


@override $VerseChapterRefCopyWith<$Res>? get chapter;@override $VerseTextRefCopyWith<$Res>? get text;

}
/// @nodoc
class __$ScriptureVerseCopyWithImpl<$Res>
    implements _$ScriptureVerseCopyWith<$Res> {
  __$ScriptureVerseCopyWithImpl(this._self, this._then);

  final _ScriptureVerse _self;
  final $Res Function(_ScriptureVerse) _then;

/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? textId = null,Object? chapterId = null,Object? verseNumber = null,Object? sanskritText = null,Object? transliteration = freezed,Object? isFeatured = null,Object? translations = null,Object? chapter = freezed,Object? text = freezed,}) {
  return _then(_ScriptureVerse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textId: null == textId ? _self.textId : textId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,sanskritText: null == sanskritText ? _self.sanskritText : sanskritText // ignore: cast_nullable_to_non_nullable
as String,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<VerseTranslation>,chapter: freezed == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as VerseChapterRef?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as VerseTextRef?,
  ));
}

/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseChapterRefCopyWith<$Res>? get chapter {
    if (_self.chapter == null) {
    return null;
  }

  return $VerseChapterRefCopyWith<$Res>(_self.chapter!, (value) {
    return _then(_self.copyWith(chapter: value));
  });
}/// Create a copy of ScriptureVerse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseTextRefCopyWith<$Res>? get text {
    if (_self.text == null) {
    return null;
  }

  return $VerseTextRefCopyWith<$Res>(_self.text!, (value) {
    return _then(_self.copyWith(text: value));
  });
}
}


/// @nodoc
mixin _$VerseChapterRef {

 int get chapterNumber; String? get nameEnglish;
/// Create a copy of VerseChapterRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseChapterRefCopyWith<VerseChapterRef> get copyWith => _$VerseChapterRefCopyWithImpl<VerseChapterRef>(this as VerseChapterRef, _$identity);

  /// Serializes this VerseChapterRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseChapterRef&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapterNumber,nameEnglish);

@override
String toString() {
  return 'VerseChapterRef(chapterNumber: $chapterNumber, nameEnglish: $nameEnglish)';
}


}

/// @nodoc
abstract mixin class $VerseChapterRefCopyWith<$Res>  {
  factory $VerseChapterRefCopyWith(VerseChapterRef value, $Res Function(VerseChapterRef) _then) = _$VerseChapterRefCopyWithImpl;
@useResult
$Res call({
 int chapterNumber, String? nameEnglish
});




}
/// @nodoc
class _$VerseChapterRefCopyWithImpl<$Res>
    implements $VerseChapterRefCopyWith<$Res> {
  _$VerseChapterRefCopyWithImpl(this._self, this._then);

  final VerseChapterRef _self;
  final $Res Function(VerseChapterRef) _then;

/// Create a copy of VerseChapterRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapterNumber = null,Object? nameEnglish = freezed,}) {
  return _then(_self.copyWith(
chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerseChapterRef].
extension VerseChapterRefPatterns on VerseChapterRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseChapterRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseChapterRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseChapterRef value)  $default,){
final _that = this;
switch (_that) {
case _VerseChapterRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseChapterRef value)?  $default,){
final _that = this;
switch (_that) {
case _VerseChapterRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chapterNumber,  String? nameEnglish)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseChapterRef() when $default != null:
return $default(_that.chapterNumber,_that.nameEnglish);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chapterNumber,  String? nameEnglish)  $default,) {final _that = this;
switch (_that) {
case _VerseChapterRef():
return $default(_that.chapterNumber,_that.nameEnglish);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chapterNumber,  String? nameEnglish)?  $default,) {final _that = this;
switch (_that) {
case _VerseChapterRef() when $default != null:
return $default(_that.chapterNumber,_that.nameEnglish);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerseChapterRef implements VerseChapterRef {
  const _VerseChapterRef({required this.chapterNumber, this.nameEnglish});
  factory _VerseChapterRef.fromJson(Map<String, dynamic> json) => _$VerseChapterRefFromJson(json);

@override final  int chapterNumber;
@override final  String? nameEnglish;

/// Create a copy of VerseChapterRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseChapterRefCopyWith<_VerseChapterRef> get copyWith => __$VerseChapterRefCopyWithImpl<_VerseChapterRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerseChapterRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseChapterRef&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapterNumber,nameEnglish);

@override
String toString() {
  return 'VerseChapterRef(chapterNumber: $chapterNumber, nameEnglish: $nameEnglish)';
}


}

/// @nodoc
abstract mixin class _$VerseChapterRefCopyWith<$Res> implements $VerseChapterRefCopyWith<$Res> {
  factory _$VerseChapterRefCopyWith(_VerseChapterRef value, $Res Function(_VerseChapterRef) _then) = __$VerseChapterRefCopyWithImpl;
@override @useResult
$Res call({
 int chapterNumber, String? nameEnglish
});




}
/// @nodoc
class __$VerseChapterRefCopyWithImpl<$Res>
    implements _$VerseChapterRefCopyWith<$Res> {
  __$VerseChapterRefCopyWithImpl(this._self, this._then);

  final _VerseChapterRef _self;
  final $Res Function(_VerseChapterRef) _then;

/// Create a copy of VerseChapterRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapterNumber = null,Object? nameEnglish = freezed,}) {
  return _then(_VerseChapterRef(
chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$VerseTextRef {

 String get slug; String? get nameEnglish;
/// Create a copy of VerseTextRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseTextRefCopyWith<VerseTextRef> get copyWith => _$VerseTextRefCopyWithImpl<VerseTextRef>(this as VerseTextRef, _$identity);

  /// Serializes this VerseTextRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseTextRef&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nameEnglish);

@override
String toString() {
  return 'VerseTextRef(slug: $slug, nameEnglish: $nameEnglish)';
}


}

/// @nodoc
abstract mixin class $VerseTextRefCopyWith<$Res>  {
  factory $VerseTextRefCopyWith(VerseTextRef value, $Res Function(VerseTextRef) _then) = _$VerseTextRefCopyWithImpl;
@useResult
$Res call({
 String slug, String? nameEnglish
});




}
/// @nodoc
class _$VerseTextRefCopyWithImpl<$Res>
    implements $VerseTextRefCopyWith<$Res> {
  _$VerseTextRefCopyWithImpl(this._self, this._then);

  final VerseTextRef _self;
  final $Res Function(VerseTextRef) _then;

/// Create a copy of VerseTextRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? nameEnglish = freezed,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerseTextRef].
extension VerseTextRefPatterns on VerseTextRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseTextRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseTextRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseTextRef value)  $default,){
final _that = this;
switch (_that) {
case _VerseTextRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseTextRef value)?  $default,){
final _that = this;
switch (_that) {
case _VerseTextRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String? nameEnglish)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseTextRef() when $default != null:
return $default(_that.slug,_that.nameEnglish);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String? nameEnglish)  $default,) {final _that = this;
switch (_that) {
case _VerseTextRef():
return $default(_that.slug,_that.nameEnglish);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String? nameEnglish)?  $default,) {final _that = this;
switch (_that) {
case _VerseTextRef() when $default != null:
return $default(_that.slug,_that.nameEnglish);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerseTextRef implements VerseTextRef {
  const _VerseTextRef({required this.slug, this.nameEnglish});
  factory _VerseTextRef.fromJson(Map<String, dynamic> json) => _$VerseTextRefFromJson(json);

@override final  String slug;
@override final  String? nameEnglish;

/// Create a copy of VerseTextRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseTextRefCopyWith<_VerseTextRef> get copyWith => __$VerseTextRefCopyWithImpl<_VerseTextRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerseTextRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseTextRef&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nameEnglish);

@override
String toString() {
  return 'VerseTextRef(slug: $slug, nameEnglish: $nameEnglish)';
}


}

/// @nodoc
abstract mixin class _$VerseTextRefCopyWith<$Res> implements $VerseTextRefCopyWith<$Res> {
  factory _$VerseTextRefCopyWith(_VerseTextRef value, $Res Function(_VerseTextRef) _then) = __$VerseTextRefCopyWithImpl;
@override @useResult
$Res call({
 String slug, String? nameEnglish
});




}
/// @nodoc
class __$VerseTextRefCopyWithImpl<$Res>
    implements _$VerseTextRefCopyWith<$Res> {
  __$VerseTextRefCopyWithImpl(this._self, this._then);

  final _VerseTextRef _self;
  final $Res Function(_VerseTextRef) _then;

/// Create a copy of VerseTextRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? nameEnglish = freezed,}) {
  return _then(_VerseTextRef(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: freezed == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
