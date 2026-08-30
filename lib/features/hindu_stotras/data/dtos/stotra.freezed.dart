// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stotra.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stotra {

 String get id; String get slug; String get titleSanskrit; String get titleEnglish; String get type; String? get deityKey; bool get isPremium; StotraCategoryRef? get category; int get verseCount;
/// Create a copy of Stotra
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StotraCopyWith<Stotra> get copyWith => _$StotraCopyWithImpl<Stotra>(this as Stotra, _$identity);

  /// Serializes this Stotra to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stotra&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.titleSanskrit, titleSanskrit) || other.titleSanskrit == titleSanskrit)&&(identical(other.titleEnglish, titleEnglish) || other.titleEnglish == titleEnglish)&&(identical(other.type, type) || other.type == type)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.category, category) || other.category == category)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,titleSanskrit,titleEnglish,type,deityKey,isPremium,category,verseCount);

@override
String toString() {
  return 'Stotra(id: $id, slug: $slug, titleSanskrit: $titleSanskrit, titleEnglish: $titleEnglish, type: $type, deityKey: $deityKey, isPremium: $isPremium, category: $category, verseCount: $verseCount)';
}


}

/// @nodoc
abstract mixin class $StotraCopyWith<$Res>  {
  factory $StotraCopyWith(Stotra value, $Res Function(Stotra) _then) = _$StotraCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String titleSanskrit, String titleEnglish, String type, String? deityKey, bool isPremium, StotraCategoryRef? category, int verseCount
});


$StotraCategoryRefCopyWith<$Res>? get category;

}
/// @nodoc
class _$StotraCopyWithImpl<$Res>
    implements $StotraCopyWith<$Res> {
  _$StotraCopyWithImpl(this._self, this._then);

  final Stotra _self;
  final $Res Function(Stotra) _then;

/// Create a copy of Stotra
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? titleSanskrit = null,Object? titleEnglish = null,Object? type = null,Object? deityKey = freezed,Object? isPremium = null,Object? category = freezed,Object? verseCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,titleSanskrit: null == titleSanskrit ? _self.titleSanskrit : titleSanskrit // ignore: cast_nullable_to_non_nullable
as String,titleEnglish: null == titleEnglish ? _self.titleEnglish : titleEnglish // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as StotraCategoryRef?,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Stotra
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StotraCategoryRefCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $StotraCategoryRefCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [Stotra].
extension StotraPatterns on Stotra {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stotra value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stotra() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stotra value)  $default,){
final _that = this;
switch (_that) {
case _Stotra():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stotra value)?  $default,){
final _that = this;
switch (_that) {
case _Stotra() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String titleSanskrit,  String titleEnglish,  String type,  String? deityKey,  bool isPremium,  StotraCategoryRef? category,  int verseCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stotra() when $default != null:
return $default(_that.id,_that.slug,_that.titleSanskrit,_that.titleEnglish,_that.type,_that.deityKey,_that.isPremium,_that.category,_that.verseCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String titleSanskrit,  String titleEnglish,  String type,  String? deityKey,  bool isPremium,  StotraCategoryRef? category,  int verseCount)  $default,) {final _that = this;
switch (_that) {
case _Stotra():
return $default(_that.id,_that.slug,_that.titleSanskrit,_that.titleEnglish,_that.type,_that.deityKey,_that.isPremium,_that.category,_that.verseCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String titleSanskrit,  String titleEnglish,  String type,  String? deityKey,  bool isPremium,  StotraCategoryRef? category,  int verseCount)?  $default,) {final _that = this;
switch (_that) {
case _Stotra() when $default != null:
return $default(_that.id,_that.slug,_that.titleSanskrit,_that.titleEnglish,_that.type,_that.deityKey,_that.isPremium,_that.category,_that.verseCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stotra implements Stotra {
  const _Stotra({required this.id, required this.slug, required this.titleSanskrit, required this.titleEnglish, required this.type, this.deityKey, this.isPremium = false, this.category, this.verseCount = 0});
  factory _Stotra.fromJson(Map<String, dynamic> json) => _$StotraFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String titleSanskrit;
@override final  String titleEnglish;
@override final  String type;
@override final  String? deityKey;
@override@JsonKey() final  bool isPremium;
@override final  StotraCategoryRef? category;
@override@JsonKey() final  int verseCount;

/// Create a copy of Stotra
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StotraCopyWith<_Stotra> get copyWith => __$StotraCopyWithImpl<_Stotra>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StotraToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stotra&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.titleSanskrit, titleSanskrit) || other.titleSanskrit == titleSanskrit)&&(identical(other.titleEnglish, titleEnglish) || other.titleEnglish == titleEnglish)&&(identical(other.type, type) || other.type == type)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.category, category) || other.category == category)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,titleSanskrit,titleEnglish,type,deityKey,isPremium,category,verseCount);

@override
String toString() {
  return 'Stotra(id: $id, slug: $slug, titleSanskrit: $titleSanskrit, titleEnglish: $titleEnglish, type: $type, deityKey: $deityKey, isPremium: $isPremium, category: $category, verseCount: $verseCount)';
}


}

