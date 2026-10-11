// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectionItem {

/// Position in the reading order. Semantic, not cosmetic: the server
/// orders by it and the spec says the order *is* the recitation.
 int get sequence;/// One of the server's `REF_TYPES`: `surah`, `ayah_range`, `dua`,
/// `dhikr`, `allah_name`, `hadith`, `hindu_verse_range`, `stotra`,
/// `mantra`, `text`. Kept as a `String` rather than an enum so a
/// vocabulary the server adds cannot crash a client that predates it;
/// `collectionItemRoute` is the one place that switches on it, and it
/// answers `null` for anything it does not know.
 String get refType;/// How many times the item is recited — the ×3 on each of the three
/// Quls. Defaults to 1 so an item that omits it reads as "once".
 int get repeatCount;/// What the item is called, in the words the tradition uses.
 String get label;/// A curator's note: why this item, or which form of it. Long-form —
/// shown on the collection screen, never on a card.
 String? get note;/// The warrant, e.g. "Bukhari 5017" or "Bhagavad Gita 12.1–20".
 String? get citation;/// `sahih`, `hasan`, `daif`, `customary`, `not_applicable`, or absent.
/// Only `daif` is surfaced, and then only as a disclosure.
 String? get grading;/// Items a reader may skip without breaking the set.
 bool get isOptional;/// The addressing columns. Which of them are populated is a function of
/// [refType] — see `collectionItemRoute`.
 CollectionRef get ref;/// Non-null when the server could not resolve the reference to real
/// content. Such an item is listed (so the count still matches) but
/// never offered as a destination.
 CollectionUnresolved? get unresolved;
/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionItemCopyWith<CollectionItem> get copyWith => _$CollectionItemCopyWithImpl<CollectionItem>(this as CollectionItem, _$identity);

  /// Serializes this CollectionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionItem&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.refType, refType) || other.refType == refType)&&(identical(other.repeatCount, repeatCount) || other.repeatCount == repeatCount)&&(identical(other.label, label) || other.label == label)&&(identical(other.note, note) || other.note == note)&&(identical(other.citation, citation) || other.citation == citation)&&(identical(other.grading, grading) || other.grading == grading)&&(identical(other.isOptional, isOptional) || other.isOptional == isOptional)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.unresolved, unresolved) || other.unresolved == unresolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sequence,refType,repeatCount,label,note,citation,grading,isOptional,ref,unresolved);

@override
String toString() {
  return 'CollectionItem(sequence: $sequence, refType: $refType, repeatCount: $repeatCount, label: $label, note: $note, citation: $citation, grading: $grading, isOptional: $isOptional, ref: $ref, unresolved: $unresolved)';
}


}

/// @nodoc
abstract mixin class $CollectionItemCopyWith<$Res>  {
  factory $CollectionItemCopyWith(CollectionItem value, $Res Function(CollectionItem) _then) = _$CollectionItemCopyWithImpl;
@useResult
$Res call({
 int sequence, String refType, int repeatCount, String label, String? note, String? citation, String? grading, bool isOptional, CollectionRef ref, CollectionUnresolved? unresolved
});


$CollectionRefCopyWith<$Res> get ref;$CollectionUnresolvedCopyWith<$Res>? get unresolved;

}
/// @nodoc
class _$CollectionItemCopyWithImpl<$Res>
    implements $CollectionItemCopyWith<$Res> {
  _$CollectionItemCopyWithImpl(this._self, this._then);

  final CollectionItem _self;
  final $Res Function(CollectionItem) _then;

/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sequence = null,Object? refType = null,Object? repeatCount = null,Object? label = null,Object? note = freezed,Object? citation = freezed,Object? grading = freezed,Object? isOptional = null,Object? ref = null,Object? unresolved = freezed,}) {
  return _then(_self.copyWith(
sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,refType: null == refType ? _self.refType : refType // ignore: cast_nullable_to_non_nullable
as String,repeatCount: null == repeatCount ? _self.repeatCount : repeatCount // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,citation: freezed == citation ? _self.citation : citation // ignore: cast_nullable_to_non_nullable
as String?,grading: freezed == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String?,isOptional: null == isOptional ? _self.isOptional : isOptional // ignore: cast_nullable_to_non_nullable
as bool,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as CollectionRef,unresolved: freezed == unresolved ? _self.unresolved : unresolved // ignore: cast_nullable_to_non_nullable
as CollectionUnresolved?,
  ));
}
/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollectionRefCopyWith<$Res> get ref {
  
  return $CollectionRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollectionUnresolvedCopyWith<$Res>? get unresolved {
    if (_self.unresolved == null) {
    return null;
  }

  return $CollectionUnresolvedCopyWith<$Res>(_self.unresolved!, (value) {
    return _then(_self.copyWith(unresolved: value));
  });
}
}


