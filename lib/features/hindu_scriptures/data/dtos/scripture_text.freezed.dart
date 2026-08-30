// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scripture_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScriptureText {

 String get id; String get slug; String get nameEnglish; String get nameSanskrit; String get type; int get totalVerses; bool get isPremium; int? get chapterCount;
/// Create a copy of ScriptureText
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptureTextCopyWith<ScriptureText> get copyWith => _$ScriptureTextCopyWithImpl<ScriptureText>(this as ScriptureText, _$identity);

  /// Serializes this ScriptureText to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptureText&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.chapterCount, chapterCount) || other.chapterCount == chapterCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameSanskrit,type,totalVerses,isPremium,chapterCount);

@override
String toString() {
  return 'ScriptureText(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit, type: $type, totalVerses: $totalVerses, isPremium: $isPremium, chapterCount: $chapterCount)';
}


}

/// @nodoc
abstract mixin class $ScriptureTextCopyWith<$Res>  {
  factory $ScriptureTextCopyWith(ScriptureText value, $Res Function(ScriptureText) _then) = _$ScriptureTextCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String nameEnglish, String nameSanskrit, String type, int totalVerses, bool isPremium, int? chapterCount
});




}
/// @nodoc
class _$ScriptureTextCopyWithImpl<$Res>
    implements $ScriptureTextCopyWith<$Res> {
  _$ScriptureTextCopyWithImpl(this._self, this._then);

  final ScriptureText _self;
  final $Res Function(ScriptureText) _then;

/// Create a copy of ScriptureText
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = null,Object? type = null,Object? totalVerses = null,Object? isPremium = null,Object? chapterCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,totalVerses: null == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,chapterCount: freezed == chapterCount ? _self.chapterCount : chapterCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScriptureText].
extension ScriptureTextPatterns on ScriptureText {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScriptureText value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScriptureText() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScriptureText value)  $default,){
final _that = this;
switch (_that) {
case _ScriptureText():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScriptureText value)?  $default,){
final _that = this;
switch (_that) {
case _ScriptureText() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String nameSanskrit,  String type,  int totalVerses,  bool isPremium,  int? chapterCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScriptureText() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.type,_that.totalVerses,_that.isPremium,_that.chapterCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String nameSanskrit,  String type,  int totalVerses,  bool isPremium,  int? chapterCount)  $default,) {final _that = this;
switch (_that) {
case _ScriptureText():
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.type,_that.totalVerses,_that.isPremium,_that.chapterCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String nameEnglish,  String nameSanskrit,  String type,  int totalVerses,  bool isPremium,  int? chapterCount)?  $default,) {final _that = this;
switch (_that) {
case _ScriptureText() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.type,_that.totalVerses,_that.isPremium,_that.chapterCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScriptureText implements ScriptureText {
  const _ScriptureText({required this.id, required this.slug, required this.nameEnglish, required this.nameSanskrit, required this.type, required this.totalVerses, this.isPremium = false, this.chapterCount});
  factory _ScriptureText.fromJson(Map<String, dynamic> json) => _$ScriptureTextFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String nameEnglish;
@override final  String nameSanskrit;
@override final  String type;
@override final  int totalVerses;
@override@JsonKey() final  bool isPremium;
@override final  int? chapterCount;

/// Create a copy of ScriptureText
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScriptureTextCopyWith<_ScriptureText> get copyWith => __$ScriptureTextCopyWithImpl<_ScriptureText>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScriptureTextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScriptureText&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.chapterCount, chapterCount) || other.chapterCount == chapterCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameSanskrit,type,totalVerses,isPremium,chapterCount);

@override
String toString() {
  return 'ScriptureText(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit, type: $type, totalVerses: $totalVerses, isPremium: $isPremium, chapterCount: $chapterCount)';
}


}

