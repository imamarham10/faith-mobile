// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'puja_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PujaStats {

 int get total; int get onTime; int get late; int get missed; int get currentStreak; int get longestStreak; double get completionRate;
/// Create a copy of PujaStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PujaStatsCopyWith<PujaStats> get copyWith => _$PujaStatsCopyWithImpl<PujaStats>(this as PujaStats, _$identity);

  /// Serializes this PujaStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PujaStats&&(identical(other.total, total) || other.total == total)&&(identical(other.onTime, onTime) || other.onTime == onTime)&&(identical(other.late, late) || other.late == late)&&(identical(other.missed, missed) || other.missed == missed)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,onTime,late,missed,currentStreak,longestStreak,completionRate);

@override
String toString() {
  return 'PujaStats(total: $total, onTime: $onTime, late: $late, missed: $missed, currentStreak: $currentStreak, longestStreak: $longestStreak, completionRate: $completionRate)';
}


}

/// @nodoc
abstract mixin class $PujaStatsCopyWith<$Res>  {
  factory $PujaStatsCopyWith(PujaStats value, $Res Function(PujaStats) _then) = _$PujaStatsCopyWithImpl;
@useResult
$Res call({
 int total, int onTime, int late, int missed, int currentStreak, int longestStreak, double completionRate
});




}
/// @nodoc
class _$PujaStatsCopyWithImpl<$Res>
    implements $PujaStatsCopyWith<$Res> {
  _$PujaStatsCopyWithImpl(this._self, this._then);

  final PujaStats _self;
  final $Res Function(PujaStats) _then;

/// Create a copy of PujaStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? onTime = null,Object? late = null,Object? missed = null,Object? currentStreak = null,Object? longestStreak = null,Object? completionRate = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,onTime: null == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,missed: null == missed ? _self.missed : missed // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PujaStats].
extension PujaStatsPatterns on PujaStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PujaStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PujaStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PujaStats value)  $default,){
final _that = this;
switch (_that) {
case _PujaStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PujaStats value)?  $default,){
final _that = this;
switch (_that) {
case _PujaStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int onTime,  int late,  int missed,  int currentStreak,  int longestStreak,  double completionRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PujaStats() when $default != null:
return $default(_that.total,_that.onTime,_that.late,_that.missed,_that.currentStreak,_that.longestStreak,_that.completionRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int onTime,  int late,  int missed,  int currentStreak,  int longestStreak,  double completionRate)  $default,) {final _that = this;
switch (_that) {
case _PujaStats():
return $default(_that.total,_that.onTime,_that.late,_that.missed,_that.currentStreak,_that.longestStreak,_that.completionRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int onTime,  int late,  int missed,  int currentStreak,  int longestStreak,  double completionRate)?  $default,) {final _that = this;
switch (_that) {
case _PujaStats() when $default != null:
return $default(_that.total,_that.onTime,_that.late,_that.missed,_that.currentStreak,_that.longestStreak,_that.completionRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PujaStats extends PujaStats {
  const _PujaStats({this.total = 0, this.onTime = 0, this.late = 0, this.missed = 0, this.currentStreak = 0, this.longestStreak = 0, this.completionRate = 0}): super._();
  factory _PujaStats.fromJson(Map<String, dynamic> json) => _$PujaStatsFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  int onTime;
@override@JsonKey() final  int late;
@override@JsonKey() final  int missed;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override@JsonKey() final  double completionRate;

/// Create a copy of PujaStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PujaStatsCopyWith<_PujaStats> get copyWith => __$PujaStatsCopyWithImpl<_PujaStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PujaStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PujaStats&&(identical(other.total, total) || other.total == total)&&(identical(other.onTime, onTime) || other.onTime == onTime)&&(identical(other.late, late) || other.late == late)&&(identical(other.missed, missed) || other.missed == missed)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,onTime,late,missed,currentStreak,longestStreak,completionRate);

@override
String toString() {
  return 'PujaStats(total: $total, onTime: $onTime, late: $late, missed: $missed, currentStreak: $currentStreak, longestStreak: $longestStreak, completionRate: $completionRate)';
}


}

/// @nodoc
abstract mixin class _$PujaStatsCopyWith<$Res> implements $PujaStatsCopyWith<$Res> {
  factory _$PujaStatsCopyWith(_PujaStats value, $Res Function(_PujaStats) _then) = __$PujaStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int onTime, int late, int missed, int currentStreak, int longestStreak, double completionRate
});




}
/// @nodoc
class __$PujaStatsCopyWithImpl<$Res>
    implements _$PujaStatsCopyWith<$Res> {
  __$PujaStatsCopyWithImpl(this._self, this._then);

  final _PujaStats _self;
  final $Res Function(_PujaStats) _then;

/// Create a copy of PujaStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? onTime = null,Object? late = null,Object? missed = null,Object? currentStreak = null,Object? longestStreak = null,Object? completionRate = null,}) {
  return _then(_PujaStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,onTime: null == onTime ? _self.onTime : onTime // ignore: cast_nullable_to_non_nullable
as int,late: null == late ? _self.late : late // ignore: cast_nullable_to_non_nullable
as int,missed: null == missed ? _self.missed : missed // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
