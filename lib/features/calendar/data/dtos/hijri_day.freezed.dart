// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hijri_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HijriDay {

 int get hijriDay; int get hijriMonth; int get hijriYear; String get hijriMonthName; String get gregorianDate; String get dayOfWeek;
/// Create a copy of HijriDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HijriDayCopyWith<HijriDay> get copyWith => _$HijriDayCopyWithImpl<HijriDay>(this as HijriDay, _$identity);

  /// Serializes this HijriDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HijriDay&&(identical(other.hijriDay, hijriDay) || other.hijriDay == hijriDay)&&(identical(other.hijriMonth, hijriMonth) || other.hijriMonth == hijriMonth)&&(identical(other.hijriYear, hijriYear) || other.hijriYear == hijriYear)&&(identical(other.hijriMonthName, hijriMonthName) || other.hijriMonthName == hijriMonthName)&&(identical(other.gregorianDate, gregorianDate) || other.gregorianDate == gregorianDate)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hijriDay,hijriMonth,hijriYear,hijriMonthName,gregorianDate,dayOfWeek);

@override
String toString() {
  return 'HijriDay(hijriDay: $hijriDay, hijriMonth: $hijriMonth, hijriYear: $hijriYear, hijriMonthName: $hijriMonthName, gregorianDate: $gregorianDate, dayOfWeek: $dayOfWeek)';
}


}

/// @nodoc
abstract mixin class $HijriDayCopyWith<$Res>  {
  factory $HijriDayCopyWith(HijriDay value, $Res Function(HijriDay) _then) = _$HijriDayCopyWithImpl;
@useResult
$Res call({
 int hijriDay, int hijriMonth, int hijriYear, String hijriMonthName, String gregorianDate, String dayOfWeek
});




}
/// @nodoc
class _$HijriDayCopyWithImpl<$Res>
    implements $HijriDayCopyWith<$Res> {
  _$HijriDayCopyWithImpl(this._self, this._then);

  final HijriDay _self;
  final $Res Function(HijriDay) _then;

/// Create a copy of HijriDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hijriDay = null,Object? hijriMonth = null,Object? hijriYear = null,Object? hijriMonthName = null,Object? gregorianDate = null,Object? dayOfWeek = null,}) {
  return _then(_self.copyWith(
hijriDay: null == hijriDay ? _self.hijriDay : hijriDay // ignore: cast_nullable_to_non_nullable
as int,hijriMonth: null == hijriMonth ? _self.hijriMonth : hijriMonth // ignore: cast_nullable_to_non_nullable
as int,hijriYear: null == hijriYear ? _self.hijriYear : hijriYear // ignore: cast_nullable_to_non_nullable
as int,hijriMonthName: null == hijriMonthName ? _self.hijriMonthName : hijriMonthName // ignore: cast_nullable_to_non_nullable
as String,gregorianDate: null == gregorianDate ? _self.gregorianDate : gregorianDate // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HijriDay].
extension HijriDayPatterns on HijriDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HijriDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HijriDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HijriDay value)  $default,){
final _that = this;
switch (_that) {
case _HijriDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HijriDay value)?  $default,){
final _that = this;
switch (_that) {
case _HijriDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hijriDay,  int hijriMonth,  int hijriYear,  String hijriMonthName,  String gregorianDate,  String dayOfWeek)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HijriDay() when $default != null:
return $default(_that.hijriDay,_that.hijriMonth,_that.hijriYear,_that.hijriMonthName,_that.gregorianDate,_that.dayOfWeek);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hijriDay,  int hijriMonth,  int hijriYear,  String hijriMonthName,  String gregorianDate,  String dayOfWeek)  $default,) {final _that = this;
switch (_that) {
case _HijriDay():
return $default(_that.hijriDay,_that.hijriMonth,_that.hijriYear,_that.hijriMonthName,_that.gregorianDate,_that.dayOfWeek);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hijriDay,  int hijriMonth,  int hijriYear,  String hijriMonthName,  String gregorianDate,  String dayOfWeek)?  $default,) {final _that = this;
switch (_that) {
case _HijriDay() when $default != null:
return $default(_that.hijriDay,_that.hijriMonth,_that.hijriYear,_that.hijriMonthName,_that.gregorianDate,_that.dayOfWeek);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HijriDay implements HijriDay {
  const _HijriDay({required this.hijriDay, required this.hijriMonth, required this.hijriYear, required this.hijriMonthName, required this.gregorianDate, required this.dayOfWeek});
  factory _HijriDay.fromJson(Map<String, dynamic> json) => _$HijriDayFromJson(json);

@override final  int hijriDay;
@override final  int hijriMonth;
@override final  int hijriYear;
@override final  String hijriMonthName;
@override final  String gregorianDate;
@override final  String dayOfWeek;

/// Create a copy of HijriDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HijriDayCopyWith<_HijriDay> get copyWith => __$HijriDayCopyWithImpl<_HijriDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HijriDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HijriDay&&(identical(other.hijriDay, hijriDay) || other.hijriDay == hijriDay)&&(identical(other.hijriMonth, hijriMonth) || other.hijriMonth == hijriMonth)&&(identical(other.hijriYear, hijriYear) || other.hijriYear == hijriYear)&&(identical(other.hijriMonthName, hijriMonthName) || other.hijriMonthName == hijriMonthName)&&(identical(other.gregorianDate, gregorianDate) || other.gregorianDate == gregorianDate)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hijriDay,hijriMonth,hijriYear,hijriMonthName,gregorianDate,dayOfWeek);

@override
String toString() {
  return 'HijriDay(hijriDay: $hijriDay, hijriMonth: $hijriMonth, hijriYear: $hijriYear, hijriMonthName: $hijriMonthName, gregorianDate: $gregorianDate, dayOfWeek: $dayOfWeek)';
}


}

/// @nodoc
abstract mixin class _$HijriDayCopyWith<$Res> implements $HijriDayCopyWith<$Res> {
  factory _$HijriDayCopyWith(_HijriDay value, $Res Function(_HijriDay) _then) = __$HijriDayCopyWithImpl;
@override @useResult
$Res call({
 int hijriDay, int hijriMonth, int hijriYear, String hijriMonthName, String gregorianDate, String dayOfWeek
});




}
/// @nodoc
class __$HijriDayCopyWithImpl<$Res>
    implements _$HijriDayCopyWith<$Res> {
  __$HijriDayCopyWithImpl(this._self, this._then);

  final _HijriDay _self;
  final $Res Function(_HijriDay) _then;

/// Create a copy of HijriDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hijriDay = null,Object? hijriMonth = null,Object? hijriYear = null,Object? hijriMonthName = null,Object? gregorianDate = null,Object? dayOfWeek = null,}) {
  return _then(_HijriDay(
hijriDay: null == hijriDay ? _self.hijriDay : hijriDay // ignore: cast_nullable_to_non_nullable
as int,hijriMonth: null == hijriMonth ? _self.hijriMonth : hijriMonth // ignore: cast_nullable_to_non_nullable
as int,hijriYear: null == hijriYear ? _self.hijriYear : hijriYear // ignore: cast_nullable_to_non_nullable
as int,hijriMonthName: null == hijriMonthName ? _self.hijriMonthName : hijriMonthName // ignore: cast_nullable_to_non_nullable
as String,gregorianDate: null == gregorianDate ? _self.gregorianDate : gregorianDate // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
