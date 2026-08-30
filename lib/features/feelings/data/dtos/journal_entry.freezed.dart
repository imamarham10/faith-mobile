// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalRemedySnapshot {

 String get primaryText; JournalRemedyScript? get script; String? get transliteration; String? get translation; String? get reference; String? get note; String? get deepLink;
/// Create a copy of JournalRemedySnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalRemedySnapshotCopyWith<JournalRemedySnapshot> get copyWith => _$JournalRemedySnapshotCopyWithImpl<JournalRemedySnapshot>(this as JournalRemedySnapshot, _$identity);

  /// Serializes this JournalRemedySnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalRemedySnapshot&&(identical(other.primaryText, primaryText) || other.primaryText == primaryText)&&(identical(other.script, script) || other.script == script)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.note, note) || other.note == note)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,primaryText,script,transliteration,translation,reference,note,deepLink);

@override
String toString() {
  return 'JournalRemedySnapshot(primaryText: $primaryText, script: $script, transliteration: $transliteration, translation: $translation, reference: $reference, note: $note, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $JournalRemedySnapshotCopyWith<$Res>  {
  factory $JournalRemedySnapshotCopyWith(JournalRemedySnapshot value, $Res Function(JournalRemedySnapshot) _then) = _$JournalRemedySnapshotCopyWithImpl;
@useResult
$Res call({
 String primaryText, JournalRemedyScript? script, String? transliteration, String? translation, String? reference, String? note, String? deepLink
});




}
/// @nodoc
class _$JournalRemedySnapshotCopyWithImpl<$Res>
    implements $JournalRemedySnapshotCopyWith<$Res> {
  _$JournalRemedySnapshotCopyWithImpl(this._self, this._then);

  final JournalRemedySnapshot _self;
  final $Res Function(JournalRemedySnapshot) _then;

/// Create a copy of JournalRemedySnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primaryText = null,Object? script = freezed,Object? transliteration = freezed,Object? translation = freezed,Object? reference = freezed,Object? note = freezed,Object? deepLink = freezed,}) {
  return _then(_self.copyWith(
primaryText: null == primaryText ? _self.primaryText : primaryText // ignore: cast_nullable_to_non_nullable
as String,script: freezed == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as JournalRemedyScript?,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalRemedySnapshot].
extension JournalRemedySnapshotPatterns on JournalRemedySnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalRemedySnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalRemedySnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalRemedySnapshot value)  $default,){
final _that = this;
switch (_that) {
case _JournalRemedySnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalRemedySnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _JournalRemedySnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String primaryText,  JournalRemedyScript? script,  String? transliteration,  String? translation,  String? reference,  String? note,  String? deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalRemedySnapshot() when $default != null:
return $default(_that.primaryText,_that.script,_that.transliteration,_that.translation,_that.reference,_that.note,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String primaryText,  JournalRemedyScript? script,  String? transliteration,  String? translation,  String? reference,  String? note,  String? deepLink)  $default,) {final _that = this;
switch (_that) {
case _JournalRemedySnapshot():
return $default(_that.primaryText,_that.script,_that.transliteration,_that.translation,_that.reference,_that.note,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String primaryText,  JournalRemedyScript? script,  String? transliteration,  String? translation,  String? reference,  String? note,  String? deepLink)?  $default,) {final _that = this;
switch (_that) {
case _JournalRemedySnapshot() when $default != null:
return $default(_that.primaryText,_that.script,_that.transliteration,_that.translation,_that.reference,_that.note,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalRemedySnapshot implements JournalRemedySnapshot {
  const _JournalRemedySnapshot({required this.primaryText, this.script, this.transliteration, this.translation, this.reference, this.note, this.deepLink});
  factory _JournalRemedySnapshot.fromJson(Map<String, dynamic> json) => _$JournalRemedySnapshotFromJson(json);

@override final  String primaryText;
@override final  JournalRemedyScript? script;
@override final  String? transliteration;
@override final  String? translation;
@override final  String? reference;
@override final  String? note;
@override final  String? deepLink;

/// Create a copy of JournalRemedySnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalRemedySnapshotCopyWith<_JournalRemedySnapshot> get copyWith => __$JournalRemedySnapshotCopyWithImpl<_JournalRemedySnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalRemedySnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalRemedySnapshot&&(identical(other.primaryText, primaryText) || other.primaryText == primaryText)&&(identical(other.script, script) || other.script == script)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.note, note) || other.note == note)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,primaryText,script,transliteration,translation,reference,note,deepLink);

@override
String toString() {
  return 'JournalRemedySnapshot(primaryText: $primaryText, script: $script, transliteration: $transliteration, translation: $translation, reference: $reference, note: $note, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$JournalRemedySnapshotCopyWith<$Res> implements $JournalRemedySnapshotCopyWith<$Res> {
  factory _$JournalRemedySnapshotCopyWith(_JournalRemedySnapshot value, $Res Function(_JournalRemedySnapshot) _then) = __$JournalRemedySnapshotCopyWithImpl;
@override @useResult
$Res call({
 String primaryText, JournalRemedyScript? script, String? transliteration, String? translation, String? reference, String? note, String? deepLink
});




}
/// @nodoc
class __$JournalRemedySnapshotCopyWithImpl<$Res>
    implements _$JournalRemedySnapshotCopyWith<$Res> {
  __$JournalRemedySnapshotCopyWithImpl(this._self, this._then);

  final _JournalRemedySnapshot _self;
  final $Res Function(_JournalRemedySnapshot) _then;

/// Create a copy of JournalRemedySnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primaryText = null,Object? script = freezed,Object? transliteration = freezed,Object? translation = freezed,Object? reference = freezed,Object? note = freezed,Object? deepLink = freezed,}) {
  return _then(_JournalRemedySnapshot(
primaryText: null == primaryText ? _self.primaryText : primaryText // ignore: cast_nullable_to_non_nullable
as String,script: freezed == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as JournalRemedyScript?,transliteration: freezed == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$JournalEntry {

 String get id; String get mood; String get note; DateTime get createdAt; List<JournalRemedySnapshot> get remedies;
/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<JournalEntry> get copyWith => _$JournalEntryCopyWithImpl<JournalEntry>(this as JournalEntry, _$identity);

  /// Serializes this JournalEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.remedies, remedies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mood,note,createdAt,const DeepCollectionEquality().hash(remedies));

@override
String toString() {
  return 'JournalEntry(id: $id, mood: $mood, note: $note, createdAt: $createdAt, remedies: $remedies)';
}


}

/// @nodoc
abstract mixin class $JournalEntryCopyWith<$Res>  {
  factory $JournalEntryCopyWith(JournalEntry value, $Res Function(JournalEntry) _then) = _$JournalEntryCopyWithImpl;
@useResult
$Res call({
 String id, String mood, String note, DateTime createdAt, List<JournalRemedySnapshot> remedies
});




}
/// @nodoc
class _$JournalEntryCopyWithImpl<$Res>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._self, this._then);

  final JournalEntry _self;
  final $Res Function(JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mood = null,Object? note = null,Object? createdAt = null,Object? remedies = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,remedies: null == remedies ? _self.remedies : remedies // ignore: cast_nullable_to_non_nullable
as List<JournalRemedySnapshot>,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntry].
extension JournalEntryPatterns on JournalEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntry value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntry value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String mood,  String note,  DateTime createdAt,  List<JournalRemedySnapshot> remedies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.mood,_that.note,_that.createdAt,_that.remedies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String mood,  String note,  DateTime createdAt,  List<JournalRemedySnapshot> remedies)  $default,) {final _that = this;
switch (_that) {
case _JournalEntry():
return $default(_that.id,_that.mood,_that.note,_that.createdAt,_that.remedies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String mood,  String note,  DateTime createdAt,  List<JournalRemedySnapshot> remedies)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.mood,_that.note,_that.createdAt,_that.remedies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntry implements JournalEntry {
  const _JournalEntry({required this.id, required this.mood, required this.note, required this.createdAt, final  List<JournalRemedySnapshot> remedies = const <JournalRemedySnapshot>[]}): _remedies = remedies;
  factory _JournalEntry.fromJson(Map<String, dynamic> json) => _$JournalEntryFromJson(json);

@override final  String id;
@override final  String mood;
@override final  String note;
@override final  DateTime createdAt;
 final  List<JournalRemedySnapshot> _remedies;
@override@JsonKey() List<JournalRemedySnapshot> get remedies {
  if (_remedies is EqualUnmodifiableListView) return _remedies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_remedies);
}


/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryCopyWith<_JournalEntry> get copyWith => __$JournalEntryCopyWithImpl<_JournalEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._remedies, _remedies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mood,note,createdAt,const DeepCollectionEquality().hash(_remedies));

@override
String toString() {
  return 'JournalEntry(id: $id, mood: $mood, note: $note, createdAt: $createdAt, remedies: $remedies)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryCopyWith<$Res> implements $JournalEntryCopyWith<$Res> {
  factory _$JournalEntryCopyWith(_JournalEntry value, $Res Function(_JournalEntry) _then) = __$JournalEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String mood, String note, DateTime createdAt, List<JournalRemedySnapshot> remedies
});




}
/// @nodoc
class __$JournalEntryCopyWithImpl<$Res>
    implements _$JournalEntryCopyWith<$Res> {
  __$JournalEntryCopyWithImpl(this._self, this._then);

  final _JournalEntry _self;
  final $Res Function(_JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mood = null,Object? note = null,Object? createdAt = null,Object? remedies = null,}) {
  return _then(_JournalEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,remedies: null == remedies ? _self._remedies : remedies // ignore: cast_nullable_to_non_nullable
as List<JournalRemedySnapshot>,
  ));
}


}

// dart format on
