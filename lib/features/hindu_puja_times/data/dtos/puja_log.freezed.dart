// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'puja_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PujaLog {

 String? get id; String? get userId; String get sandhya; String get date;// 'yyyy-MM-dd'
 PujaStatus get status; DateTime? get createdAt;
/// Create a copy of PujaLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PujaLogCopyWith<PujaLog> get copyWith => _$PujaLogCopyWithImpl<PujaLog>(this as PujaLog, _$identity);

  /// Serializes this PujaLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PujaLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sandhya, sandhya) || other.sandhya == sandhya)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,sandhya,date,status,createdAt);

@override
String toString() {
  return 'PujaLog(id: $id, userId: $userId, sandhya: $sandhya, date: $date, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PujaLogCopyWith<$Res>  {
  factory $PujaLogCopyWith(PujaLog value, $Res Function(PujaLog) _then) = _$PujaLogCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String sandhya, String date, PujaStatus status, DateTime? createdAt
});




}
/// @nodoc
class _$PujaLogCopyWithImpl<$Res>
    implements $PujaLogCopyWith<$Res> {
  _$PujaLogCopyWithImpl(this._self, this._then);

  final PujaLog _self;
  final $Res Function(PujaLog) _then;

/// Create a copy of PujaLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? sandhya = null,Object? date = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,sandhya: null == sandhya ? _self.sandhya : sandhya // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PujaStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PujaLog].
extension PujaLogPatterns on PujaLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PujaLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PujaLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PujaLog value)  $default,){
final _that = this;
switch (_that) {
case _PujaLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PujaLog value)?  $default,){
final _that = this;
switch (_that) {
case _PujaLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String sandhya,  String date,  PujaStatus status,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PujaLog() when $default != null:
return $default(_that.id,_that.userId,_that.sandhya,_that.date,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String sandhya,  String date,  PujaStatus status,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PujaLog():
return $default(_that.id,_that.userId,_that.sandhya,_that.date,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String sandhya,  String date,  PujaStatus status,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PujaLog() when $default != null:
return $default(_that.id,_that.userId,_that.sandhya,_that.date,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PujaLog implements PujaLog {
  const _PujaLog({this.id, this.userId, required this.sandhya, required this.date, required this.status, this.createdAt});
  factory _PujaLog.fromJson(Map<String, dynamic> json) => _$PujaLogFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String sandhya;
@override final  String date;
// 'yyyy-MM-dd'
@override final  PujaStatus status;
@override final  DateTime? createdAt;

/// Create a copy of PujaLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PujaLogCopyWith<_PujaLog> get copyWith => __$PujaLogCopyWithImpl<_PujaLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PujaLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PujaLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sandhya, sandhya) || other.sandhya == sandhya)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,sandhya,date,status,createdAt);

@override
String toString() {
  return 'PujaLog(id: $id, userId: $userId, sandhya: $sandhya, date: $date, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PujaLogCopyWith<$Res> implements $PujaLogCopyWith<$Res> {
  factory _$PujaLogCopyWith(_PujaLog value, $Res Function(_PujaLog) _then) = __$PujaLogCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String sandhya, String date, PujaStatus status, DateTime? createdAt
});




}
/// @nodoc
class __$PujaLogCopyWithImpl<$Res>
    implements _$PujaLogCopyWith<$Res> {
  __$PujaLogCopyWithImpl(this._self, this._then);

  final _PujaLog _self;
  final $Res Function(_PujaLog) _then;

/// Create a copy of PujaLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? sandhya = null,Object? date = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_PujaLog(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,sandhya: null == sandhya ? _self.sandhya : sandhya // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PujaStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
