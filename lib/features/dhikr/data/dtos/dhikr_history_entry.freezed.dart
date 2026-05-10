// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dhikr_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DhikrHistoryEntry {

 String get id; String? get counterId; String? get phraseArabic; String? get phraseEnglish; int get count; DateTime? get recordedAt;
/// Create a copy of DhikrHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DhikrHistoryEntryCopyWith<DhikrHistoryEntry> get copyWith => _$DhikrHistoryEntryCopyWithImpl<DhikrHistoryEntry>(this as DhikrHistoryEntry, _$identity);

  /// Serializes this DhikrHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DhikrHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.counterId, counterId) || other.counterId == counterId)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseEnglish, phraseEnglish) || other.phraseEnglish == phraseEnglish)&&(identical(other.count, count) || other.count == count)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,counterId,phraseArabic,phraseEnglish,count,recordedAt);

@override
String toString() {
  return 'DhikrHistoryEntry(id: $id, counterId: $counterId, phraseArabic: $phraseArabic, phraseEnglish: $phraseEnglish, count: $count, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $DhikrHistoryEntryCopyWith<$Res>  {
  factory $DhikrHistoryEntryCopyWith(DhikrHistoryEntry value, $Res Function(DhikrHistoryEntry) _then) = _$DhikrHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, String? counterId, String? phraseArabic, String? phraseEnglish, int count, DateTime? recordedAt
});




}
/// @nodoc
class _$DhikrHistoryEntryCopyWithImpl<$Res>
    implements $DhikrHistoryEntryCopyWith<$Res> {
  _$DhikrHistoryEntryCopyWithImpl(this._self, this._then);

  final DhikrHistoryEntry _self;
  final $Res Function(DhikrHistoryEntry) _then;

/// Create a copy of DhikrHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? counterId = freezed,Object? phraseArabic = freezed,Object? phraseEnglish = freezed,Object? count = null,Object? recordedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,counterId: freezed == counterId ? _self.counterId : counterId // ignore: cast_nullable_to_non_nullable
as String?,phraseArabic: freezed == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String?,phraseEnglish: freezed == phraseEnglish ? _self.phraseEnglish : phraseEnglish // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,recordedAt: freezed == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DhikrHistoryEntry].
extension DhikrHistoryEntryPatterns on DhikrHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DhikrHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DhikrHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DhikrHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _DhikrHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DhikrHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DhikrHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? counterId,  String? phraseArabic,  String? phraseEnglish,  int count,  DateTime? recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DhikrHistoryEntry() when $default != null:
return $default(_that.id,_that.counterId,_that.phraseArabic,_that.phraseEnglish,_that.count,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? counterId,  String? phraseArabic,  String? phraseEnglish,  int count,  DateTime? recordedAt)  $default,) {final _that = this;
switch (_that) {
case _DhikrHistoryEntry():
return $default(_that.id,_that.counterId,_that.phraseArabic,_that.phraseEnglish,_that.count,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? counterId,  String? phraseArabic,  String? phraseEnglish,  int count,  DateTime? recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _DhikrHistoryEntry() when $default != null:
return $default(_that.id,_that.counterId,_that.phraseArabic,_that.phraseEnglish,_that.count,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DhikrHistoryEntry implements DhikrHistoryEntry {
  const _DhikrHistoryEntry({required this.id, this.counterId, this.phraseArabic, this.phraseEnglish, this.count = 0, this.recordedAt});
  factory _DhikrHistoryEntry.fromJson(Map<String, dynamic> json) => _$DhikrHistoryEntryFromJson(json);

@override final  String id;
@override final  String? counterId;
@override final  String? phraseArabic;
@override final  String? phraseEnglish;
@override@JsonKey() final  int count;
@override final  DateTime? recordedAt;

/// Create a copy of DhikrHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DhikrHistoryEntryCopyWith<_DhikrHistoryEntry> get copyWith => __$DhikrHistoryEntryCopyWithImpl<_DhikrHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DhikrHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DhikrHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.counterId, counterId) || other.counterId == counterId)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseEnglish, phraseEnglish) || other.phraseEnglish == phraseEnglish)&&(identical(other.count, count) || other.count == count)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,counterId,phraseArabic,phraseEnglish,count,recordedAt);

@override
String toString() {
  return 'DhikrHistoryEntry(id: $id, counterId: $counterId, phraseArabic: $phraseArabic, phraseEnglish: $phraseEnglish, count: $count, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$DhikrHistoryEntryCopyWith<$Res> implements $DhikrHistoryEntryCopyWith<$Res> {
  factory _$DhikrHistoryEntryCopyWith(_DhikrHistoryEntry value, $Res Function(_DhikrHistoryEntry) _then) = __$DhikrHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String? counterId, String? phraseArabic, String? phraseEnglish, int count, DateTime? recordedAt
});




}
/// @nodoc
class __$DhikrHistoryEntryCopyWithImpl<$Res>
    implements _$DhikrHistoryEntryCopyWith<$Res> {
  __$DhikrHistoryEntryCopyWithImpl(this._self, this._then);

  final _DhikrHistoryEntry _self;
  final $Res Function(_DhikrHistoryEntry) _then;

/// Create a copy of DhikrHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? counterId = freezed,Object? phraseArabic = freezed,Object? phraseEnglish = freezed,Object? count = null,Object? recordedAt = freezed,}) {
  return _then(_DhikrHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,counterId: freezed == counterId ? _self.counterId : counterId // ignore: cast_nullable_to_non_nullable
as String?,phraseArabic: freezed == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String?,phraseEnglish: freezed == phraseEnglish ? _self.phraseEnglish : phraseEnglish // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,recordedAt: freezed == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
