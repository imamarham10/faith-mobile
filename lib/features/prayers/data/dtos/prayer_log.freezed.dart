// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrayerLog {

 String? get id; String? get userId; String get prayerName; String get date; PrayerStatus get status; DateTime? get loggedAt;
/// Create a copy of PrayerLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerLogCopyWith<PrayerLog> get copyWith => _$PrayerLogCopyWithImpl<PrayerLog>(this as PrayerLog, _$identity);

  /// Serializes this PrayerLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.prayerName, prayerName) || other.prayerName == prayerName)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,prayerName,date,status,loggedAt);

@override
String toString() {
  return 'PrayerLog(id: $id, userId: $userId, prayerName: $prayerName, date: $date, status: $status, loggedAt: $loggedAt)';
}


}

/// @nodoc
abstract mixin class $PrayerLogCopyWith<$Res>  {
  factory $PrayerLogCopyWith(PrayerLog value, $Res Function(PrayerLog) _then) = _$PrayerLogCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String prayerName, String date, PrayerStatus status, DateTime? loggedAt
});




}
/// @nodoc
class _$PrayerLogCopyWithImpl<$Res>
    implements $PrayerLogCopyWith<$Res> {
  _$PrayerLogCopyWithImpl(this._self, this._then);

  final PrayerLog _self;
  final $Res Function(PrayerLog) _then;

/// Create a copy of PrayerLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? prayerName = null,Object? date = null,Object? status = null,Object? loggedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,prayerName: null == prayerName ? _self.prayerName : prayerName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrayerStatus,loggedAt: freezed == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrayerLog].
extension PrayerLogPatterns on PrayerLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrayerLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrayerLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrayerLog value)  $default,){
final _that = this;
switch (_that) {
case _PrayerLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrayerLog value)?  $default,){
final _that = this;
switch (_that) {
case _PrayerLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String prayerName,  String date,  PrayerStatus status,  DateTime? loggedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrayerLog() when $default != null:
return $default(_that.id,_that.userId,_that.prayerName,_that.date,_that.status,_that.loggedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String prayerName,  String date,  PrayerStatus status,  DateTime? loggedAt)  $default,) {final _that = this;
switch (_that) {
case _PrayerLog():
return $default(_that.id,_that.userId,_that.prayerName,_that.date,_that.status,_that.loggedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String prayerName,  String date,  PrayerStatus status,  DateTime? loggedAt)?  $default,) {final _that = this;
switch (_that) {
case _PrayerLog() when $default != null:
return $default(_that.id,_that.userId,_that.prayerName,_that.date,_that.status,_that.loggedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrayerLog implements PrayerLog {
  const _PrayerLog({this.id, this.userId, required this.prayerName, required this.date, required this.status, this.loggedAt});
  factory _PrayerLog.fromJson(Map<String, dynamic> json) => _$PrayerLogFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String prayerName;
@override final  String date;
@override final  PrayerStatus status;
@override final  DateTime? loggedAt;

/// Create a copy of PrayerLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrayerLogCopyWith<_PrayerLog> get copyWith => __$PrayerLogCopyWithImpl<_PrayerLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrayerLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrayerLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.prayerName, prayerName) || other.prayerName == prayerName)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,prayerName,date,status,loggedAt);

@override
String toString() {
  return 'PrayerLog(id: $id, userId: $userId, prayerName: $prayerName, date: $date, status: $status, loggedAt: $loggedAt)';
}


}

/// @nodoc
abstract mixin class _$PrayerLogCopyWith<$Res> implements $PrayerLogCopyWith<$Res> {
  factory _$PrayerLogCopyWith(_PrayerLog value, $Res Function(_PrayerLog) _then) = __$PrayerLogCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String prayerName, String date, PrayerStatus status, DateTime? loggedAt
});




}
/// @nodoc
class __$PrayerLogCopyWithImpl<$Res>
    implements _$PrayerLogCopyWith<$Res> {
  __$PrayerLogCopyWithImpl(this._self, this._then);

  final _PrayerLog _self;
  final $Res Function(_PrayerLog) _then;

/// Create a copy of PrayerLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? prayerName = null,Object? date = null,Object? status = null,Object? loggedAt = freezed,}) {
  return _then(_PrayerLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,prayerName: null == prayerName ? _self.prayerName : prayerName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrayerStatus,loggedAt: freezed == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
