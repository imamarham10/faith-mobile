// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qibla_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QiblaData {

 double get latitude; double get longitude;/// Initial bearing in degrees (0..360) clockwise from true north.
 double get bearingDegrees;/// Great-circle distance to Makkah, in kilometres.
 double get distanceKm;
/// Create a copy of QiblaData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QiblaDataCopyWith<QiblaData> get copyWith => _$QiblaDataCopyWithImpl<QiblaData>(this as QiblaData, _$identity);

  /// Serializes this QiblaData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QiblaData&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.bearingDegrees, bearingDegrees) || other.bearingDegrees == bearingDegrees)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,bearingDegrees,distanceKm);

@override
String toString() {
  return 'QiblaData(latitude: $latitude, longitude: $longitude, bearingDegrees: $bearingDegrees, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $QiblaDataCopyWith<$Res>  {
  factory $QiblaDataCopyWith(QiblaData value, $Res Function(QiblaData) _then) = _$QiblaDataCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double bearingDegrees, double distanceKm
});




}
/// @nodoc
class _$QiblaDataCopyWithImpl<$Res>
    implements $QiblaDataCopyWith<$Res> {
  _$QiblaDataCopyWithImpl(this._self, this._then);

  final QiblaData _self;
  final $Res Function(QiblaData) _then;

/// Create a copy of QiblaData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? bearingDegrees = null,Object? distanceKm = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,bearingDegrees: null == bearingDegrees ? _self.bearingDegrees : bearingDegrees // ignore: cast_nullable_to_non_nullable
as double,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [QiblaData].
extension QiblaDataPatterns on QiblaData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QiblaData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QiblaData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QiblaData value)  $default,){
final _that = this;
switch (_that) {
case _QiblaData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QiblaData value)?  $default,){
final _that = this;
switch (_that) {
case _QiblaData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double bearingDegrees,  double distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QiblaData() when $default != null:
return $default(_that.latitude,_that.longitude,_that.bearingDegrees,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double bearingDegrees,  double distanceKm)  $default,) {final _that = this;
switch (_that) {
case _QiblaData():
return $default(_that.latitude,_that.longitude,_that.bearingDegrees,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double bearingDegrees,  double distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _QiblaData() when $default != null:
return $default(_that.latitude,_that.longitude,_that.bearingDegrees,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QiblaData implements QiblaData {
  const _QiblaData({required this.latitude, required this.longitude, required this.bearingDegrees, required this.distanceKm});
  factory _QiblaData.fromJson(Map<String, dynamic> json) => _$QiblaDataFromJson(json);

@override final  double latitude;
@override final  double longitude;
/// Initial bearing in degrees (0..360) clockwise from true north.
@override final  double bearingDegrees;
/// Great-circle distance to Makkah, in kilometres.
@override final  double distanceKm;

/// Create a copy of QiblaData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QiblaDataCopyWith<_QiblaData> get copyWith => __$QiblaDataCopyWithImpl<_QiblaData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QiblaDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QiblaData&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.bearingDegrees, bearingDegrees) || other.bearingDegrees == bearingDegrees)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,bearingDegrees,distanceKm);

@override
String toString() {
  return 'QiblaData(latitude: $latitude, longitude: $longitude, bearingDegrees: $bearingDegrees, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$QiblaDataCopyWith<$Res> implements $QiblaDataCopyWith<$Res> {
  factory _$QiblaDataCopyWith(_QiblaData value, $Res Function(_QiblaData) _then) = __$QiblaDataCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double bearingDegrees, double distanceKm
});




}
/// @nodoc
class __$QiblaDataCopyWithImpl<$Res>
    implements _$QiblaDataCopyWith<$Res> {
  __$QiblaDataCopyWithImpl(this._self, this._then);

  final _QiblaData _self;
  final $Res Function(_QiblaData) _then;

/// Create a copy of QiblaData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? bearingDegrees = null,Object? distanceKm = null,}) {
  return _then(_QiblaData(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,bearingDegrees: null == bearingDegrees ? _self.bearingDegrees : bearingDegrees // ignore: cast_nullable_to_non_nullable
as double,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