/// Adds pattern-matching-related methods to [CollectionItem].
extension CollectionItemPatterns on CollectionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionItem value)  $default,){
final _that = this;
switch (_that) {
case _CollectionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionItem value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sequence,  String refType,  int repeatCount,  String label,  String? note,  String? citation,  String? grading,  bool isOptional,  CollectionRef ref,  CollectionUnresolved? unresolved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
return $default(_that.sequence,_that.refType,_that.repeatCount,_that.label,_that.note,_that.citation,_that.grading,_that.isOptional,_that.ref,_that.unresolved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sequence,  String refType,  int repeatCount,  String label,  String? note,  String? citation,  String? grading,  bool isOptional,  CollectionRef ref,  CollectionUnresolved? unresolved)  $default,) {final _that = this;
switch (_that) {
case _CollectionItem():
return $default(_that.sequence,_that.refType,_that.repeatCount,_that.label,_that.note,_that.citation,_that.grading,_that.isOptional,_that.ref,_that.unresolved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sequence,  String refType,  int repeatCount,  String label,  String? note,  String? citation,  String? grading,  bool isOptional,  CollectionRef ref,  CollectionUnresolved? unresolved)?  $default,) {final _that = this;
switch (_that) {
case _CollectionItem() when $default != null:
return $default(_that.sequence,_that.refType,_that.repeatCount,_that.label,_that.note,_that.citation,_that.grading,_that.isOptional,_that.ref,_that.unresolved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionItem implements CollectionItem {
  const _CollectionItem({required this.sequence, required this.refType, this.repeatCount = 1, required this.label, this.note, this.citation, this.grading, this.isOptional = false, this.ref = const CollectionRef(), this.unresolved});
  factory _CollectionItem.fromJson(Map<String, dynamic> json) => _$CollectionItemFromJson(json);

/// Position in the reading order. Semantic, not cosmetic: the server
/// orders by it and the spec says the order *is* the recitation.
@override final  int sequence;
/// One of the server's `REF_TYPES`: `surah`, `ayah_range`, `dua`,
/// `dhikr`, `allah_name`, `hadith`, `hindu_verse_range`, `stotra`,
/// `mantra`, `text`. Kept as a `String` rather than an enum so a
/// vocabulary the server adds cannot crash a client that predates it;
/// `collectionItemRoute` is the one place that switches on it, and it
/// answers `null` for anything it does not know.
@override final  String refType;
/// How many times the item is recited — the ×3 on each of the three
/// Quls. Defaults to 1 so an item that omits it reads as "once".
@override@JsonKey() final  int repeatCount;
/// What the item is called, in the words the tradition uses.
@override final  String label;
/// A curator's note: why this item, or which form of it. Long-form —
/// shown on the collection screen, never on a card.
@override final  String? note;
/// The warrant, e.g. "Bukhari 5017" or "Bhagavad Gita 12.1–20".
@override final  String? citation;
/// `sahih`, `hasan`, `daif`, `customary`, `not_applicable`, or absent.
/// Only `daif` is surfaced, and then only as a disclosure.
@override final  String? grading;
/// Items a reader may skip without breaking the set.
@override@JsonKey() final  bool isOptional;
/// The addressing columns. Which of them are populated is a function of
/// [refType] — see `collectionItemRoute`.
@override@JsonKey() final  CollectionRef ref;
/// Non-null when the server could not resolve the reference to real
/// content. Such an item is listed (so the count still matches) but
/// never offered as a destination.
@override final  CollectionUnresolved? unresolved;

/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionItemCopyWith<_CollectionItem> get copyWith => __$CollectionItemCopyWithImpl<_CollectionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionItem&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.refType, refType) || other.refType == refType)&&(identical(other.repeatCount, repeatCount) || other.repeatCount == repeatCount)&&(identical(other.label, label) || other.label == label)&&(identical(other.note, note) || other.note == note)&&(identical(other.citation, citation) || other.citation == citation)&&(identical(other.grading, grading) || other.grading == grading)&&(identical(other.isOptional, isOptional) || other.isOptional == isOptional)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.unresolved, unresolved) || other.unresolved == unresolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sequence,refType,repeatCount,label,note,citation,grading,isOptional,ref,unresolved);

@override
String toString() {
  return 'CollectionItem(sequence: $sequence, refType: $refType, repeatCount: $repeatCount, label: $label, note: $note, citation: $citation, grading: $grading, isOptional: $isOptional, ref: $ref, unresolved: $unresolved)';
}


}

/// @nodoc
abstract mixin class _$CollectionItemCopyWith<$Res> implements $CollectionItemCopyWith<$Res> {
  factory _$CollectionItemCopyWith(_CollectionItem value, $Res Function(_CollectionItem) _then) = __$CollectionItemCopyWithImpl;
@override @useResult
$Res call({
 int sequence, String refType, int repeatCount, String label, String? note, String? citation, String? grading, bool isOptional, CollectionRef ref, CollectionUnresolved? unresolved
});


@override $CollectionRefCopyWith<$Res> get ref;@override $CollectionUnresolvedCopyWith<$Res>? get unresolved;

}
/// @nodoc
class __$CollectionItemCopyWithImpl<$Res>
    implements _$CollectionItemCopyWith<$Res> {
  __$CollectionItemCopyWithImpl(this._self, this._then);

  final _CollectionItem _self;
  final $Res Function(_CollectionItem) _then;

/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sequence = null,Object? refType = null,Object? repeatCount = null,Object? label = null,Object? note = freezed,Object? citation = freezed,Object? grading = freezed,Object? isOptional = null,Object? ref = null,Object? unresolved = freezed,}) {
  return _then(_CollectionItem(
sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,refType: null == refType ? _self.refType : refType // ignore: cast_nullable_to_non_nullable
as String,repeatCount: null == repeatCount ? _self.repeatCount : repeatCount // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,citation: freezed == citation ? _self.citation : citation // ignore: cast_nullable_to_non_nullable
as String?,grading: freezed == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String?,isOptional: null == isOptional ? _self.isOptional : isOptional // ignore: cast_nullable_to_non_nullable
as bool,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as CollectionRef,unresolved: freezed == unresolved ? _self.unresolved : unresolved // ignore: cast_nullable_to_non_nullable
as CollectionUnresolved?,
  ));
}