/// @nodoc
abstract mixin class _$StotraCopyWith<$Res> implements $StotraCopyWith<$Res> {
  factory _$StotraCopyWith(_Stotra value, $Res Function(_Stotra) _then) = __$StotraCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String titleSanskrit, String titleEnglish, String type, String? deityKey, bool isPremium, StotraCategoryRef? category, int verseCount
});


@override $StotraCategoryRefCopyWith<$Res>? get category;

}
/// @nodoc
class __$StotraCopyWithImpl<$Res>
    implements _$StotraCopyWith<$Res> {
  __$StotraCopyWithImpl(this._self, this._then);

  final _Stotra _self;
  final $Res Function(_Stotra) _then;

/// Create a copy of Stotra
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? titleSanskrit = null,Object? titleEnglish = null,Object? type = null,Object? deityKey = freezed,Object? isPremium = null,Object? category = freezed,Object? verseCount = null,}) {
  return _then(_Stotra(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,titleSanskrit: null == titleSanskrit ? _self.titleSanskrit : titleSanskrit // ignore: cast_nullable_to_non_nullable
as String,titleEnglish: null == titleEnglish ? _self.titleEnglish : titleEnglish // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as StotraCategoryRef?,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Stotra
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StotraCategoryRefCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $StotraCategoryRefCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// @nodoc
mixin _$StotraDetail {

 String get id; String get categoryId; String get slug; String get titleSanskrit; String get titleEnglish; String get type; String? get deityKey; bool get isPremium; DateTime? get createdAt; StotraCategoryRef? get category; List<StotraVerse> get verses;
/// Create a copy of StotraDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StotraDetailCopyWith<StotraDetail> get copyWith => _$StotraDetailCopyWithImpl<StotraDetail>(this as StotraDetail, _$identity);

  /// Serializes this StotraDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StotraDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.titleSanskrit, titleSanskrit) || other.titleSanskrit == titleSanskrit)&&(identical(other.titleEnglish, titleEnglish) || other.titleEnglish == titleEnglish)&&(identical(other.type, type) || other.type == type)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.verses, verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,slug,titleSanskrit,titleEnglish,type,deityKey,isPremium,createdAt,category,const DeepCollectionEquality().hash(verses));

@override
String toString() {
  return 'StotraDetail(id: $id, categoryId: $categoryId, slug: $slug, titleSanskrit: $titleSanskrit, titleEnglish: $titleEnglish, type: $type, deityKey: $deityKey, isPremium: $isPremium, createdAt: $createdAt, category: $category, verses: $verses)';
}


}

/// @nodoc
abstract mixin class $StotraDetailCopyWith<$Res>  {
  factory $StotraDetailCopyWith(StotraDetail value, $Res Function(StotraDetail) _then) = _$StotraDetailCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String slug, String titleSanskrit, String titleEnglish, String type, String? deityKey, bool isPremium, DateTime? createdAt, StotraCategoryRef? category, List<StotraVerse> verses
});


$StotraCategoryRefCopyWith<$Res>? get category;

}
/// @nodoc
class _$StotraDetailCopyWithImpl<$Res>
    implements $StotraDetailCopyWith<$Res> {
  _$StotraDetailCopyWithImpl(this._self, this._then);

  final StotraDetail _self;
  final $Res Function(StotraDetail) _then;

/// Create a copy of StotraDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? slug = null,Object? titleSanskrit = null,Object? titleEnglish = null,Object? type = null,Object? deityKey = freezed,Object? isPremium = null,Object? createdAt = freezed,Object? category = freezed,Object? verses = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,titleSanskrit: null == titleSanskrit ? _self.titleSanskrit : titleSanskrit // ignore: cast_nullable_to_non_nullable
as String,titleEnglish: null == titleEnglish ? _self.titleEnglish : titleEnglish // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as StotraCategoryRef?,verses: null == verses ? _self.verses : verses // ignore: cast_nullable_to_non_nullable
as List<StotraVerse>,
  ));
}
/// Create a copy of StotraDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StotraCategoryRefCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $StotraCategoryRefCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [StotraDetail].
extension StotraDetailPatterns on StotraDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StotraDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StotraDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StotraDetail value)  $default,){
final _that = this;
switch (_that) {
case _StotraDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StotraDetail value)?  $default,){
final _that = this;
switch (_that) {
case _StotraDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String slug,  String titleSanskrit,  String titleEnglish,  String type,  String? deityKey,  bool isPremium,  DateTime? createdAt,  StotraCategoryRef? category,  List<StotraVerse> verses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StotraDetail() when $default != null:
return $default(_that.id,_that.categoryId,_that.slug,_that.titleSanskrit,_that.titleEnglish,_that.type,_that.deityKey,_that.isPremium,_that.createdAt,_that.category,_that.verses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String slug,  String titleSanskrit,  String titleEnglish,  String type,  String? deityKey,  bool isPremium,  DateTime? createdAt,  StotraCategoryRef? category,  List<StotraVerse> verses)  $default,) {final _that = this;
switch (_that) {
case _StotraDetail():
return $default(_that.id,_that.categoryId,_that.slug,_that.titleSanskrit,_that.titleEnglish,_that.type,_that.deityKey,_that.isPremium,_that.createdAt,_that.category,_that.verses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String slug,  String titleSanskrit,  String titleEnglish,  String type,  String? deityKey,  bool isPremium,  DateTime? createdAt,  StotraCategoryRef? category,  List<StotraVerse> verses)?  $default,) {final _that = this;
switch (_that) {
case _StotraDetail() when $default != null:
return $default(_that.id,_that.categoryId,_that.slug,_that.titleSanskrit,_that.titleEnglish,_that.type,_that.deityKey,_that.isPremium,_that.createdAt,_that.category,_that.verses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StotraDetail implements StotraDetail {
  const _StotraDetail({required this.id, required this.categoryId, required this.slug, required this.titleSanskrit, required this.titleEnglish, required this.type, this.deityKey, this.isPremium = false, this.createdAt, this.category, final  List<StotraVerse> verses = const <StotraVerse>[]}): _verses = verses;
  factory _StotraDetail.fromJson(Map<String, dynamic> json) => _$StotraDetailFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String slug;
@override final  String titleSanskrit;
@override final  String titleEnglish;
@override final  String type;
@override final  String? deityKey;
@override@JsonKey() final  bool isPremium;
@override final  DateTime? createdAt;
@override final  StotraCategoryRef? category;
 final  List<StotraVerse> _verses;
@override@JsonKey() List<StotraVerse> get verses {
  if (_verses is EqualUnmodifiableListView) return _verses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_verses);
}


/// Create a copy of StotraDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StotraDetailCopyWith<_StotraDetail> get copyWith => __$StotraDetailCopyWithImpl<_StotraDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StotraDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StotraDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.titleSanskrit, titleSanskrit) || other.titleSanskrit == titleSanskrit)&&(identical(other.titleEnglish, titleEnglish) || other.titleEnglish == titleEnglish)&&(identical(other.type, type) || other.type == type)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._verses, _verses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,slug,titleSanskrit,titleEnglish,type,deityKey,isPremium,createdAt,category,const DeepCollectionEquality().hash(_verses));

@override
String toString() {
  return 'StotraDetail(id: $id, categoryId: $categoryId, slug: $slug, titleSanskrit: $titleSanskrit, titleEnglish: $titleEnglish, type: $type, deityKey: $deityKey, isPremium: $isPremium, createdAt: $createdAt, category: $category, verses: $verses)';
}


}

/// @nodoc
abstract mixin class _$StotraDetailCopyWith<$Res> implements $StotraDetailCopyWith<$Res> {
  factory _$StotraDetailCopyWith(_StotraDetail value, $Res Function(_StotraDetail) _then) = __$StotraDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String slug, String titleSanskrit, String titleEnglish, String type, String? deityKey, bool isPremium, DateTime? createdAt, StotraCategoryRef? category, List<StotraVerse> verses
});


@override $StotraCategoryRefCopyWith<$Res>? get category;

}
/// @nodoc
class __$StotraDetailCopyWithImpl<$Res>
    implements _$StotraDetailCopyWith<$Res> {
  __$StotraDetailCopyWithImpl(this._self, this._then);

  final _StotraDetail _self;
  final $Res Function(_StotraDetail) _then;

/// Create a copy of StotraDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? slug = null,Object? titleSanskrit = null,Object? titleEnglish = null,Object? type = null,Object? deityKey = freezed,Object? isPremium = null,Object? createdAt = freezed,Object? category = freezed,Object? verses = null,}) {
  return _then(_StotraDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,titleSanskrit: null == titleSanskrit ? _self.titleSanskrit : titleSanskrit // ignore: cast_nullable_to_non_nullable
as String,titleEnglish: null == titleEnglish ? _self.titleEnglish : titleEnglish // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as StotraCategoryRef?,verses: null == verses ? _self._verses : verses // ignore: cast_nullable_to_non_nullable
as List<StotraVerse>,
  ));
}

/// Create a copy of StotraDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StotraCategoryRefCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $StotraCategoryRefCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
