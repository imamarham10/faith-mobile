// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_times.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrayerTimes {

 DateTime get date; double get latitude; double get longitude; DateTime get fajr; DateTime get sunrise; DateTime get dhuhr; DateTime get asr; DateTime get maghrib; DateTime get isha;
/// Create a copy of PrayerTimes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerTimesCopyWith<PrayerTimes> get copyWith => _$PrayerTimesCopyWithImpl<PrayerTimes>(this as PrayerTimes, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerTimes&&(identical(other.date, date) || other.date == date)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.fajr, fajr) || other.fajr == fajr)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.dhuhr, dhuhr) || other.dhuhr == dhuhr)&&(identical(other.asr, asr) || other.asr == asr)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isha, isha) || other.isha == isha));
}


@override
int get hashCode => Object.hash(runtimeType,date,latitude,longitude,fajr,sunrise,dhuhr,asr,maghrib,isha);

@override
String toString() {
  return 'PrayerTimes(date: $date, latitude: $latitude, longitude: $longitude, fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, asr: $asr, maghrib: $maghrib, isha: $isha)';
}


}

/// @nodoc
abstract mixin class $PrayerTimesCopyWith<$Res>  {
  factory $PrayerTimesCopyWith(PrayerTimes value, $Res Function(PrayerTimes) _then) = _$PrayerTimesCopyWithImpl;
@useResult
$Res call({
 DateTime date, double latitude, double longitude, DateTime fajr, DateTime sunrise, DateTime dhuhr, DateTime asr, DateTime maghrib, DateTime isha
});




}
/// @nodoc
class _$PrayerTimesCopyWithImpl<$Res>
    implements $PrayerTimesCopyWith<$Res> {
  _$PrayerTimesCopyWithImpl(this._self, this._then);

  final PrayerTimes _self;
  final $Res Function(PrayerTimes) _then;

/// Create a copy of PrayerTimes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? latitude = null,Object? longitude = null,Object? fajr = null,Object? sunrise = null,Object? dhuhr = null,Object? asr = null,Object? maghrib = null,Object? isha = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,fajr: null == fajr ? _self.fajr : fajr // ignore: cast_nullable_to_non_nullable
as DateTime,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,dhuhr: null == dhuhr ? _self.dhuhr : dhuhr // ignore: cast_nullable_to_non_nullable
as DateTime,asr: null == asr ? _self.asr : asr // ignore: cast_nullable_to_non_nullable
as DateTime,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as DateTime,isha: null == isha ? _self.isha : isha // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PrayerTimes].
extension PrayerTimesPatterns on PrayerTimes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrayerTimes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrayerTimes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrayerTimes value)  $default,){
final _that = this;
switch (_that) {
case _PrayerTimes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrayerTimes value)?  $default,){
final _that = this;
switch (_that) {
case _PrayerTimes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double latitude,  double longitude,  DateTime fajr,  DateTime sunrise,  DateTime dhuhr,  DateTime asr,  DateTime maghrib,  DateTime isha)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrayerTimes() when $default != null:
return $default(_that.date,_that.latitude,_that.longitude,_that.fajr,_that.sunrise,_that.dhuhr,_that.asr,_that.maghrib,_that.isha);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double latitude,  double longitude,  DateTime fajr,  DateTime sunrise,  DateTime dhuhr,  DateTime asr,  DateTime maghrib,  DateTime isha)  $default,) {final _that = this;
switch (_that) {
case _PrayerTimes():
return $default(_that.date,_that.latitude,_that.longitude,_that.fajr,_that.sunrise,_that.dhuhr,_that.asr,_that.maghrib,_that.isha);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double latitude,  double longitude,  DateTime fajr,  DateTime sunrise,  DateTime dhuhr,  DateTime asr,  DateTime maghrib,  DateTime isha)?  $default,) {final _that = this;
switch (_that) {
case _PrayerTimes() when $default != null:
return $default(_that.date,_that.latitude,_that.longitude,_that.fajr,_that.sunrise,_that.dhuhr,_that.asr,_that.maghrib,_that.isha);case _:
  return null;

}
}

}

/// @nodoc


class _PrayerTimes extends PrayerTimes {
  const _PrayerTimes({required this.date, required this.latitude, required this.longitude, required this.fajr, required this.sunrise, required this.dhuhr, required this.asr, required this.maghrib, required this.isha}): super._();
  

@override final  DateTime date;
@override final  double latitude;
@override final  double longitude;
@override final  DateTime fajr;
@override final  DateTime sunrise;
@override final  DateTime dhuhr;
@override final  DateTime asr;
@override final  DateTime maghrib;
@override final  DateTime isha;

/// Create a copy of PrayerTimes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrayerTimesCopyWith<_PrayerTimes> get copyWith => __$PrayerTimesCopyWithImpl<_PrayerTimes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrayerTimes&&(identical(other.date, date) || other.date == date)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.fajr, fajr) || other.fajr == fajr)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.dhuhr, dhuhr) || other.dhuhr == dhuhr)&&(identical(other.asr, asr) || other.asr == asr)&&(identical(other.maghrib, maghrib) || other.maghrib == maghrib)&&(identical(other.isha, isha) || other.isha == isha));
}


@override
int get hashCode => Object.hash(runtimeType,date,latitude,longitude,fajr,sunrise,dhuhr,asr,maghrib,isha);

@override
String toString() {
  return 'PrayerTimes(date: $date, latitude: $latitude, longitude: $longitude, fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, asr: $asr, maghrib: $maghrib, isha: $isha)';
}


}

/// @nodoc
abstract mixin class _$PrayerTimesCopyWith<$Res> implements $PrayerTimesCopyWith<$Res> {
  factory _$PrayerTimesCopyWith(_PrayerTimes value, $Res Function(_PrayerTimes) _then) = __$PrayerTimesCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double latitude, double longitude, DateTime fajr, DateTime sunrise, DateTime dhuhr, DateTime asr, DateTime maghrib, DateTime isha
});




}
/// @nodoc
class __$PrayerTimesCopyWithImpl<$Res>
    implements _$PrayerTimesCopyWith<$Res> {
  __$PrayerTimesCopyWithImpl(this._self, this._then);

  final _PrayerTimes _self;
  final $Res Function(_PrayerTimes) _then;

/// Create a copy of PrayerTimes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? latitude = null,Object? longitude = null,Object? fajr = null,Object? sunrise = null,Object? dhuhr = null,Object? asr = null,Object? maghrib = null,Object? isha = null,}) {
  return _then(_PrayerTimes(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,fajr: null == fajr ? _self.fajr : fajr // ignore: cast_nullable_to_non_nullable
as DateTime,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,dhuhr: null == dhuhr ? _self.dhuhr : dhuhr // ignore: cast_nullable_to_non_nullable
as DateTime,asr: null == asr ? _self.asr : asr // ignore: cast_nullable_to_non_nullable
as DateTime,maghrib: null == maghrib ? _self.maghrib : maghrib // ignore: cast_nullable_to_non_nullable
as DateTime,isha: null == isha ? _self.isha : isha // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