/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollectionRefCopyWith<$Res> get ref {
  
  return $CollectionRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of CollectionItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollectionUnresolvedCopyWith<$Res>? get unresolved {
    if (_self.unresolved == null) {
    return null;
  }

  return $CollectionUnresolvedCopyWith<$Res>(_self.unresolved!, (value) {
    return _then(_self.copyWith(unresolved: value));
  });
}
}


/// @nodoc
mixin _$CollectionRef {

 int? get surahId; int? get ayahStart; int? get ayahEnd; String? get hinduTextSlug; int? get chapterNumber; int? get verseStart; int? get verseEnd; String? get refSlug; String? get refId;
/// Create a copy of CollectionRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionRefCopyWith<CollectionRef> get copyWith => _$CollectionRefCopyWithImpl<CollectionRef>(this as CollectionRef, _$identity);

  /// Serializes this CollectionRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionRef&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.ayahStart, ayahStart) || other.ayahStart == ayahStart)&&(identical(other.ayahEnd, ayahEnd) || other.ayahEnd == ayahEnd)&&(identical(other.hinduTextSlug, hinduTextSlug) || other.hinduTextSlug == hinduTextSlug)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.verseStart, verseStart) || other.verseStart == verseStart)&&(identical(other.verseEnd, verseEnd) || other.verseEnd == verseEnd)&&(identical(other.refSlug, refSlug) || other.refSlug == refSlug)&&(identical(other.refId, refId) || other.refId == refId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surahId,ayahStart,ayahEnd,hinduTextSlug,chapterNumber,verseStart,verseEnd,refSlug,refId);

@override
String toString() {
  return 'CollectionRef(surahId: $surahId, ayahStart: $ayahStart, ayahEnd: $ayahEnd, hinduTextSlug: $hinduTextSlug, chapterNumber: $chapterNumber, verseStart: $verseStart, verseEnd: $verseEnd, refSlug: $refSlug, refId: $refId)';
}


}