/// @nodoc
abstract mixin class _$ScriptureTextCopyWith<$Res> implements $ScriptureTextCopyWith<$Res> {
  factory _$ScriptureTextCopyWith(_ScriptureText value, $Res Function(_ScriptureText) _then) = __$ScriptureTextCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String nameEnglish, String nameSanskrit, String type, int totalVerses, bool isPremium, int? chapterCount
});




}
/// @nodoc
class __$ScriptureTextCopyWithImpl<$Res>
    implements _$ScriptureTextCopyWith<$Res> {
  __$ScriptureTextCopyWithImpl(this._self, this._then);

  final _ScriptureText _self;
  final $Res Function(_ScriptureText) _then;

/// Create a copy of ScriptureText
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = null,Object? type = null,Object? totalVerses = null,Object? isPremium = null,Object? chapterCount = freezed,}) {
  return _then(_ScriptureText(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,totalVerses: null == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,chapterCount: freezed == chapterCount ? _self.chapterCount : chapterCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ScriptureTextDetail {

 String get id; String get slug; String get nameEnglish; String get nameSanskrit; String get type; int get totalVerses; bool get isPremium; List<ChapterSummary> get chapters;
/// Create a copy of ScriptureTextDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptureTextDetailCopyWith<ScriptureTextDetail> get copyWith => _$ScriptureTextDetailCopyWithImpl<ScriptureTextDetail>(this as ScriptureTextDetail, _$identity);

  /// Serializes this ScriptureTextDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptureTextDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameSanskrit,type,totalVerses,isPremium,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'ScriptureTextDetail(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit, type: $type, totalVerses: $totalVerses, isPremium: $isPremium, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $ScriptureTextDetailCopyWith<$Res>  {
  factory $ScriptureTextDetailCopyWith(ScriptureTextDetail value, $Res Function(ScriptureTextDetail) _then) = _$ScriptureTextDetailCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String nameEnglish, String nameSanskrit, String type, int totalVerses, bool isPremium, List<ChapterSummary> chapters
});




}
/// @nodoc
class _$ScriptureTextDetailCopyWithImpl<$Res>
    implements $ScriptureTextDetailCopyWith<$Res> {
  _$ScriptureTextDetailCopyWithImpl(this._self, this._then);

  final ScriptureTextDetail _self;
  final $Res Function(ScriptureTextDetail) _then;

/// Create a copy of ScriptureTextDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = null,Object? type = null,Object? totalVerses = null,Object? isPremium = null,Object? chapters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,totalVerses: null == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<ChapterSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScriptureTextDetail].
extension ScriptureTextDetailPatterns on ScriptureTextDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScriptureTextDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScriptureTextDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScriptureTextDetail value)  $default,){
final _that = this;
switch (_that) {
case _ScriptureTextDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScriptureTextDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ScriptureTextDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String nameSanskrit,  String type,  int totalVerses,  bool isPremium,  List<ChapterSummary> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScriptureTextDetail() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.type,_that.totalVerses,_that.isPremium,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String nameEnglish,  String nameSanskrit,  String type,  int totalVerses,  bool isPremium,  List<ChapterSummary> chapters)  $default,) {final _that = this;
switch (_that) {
case _ScriptureTextDetail():
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.type,_that.totalVerses,_that.isPremium,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String nameEnglish,  String nameSanskrit,  String type,  int totalVerses,  bool isPremium,  List<ChapterSummary> chapters)?  $default,) {final _that = this;
switch (_that) {
case _ScriptureTextDetail() when $default != null:
return $default(_that.id,_that.slug,_that.nameEnglish,_that.nameSanskrit,_that.type,_that.totalVerses,_that.isPremium,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScriptureTextDetail implements ScriptureTextDetail {
  const _ScriptureTextDetail({required this.id, required this.slug, required this.nameEnglish, required this.nameSanskrit, required this.type, required this.totalVerses, this.isPremium = false, final  List<ChapterSummary> chapters = const <ChapterSummary>[]}): _chapters = chapters;
  factory _ScriptureTextDetail.fromJson(Map<String, dynamic> json) => _$ScriptureTextDetailFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String nameEnglish;
@override final  String nameSanskrit;
@override final  String type;
@override final  int totalVerses;
@override@JsonKey() final  bool isPremium;
 final  List<ChapterSummary> _chapters;
@override@JsonKey() List<ChapterSummary> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of ScriptureTextDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScriptureTextDetailCopyWith<_ScriptureTextDetail> get copyWith => __$ScriptureTextDetailCopyWithImpl<_ScriptureTextDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScriptureTextDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScriptureTextDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,nameEnglish,nameSanskrit,type,totalVerses,isPremium,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'ScriptureTextDetail(id: $id, slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit, type: $type, totalVerses: $totalVerses, isPremium: $isPremium, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$ScriptureTextDetailCopyWith<$Res> implements $ScriptureTextDetailCopyWith<$Res> {
  factory _$ScriptureTextDetailCopyWith(_ScriptureTextDetail value, $Res Function(_ScriptureTextDetail) _then) = __$ScriptureTextDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String nameEnglish, String nameSanskrit, String type, int totalVerses, bool isPremium, List<ChapterSummary> chapters
});




}
/// @nodoc
class __$ScriptureTextDetailCopyWithImpl<$Res>
    implements _$ScriptureTextDetailCopyWith<$Res> {
  __$ScriptureTextDetailCopyWithImpl(this._self, this._then);

  final _ScriptureTextDetail _self;
  final $Res Function(_ScriptureTextDetail) _then;

/// Create a copy of ScriptureTextDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = null,Object? type = null,Object? totalVerses = null,Object? isPremium = null,Object? chapters = null,}) {
  return _then(_ScriptureTextDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,totalVerses: null == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<ChapterSummary>,
  ));
}


}

// dart format on
