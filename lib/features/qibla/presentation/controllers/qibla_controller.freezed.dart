// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qibla_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QiblaSnapshot {

 QiblaData get qibla;/// Smoothed device heading (degrees, 0..360, clockwise from north).
/// `null` when the platform has no usable magnetometer (e.g. simulator).
 double? get deviceHeading;/// Whether the latest sensor sample reported low accuracy.
 bool get needsCalibration;
/// Create a copy of QiblaSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QiblaSnapshotCopyWith<QiblaSnapshot> get copyWith => _$QiblaSnapshotCopyWithImpl<QiblaSnapshot>(this as QiblaSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaSnapshot&&(identical(other.qibla, qibla) || other.qibla == qibla)&&(identical(other.deviceHeading, deviceHeading) || other.deviceHeading == deviceHeading)&&(identical(other.needsCalibration, needsCalibration) || other.needsCalibration == needsCalibration));
}


@override
int get hashCode => Object.hash(runtimeType,qibla,deviceHeading,needsCalibration);

@override
String toString() {
  return 'QiblaSnapshot(qibla: $qibla, deviceHeading: $deviceHeading, needsCalibration: $needsCalibration)';
}


}

/// @nodoc
abstract mixin class $QiblaSnapshotCopyWith<$Res>  {
  factory $QiblaSnapshotCopyWith(QiblaSnapshot value, $Res Function(QiblaSnapshot) _then) = _$QiblaSnapshotCopyWithImpl;
@useResult
$Res call({
 QiblaData qibla, double? deviceHeading, bool needsCalibration
});


$QiblaDataCopyWith<$Res> get qibla;

}
/// @nodoc
class _$QiblaSnapshotCopyWithImpl<$Res>
    implements $QiblaSnapshotCopyWith<$Res> {
  _$QiblaSnapshotCopyWithImpl(this._self, this._then);

  final QiblaSnapshot _self;
  final $Res Function(QiblaSnapshot) _then;

/// Create a copy of QiblaSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qibla = null,Object? deviceHeading = freezed,Object? needsCalibration = null,}) {
  return _then(_self.copyWith(
qibla: null == qibla ? _self.qibla : qibla // ignore: cast_nullable_to_non_nullable
as QiblaData,deviceHeading: freezed == deviceHeading ? _self.deviceHeading : deviceHeading // ignore: cast_nullable_to_non_nullable
as double?,needsCalibration: null == needsCalibration ? _self.needsCalibration : needsCalibration // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of QiblaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QiblaDataCopyWith<$Res> get qibla {
  
  return $QiblaDataCopyWith<$Res>(_self.qibla, (value) {
    return _then(_self.copyWith(qibla: value));
  });
}
}


/// Adds pattern-matching-related methods to [QiblaSnapshot].
extension QiblaSnapshotPatterns on QiblaSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QiblaSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QiblaSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QiblaSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _QiblaSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QiblaSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _QiblaSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QiblaData qibla,  double? deviceHeading,  bool needsCalibration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QiblaSnapshot() when $default != null:
return $default(_that.qibla,_that.deviceHeading,_that.needsCalibration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QiblaData qibla,  double? deviceHeading,  bool needsCalibration)  $default,) {final _that = this;
switch (_that) {
case _QiblaSnapshot():
return $default(_that.qibla,_that.deviceHeading,_that.needsCalibration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QiblaData qibla,  double? deviceHeading,  bool needsCalibration)?  $default,) {final _that = this;
switch (_that) {
case _QiblaSnapshot() when $default != null:
return $default(_that.qibla,_that.deviceHeading,_that.needsCalibration);case _:
  return null;

}
}

}

/// @nodoc


class _QiblaSnapshot implements QiblaSnapshot {
  const _QiblaSnapshot({required this.qibla, required this.deviceHeading, required this.needsCalibration});
  

@override final  QiblaData qibla;
/// Smoothed device heading (degrees, 0..360, clockwise from north).
/// `null` when the platform has no usable magnetometer (e.g. simulator).
@override final  double? deviceHeading;
/// Whether the latest sensor sample reported low accuracy.
@override final  bool needsCalibration;

/// Create a copy of QiblaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QiblaSnapshotCopyWith<_QiblaSnapshot> get copyWith => __$QiblaSnapshotCopyWithImpl<_QiblaSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QiblaSnapshot&&(identical(other.qibla, qibla) || other.qibla == qibla)&&(identical(other.deviceHeading, deviceHeading) || other.deviceHeading == deviceHeading)&&(identical(other.needsCalibration, needsCalibration) || other.needsCalibration == needsCalibration));
}


@override
int get hashCode => Object.hash(runtimeType,qibla,deviceHeading,needsCalibration);

@override
String toString() {
  return 'QiblaSnapshot(qibla: $qibla, deviceHeading: $deviceHeading, needsCalibration: $needsCalibration)';
}


}

/// @nodoc
abstract mixin class _$QiblaSnapshotCopyWith<$Res> implements $QiblaSnapshotCopyWith<$Res> {
  factory _$QiblaSnapshotCopyWith(_QiblaSnapshot value, $Res Function(_QiblaSnapshot) _then) = __$QiblaSnapshotCopyWithImpl;
@override @useResult
$Res call({
 QiblaData qibla, double? deviceHeading, bool needsCalibration
});


@override $QiblaDataCopyWith<$Res> get qibla;

}
/// @nodoc
class __$QiblaSnapshotCopyWithImpl<$Res>
    implements _$QiblaSnapshotCopyWith<$Res> {
  __$QiblaSnapshotCopyWithImpl(this._self, this._then);

  final _QiblaSnapshot _self;
  final $Res Function(_QiblaSnapshot) _then;

/// Create a copy of QiblaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qibla = null,Object? deviceHeading = freezed,Object? needsCalibration = null,}) {
  return _then(_QiblaSnapshot(
qibla: null == qibla ? _self.qibla : qibla // ignore: cast_nullable_to_non_nullable
as QiblaData,deviceHeading: freezed == deviceHeading ? _self.deviceHeading : deviceHeading // ignore: cast_nullable_to_non_nullable
as double?,needsCalibration: null == needsCalibration ? _self.needsCalibration : needsCalibration // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of QiblaSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QiblaDataCopyWith<$Res> get qibla {
  
  return $QiblaDataCopyWith<$Res>(_self.qibla, (value) {
    return _then(_self.copyWith(qibla: value));
  });
}
}

// dart format on
