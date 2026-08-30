// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'japa_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JapaHistoryEntry {

 String get id; String? get userId; String get mantra; int get count; DateTime get date; DateTime? get createdAt;
/// Create a copy of JapaHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JapaHistoryEntryCopyWith<JapaHistoryEntry> get copyWith => _$JapaHistoryEntryCopyWithImpl<JapaHistoryEntry>(this as JapaHistoryEntry, _$identity);

  /// Serializes this JapaHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JapaHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mantra, mantra) || other.mantra == mantra)&&(identical(other.count, count) || other.count == count)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mantra,count,date,createdAt);

@override
String toString() {
  return 'JapaHistoryEntry(id: $id, userId: $userId, mantra: $mantra, count: $count, date: $date, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $JapaHistoryEntryCopyWith<$Res>  {
  factory $JapaHistoryEntryCopyWith(JapaHistoryEntry value, $Res Function(JapaHistoryEntry) _then) = _$JapaHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String mantra, int count, DateTime date, DateTime? createdAt
});




}
/// @nodoc
class _$JapaHistoryEntryCopyWithImpl<$Res>
    implements $JapaHistoryEntryCopyWith<$Res> {
  _$JapaHistoryEntryCopyWithImpl(this._self, this._then);

  final JapaHistoryEntry _self;
  final $Res Function(JapaHistoryEntry) _then;

/// Create a copy of JapaHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? mantra = null,Object? count = null,Object? date = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,mantra: null == mantra ? _self.mantra : mantra // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JapaHistoryEntry].
extension JapaHistoryEntryPatterns on JapaHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JapaHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JapaHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JapaHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _JapaHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JapaHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _JapaHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String mantra,  int count,  DateTime date,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JapaHistoryEntry() when $default != null:
return $default(_that.id,_that.userId,_that.mantra,_that.count,_that.date,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String mantra,  int count,  DateTime date,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _JapaHistoryEntry():
return $default(_that.id,_that.userId,_that.mantra,_that.count,_that.date,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String mantra,  int count,  DateTime date,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _JapaHistoryEntry() when $default != null:
return $default(_that.id,_that.userId,_that.mantra,_that.count,_that.date,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JapaHistoryEntry implements JapaHistoryEntry {
  const _JapaHistoryEntry({required this.id, this.userId, required this.mantra, this.count = 0, required this.date, this.createdAt});
  factory _JapaHistoryEntry.fromJson(Map<String, dynamic> json) => _$JapaHistoryEntryFromJson(json);

@override final  String id;
@override final  String? userId;
@override final  String mantra;
@override@JsonKey() final  int count;
@override final  DateTime date;
@override final  DateTime? createdAt;

/// Create a copy of JapaHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JapaHistoryEntryCopyWith<_JapaHistoryEntry> get copyWith => __$JapaHistoryEntryCopyWithImpl<_JapaHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JapaHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JapaHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mantra, mantra) || other.mantra == mantra)&&(identical(other.count, count) || other.count == count)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mantra,count,date,createdAt);

@override
String toString() {
  return 'JapaHistoryEntry(id: $id, userId: $userId, mantra: $mantra, count: $count, date: $date, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$JapaHistoryEntryCopyWith<$Res> implements $JapaHistoryEntryCopyWith<$Res> {
  factory _$JapaHistoryEntryCopyWith(_JapaHistoryEntry value, $Res Function(_JapaHistoryEntry) _then) = __$JapaHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String mantra, int count, DateTime date, DateTime? createdAt
});




}
/// @nodoc
class __$JapaHistoryEntryCopyWithImpl<$Res>
    implements _$JapaHistoryEntryCopyWith<$Res> {
  __$JapaHistoryEntryCopyWithImpl(this._self, this._then);

  final _JapaHistoryEntry _self;
  final $Res Function(_JapaHistoryEntry) _then;

/// Create a copy of JapaHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? mantra = null,Object? count = null,Object? date = null,Object? createdAt = freezed,}) {
  return _then(_JapaHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,mantra: null == mantra ? _self.mantra : mantra // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