/// @nodoc
abstract mixin class $CollectionRefCopyWith<$Res>  {
  factory $CollectionRefCopyWith(CollectionRef value, $Res Function(CollectionRef) _then) = _$CollectionRefCopyWithImpl;
@useResult
$Res call({
 int? surahId, int? ayahStart, int? ayahEnd, String? hinduTextSlug, int? chapterNumber, int? verseStart, int? verseEnd, String? refSlug, String? refId
});




}
/// @nodoc
class _$CollectionRefCopyWithImpl<$Res>
    implements $CollectionRefCopyWith<$Res> {
  _$CollectionRefCopyWithImpl(this._self, this._then);

  final CollectionRef _self;
  final $Res Function(CollectionRef) _then;

/// Create a copy of CollectionRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surahId = freezed,Object? ayahStart = freezed,Object? ayahEnd = freezed,Object? hinduTextSlug = freezed,Object? chapterNumber = freezed,Object? verseStart = freezed,Object? verseEnd = freezed,Object? refSlug = freezed,Object? refId = freezed,}) {
  return _then(_self.copyWith(
surahId: freezed == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int?,ayahStart: freezed == ayahStart ? _self.ayahStart : ayahStart // ignore: cast_nullable_to_non_nullable
as int?,ayahEnd: freezed == ayahEnd ? _self.ayahEnd : ayahEnd // ignore: cast_nullable_to_non_nullable
as int?,hinduTextSlug: freezed == hinduTextSlug ? _self.hinduTextSlug : hinduTextSlug // ignore: cast_nullable_to_non_nullable
as String?,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,verseStart: freezed == verseStart ? _self.verseStart : verseStart // ignore: cast_nullable_to_non_nullable
as int?,verseEnd: freezed == verseEnd ? _self.verseEnd : verseEnd // ignore: cast_nullable_to_non_nullable
as int?,refSlug: freezed == refSlug ? _self.refSlug : refSlug // ignore: cast_nullable_to_non_nullable
as String?,refId: freezed == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionRef].
extension CollectionRefPatterns on CollectionRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionRef value)  $default,){
final _that = this;
switch (_that) {
case _CollectionRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionRef value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? surahId,  int? ayahStart,  int? ayahEnd,  String? hinduTextSlug,  int? chapterNumber,  int? verseStart,  int? verseEnd,  String? refSlug,  String? refId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionRef() when $default != null:
return $default(_that.surahId,_that.ayahStart,_that.ayahEnd,_that.hinduTextSlug,_that.chapterNumber,_that.verseStart,_that.verseEnd,_that.refSlug,_that.refId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? surahId,  int? ayahStart,  int? ayahEnd,  String? hinduTextSlug,  int? chapterNumber,  int? verseStart,  int? verseEnd,  String? refSlug,  String? refId)  $default,) {final _that = this;
switch (_that) {
case _CollectionRef():
return $default(_that.surahId,_that.ayahStart,_that.ayahEnd,_that.hinduTextSlug,_that.chapterNumber,_that.verseStart,_that.verseEnd,_that.refSlug,_that.refId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? surahId,  int? ayahStart,  int? ayahEnd,  String? hinduTextSlug,  int? chapterNumber,  int? verseStart,  int? verseEnd,  String? refSlug,  String? refId)?  $default,) {final _that = this;
switch (_that) {
case _CollectionRef() when $default != null:
return $default(_that.surahId,_that.ayahStart,_that.ayahEnd,_that.hinduTextSlug,_that.chapterNumber,_that.verseStart,_that.verseEnd,_that.refSlug,_that.refId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionRef implements CollectionRef {
  const _CollectionRef({this.surahId, this.ayahStart, this.ayahEnd, this.hinduTextSlug, this.chapterNumber, this.verseStart, this.verseEnd, this.refSlug, this.refId});
  factory _CollectionRef.fromJson(Map<String, dynamic> json) => _$CollectionRefFromJson(json);

@override final  int? surahId;
@override final  int? ayahStart;
@override final  int? ayahEnd;
@override final  String? hinduTextSlug;
@override final  int? chapterNumber;
@override final  int? verseStart;
@override final  int? verseEnd;
@override final  String? refSlug;
@override final  String? refId;

/// Create a copy of CollectionRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionRefCopyWith<_CollectionRef> get copyWith => __$CollectionRefCopyWithImpl<_CollectionRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionRef&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.ayahStart, ayahStart) || other.ayahStart == ayahStart)&&(identical(other.ayahEnd, ayahEnd) || other.ayahEnd == ayahEnd)&&(identical(other.hinduTextSlug, hinduTextSlug) || other.hinduTextSlug == hinduTextSlug)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.verseStart, verseStart) || other.verseStart == verseStart)&&(identical(other.verseEnd, verseEnd) || other.verseEnd == verseEnd)&&(identical(other.refSlug, refSlug) || other.refSlug == refSlug)&&(identical(other.refId, refId) || other.refId == refId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surahId,ayahStart,ayahEnd,hinduTextSlug,chapterNumber,verseStart,verseEnd,refSlug,refId);

@override
String toString() {
  return 'CollectionRef(surahId: $surahId, ayahStart: $ayahStart, ayahEnd: $ayahEnd, hinduTextSlug: $hinduTextSlug, chapterNumber: $chapterNumber, verseStart: $verseStart, verseEnd: $verseEnd, refSlug: $refSlug, refId: $refId)';
}


}

/// @nodoc
abstract mixin class _$CollectionRefCopyWith<$Res> implements $CollectionRefCopyWith<$Res> {
  factory _$CollectionRefCopyWith(_CollectionRef value, $Res Function(_CollectionRef) _then) = __$CollectionRefCopyWithImpl;
@override @useResult
$Res call({
 int? surahId, int? ayahStart, int? ayahEnd, String? hinduTextSlug, int? chapterNumber, int? verseStart, int? verseEnd, String? refSlug, String? refId
});




}
/// @nodoc
class __$CollectionRefCopyWithImpl<$Res>
    implements _$CollectionRefCopyWith<$Res> {
  __$CollectionRefCopyWithImpl(this._self, this._then);

  final _CollectionRef _self;
  final $Res Function(_CollectionRef) _then;

/// Create a copy of CollectionRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surahId = freezed,Object? ayahStart = freezed,Object? ayahEnd = freezed,Object? hinduTextSlug = freezed,Object? chapterNumber = freezed,Object? verseStart = freezed,Object? verseEnd = freezed,Object? refSlug = freezed,Object? refId = freezed,}) {
  return _then(_CollectionRef(
surahId: freezed == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int?,ayahStart: freezed == ayahStart ? _self.ayahStart : ayahStart // ignore: cast_nullable_to_non_nullable
as int?,ayahEnd: freezed == ayahEnd ? _self.ayahEnd : ayahEnd // ignore: cast_nullable_to_non_nullable
as int?,hinduTextSlug: freezed == hinduTextSlug ? _self.hinduTextSlug : hinduTextSlug // ignore: cast_nullable_to_non_nullable
as String?,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,verseStart: freezed == verseStart ? _self.verseStart : verseStart // ignore: cast_nullable_to_non_nullable
as int?,verseEnd: freezed == verseEnd ? _self.verseEnd : verseEnd // ignore: cast_nullable_to_non_nullable
as int?,refSlug: freezed == refSlug ? _self.refSlug : refSlug // ignore: cast_nullable_to_non_nullable
as String?,refId: freezed == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CollectionUnresolved {

 String get reason;
/// Create a copy of CollectionUnresolved
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionUnresolvedCopyWith<CollectionUnresolved> get copyWith => _$CollectionUnresolvedCopyWithImpl<CollectionUnresolved>(this as CollectionUnresolved, _$identity);

  /// Serializes this CollectionUnresolved to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionUnresolved&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CollectionUnresolved(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CollectionUnresolvedCopyWith<$Res>  {
  factory $CollectionUnresolvedCopyWith(CollectionUnresolved value, $Res Function(CollectionUnresolved) _then) = _$CollectionUnresolvedCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$CollectionUnresolvedCopyWithImpl<$Res>
    implements $CollectionUnresolvedCopyWith<$Res> {
  _$CollectionUnresolvedCopyWithImpl(this._self, this._then);

  final CollectionUnresolved _self;
  final $Res Function(CollectionUnresolved) _then;

/// Create a copy of CollectionUnresolved
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = null,}) {
  return _then(_self.copyWith(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionUnresolved].
extension CollectionUnresolvedPatterns on CollectionUnresolved {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionUnresolved value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionUnresolved() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionUnresolved value)  $default,){
final _that = this;
switch (_that) {
case _CollectionUnresolved():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionUnresolved value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionUnresolved() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionUnresolved() when $default != null:
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reason)  $default,) {final _that = this;
switch (_that) {
case _CollectionUnresolved():
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reason)?  $default,) {final _that = this;
switch (_that) {
case _CollectionUnresolved() when $default != null:
return $default(_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionUnresolved implements CollectionUnresolved {
  const _CollectionUnresolved({required this.reason});
  factory _CollectionUnresolved.fromJson(Map<String, dynamic> json) => _$CollectionUnresolvedFromJson(json);

@override final  String reason;

/// Create a copy of CollectionUnresolved
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionUnresolvedCopyWith<_CollectionUnresolved> get copyWith => __$CollectionUnresolvedCopyWithImpl<_CollectionUnresolved>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionUnresolvedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionUnresolved&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CollectionUnresolved(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CollectionUnresolvedCopyWith<$Res> implements $CollectionUnresolvedCopyWith<$Res> {
  factory _$CollectionUnresolvedCopyWith(_CollectionUnresolved value, $Res Function(_CollectionUnresolved) _then) = __$CollectionUnresolvedCopyWithImpl;
@override @useResult
$Res call({
 String reason
});




}
/// @nodoc
class __$CollectionUnresolvedCopyWithImpl<$Res>
    implements _$CollectionUnresolvedCopyWith<$Res> {
  __$CollectionUnresolvedCopyWithImpl(this._self, this._then);

  final _CollectionUnresolved _self;
  final $Res Function(_CollectionUnresolved) _then;

/// Create a copy of CollectionUnresolved
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(_CollectionUnresolved(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
