// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hijri_today.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HijriToday {

 DateTime get gregorianDate; int get hijriYear; int get hijriMonth; int get hijriDay; String get hijriMonthName; String? get hijriMonthNameArabic;
/// Create a copy of HijriToday
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HijriTodayCopyWith<HijriToday> get copyWith => _$HijriTodayCopyWithImpl<HijriToday>(this as HijriToday, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HijriToday&&(identical(other.gregorianDate, gregorianDate) || other.gregorianDate == gregorianDate)&&(identical(other.hijriYear, hijriYear) || other.hijriYear == hijriYear)&&(identical(other.hijriMonth, hijriMonth) || other.hijriMonth == hijriMonth)&&(identical(other.hijriDay, hijriDay) || other.hijriDay == hijriDay)&&(identical(other.hijriMonthName, hijriMonthName) || other.hijriMonthName == hijriMonthName)&&(identical(other.hijriMonthNameArabic, hijriMonthNameArabic) || other.hijriMonthNameArabic == hijriMonthNameArabic));
}


@override
int get hashCode => Object.hash(runtimeType,gregorianDate,hijriYear,hijriMonth,hijriDay,hijriMonthName,hijriMonthNameArabic);

@override
String toString() {
  return 'HijriToday(gregorianDate: $gregorianDate, hijriYear: $hijriYear, hijriMonth: $hijriMonth, hijriDay: $hijriDay, hijriMonthName: $hijriMonthName, hijriMonthNameArabic: $hijriMonthNameArabic)';
}


}

/// @nodoc
abstract mixin class $HijriTodayCopyWith<$Res>  {
  factory $HijriTodayCopyWith(HijriToday value, $Res Function(HijriToday) _then) = _$HijriTodayCopyWithImpl;
@useResult
$Res call({
 DateTime gregorianDate, int hijriYear, int hijriMonth, int hijriDay, String hijriMonthName, String? hijriMonthNameArabic
});




}
/// @nodoc
class _$HijriTodayCopyWithImpl<$Res>
    implements $HijriTodayCopyWith<$Res> {
  _$HijriTodayCopyWithImpl(this._self, this._then);

  final HijriToday _self;
  final $Res Function(HijriToday) _then;

/// Create a copy of HijriToday
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gregorianDate = null,Object? hijriYear = null,Object? hijriMonth = null,Object? hijriDay = null,Object? hijriMonthName = null,Object? hijriMonthNameArabic = freezed,}) {
  return _then(_self.copyWith(
gregorianDate: null == gregorianDate ? _self.gregorianDate : gregorianDate // ignore: cast_nullable_to_non_nullable
as DateTime,hijriYear: null == hijriYear ? _self.hijriYear : hijriYear // ignore: cast_nullable_to_non_nullable
as int,hijriMonth: null == hijriMonth ? _self.hijriMonth : hijriMonth // ignore: cast_nullable_to_non_nullable
as int,hijriDay: null == hijriDay ? _self.hijriDay : hijriDay // ignore: cast_nullable_to_non_nullable
as int,hijriMonthName: null == hijriMonthName ? _self.hijriMonthName : hijriMonthName // ignore: cast_nullable_to_non_nullable
as String,hijriMonthNameArabic: freezed == hijriMonthNameArabic ? _self.hijriMonthNameArabic : hijriMonthNameArabic // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HijriToday].
extension HijriTodayPatterns on HijriToday {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HijriToday value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HijriToday() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HijriToday value)  $default,){
final _that = this;
switch (_that) {
case _HijriToday():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HijriToday value)?  $default,){
final _that = this;
switch (_that) {
case _HijriToday() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime gregorianDate,  int hijriYear,  int hijriMonth,  int hijriDay,  String hijriMonthName,  String? hijriMonthNameArabic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HijriToday() when $default != null:
return $default(_that.gregorianDate,_that.hijriYear,_that.hijriMonth,_that.hijriDay,_that.hijriMonthName,_that.hijriMonthNameArabic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime gregorianDate,  int hijriYear,  int hijriMonth,  int hijriDay,  String hijriMonthName,  String? hijriMonthNameArabic)  $default,) {final _that = this;
switch (_that) {
case _HijriToday():
return $default(_that.gregorianDate,_that.hijriYear,_that.hijriMonth,_that.hijriDay,_that.hijriMonthName,_that.hijriMonthNameArabic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime gregorianDate,  int hijriYear,  int hijriMonth,  int hijriDay,  String hijriMonthName,  String? hijriMonthNameArabic)?  $default,) {final _that = this;
switch (_that) {
case _HijriToday() when $default != null:
return $default(_that.gregorianDate,_that.hijriYear,_that.hijriMonth,_that.hijriDay,_that.hijriMonthName,_that.hijriMonthNameArabic);case _:
  return null;

}
}

}

/// @nodoc


class _HijriToday extends HijriToday {
  const _HijriToday({required this.gregorianDate, required this.hijriYear, required this.hijriMonth, required this.hijriDay, required this.hijriMonthName, this.hijriMonthNameArabic}): super._();
  

@override final  DateTime gregorianDate;
@override final  int hijriYear;
@override final  int hijriMonth;
@override final  int hijriDay;
@override final  String hijriMonthName;
@override final  String? hijriMonthNameArabic;

/// Create a copy of HijriToday
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HijriTodayCopyWith<_HijriToday> get copyWith => __$HijriTodayCopyWithImpl<_HijriToday>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HijriToday&&(identical(other.gregorianDate, gregorianDate) || other.gregorianDate == gregorianDate)&&(identical(other.hijriYear, hijriYear) || other.hijriYear == hijriYear)&&(identical(other.hijriMonth, hijriMonth) || other.hijriMonth == hijriMonth)&&(identical(other.hijriDay, hijriDay) || other.hijriDay == hijriDay)&&(identical(other.hijriMonthName, hijriMonthName) || other.hijriMonthName == hijriMonthName)&&(identical(other.hijriMonthNameArabic, hijriMonthNameArabic) || other.hijriMonthNameArabic == hijriMonthNameArabic));
}


@override
int get hashCode => Object.hash(runtimeType,gregorianDate,hijriYear,hijriMonth,hijriDay,hijriMonthName,hijriMonthNameArabic);

@override
String toString() {
  return 'HijriToday(gregorianDate: $gregorianDate, hijriYear: $hijriYear, hijriMonth: $hijriMonth, hijriDay: $hijriDay, hijriMonthName: $hijriMonthName, hijriMonthNameArabic: $hijriMonthNameArabic)';
}


}

/// @nodoc
abstract mixin class _$HijriTodayCopyWith<$Res> implements $HijriTodayCopyWith<$Res> {
  factory _$HijriTodayCopyWith(_HijriToday value, $Res Function(_HijriToday) _then) = __$HijriTodayCopyWithImpl;
@override @useResult
$Res call({
 DateTime gregorianDate, int hijriYear, int hijriMonth, int hijriDay, String hijriMonthName, String? hijriMonthNameArabic
});




}
/// @nodoc
class __$HijriTodayCopyWithImpl<$Res>
    implements _$HijriTodayCopyWith<$Res> {
  __$HijriTodayCopyWithImpl(this._self, this._then);

  final _HijriToday _self;
  final $Res Function(_HijriToday) _then;

/// Create a copy of HijriToday
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gregorianDate = null,Object? hijriYear = null,Object? hijriMonth = null,Object? hijriDay = null,Object? hijriMonthName = null,Object? hijriMonthNameArabic = freezed,}) {
  return _then(_HijriToday(
gregorianDate: null == gregorianDate ? _self.gregorianDate : gregorianDate // ignore: cast_nullable_to_non_nullable
as DateTime,hijriYear: null == hijriYear ? _self.hijriYear : hijriYear // ignore: cast_nullable_to_non_nullable
as int,hijriMonth: null == hijriMonth ? _self.hijriMonth : hijriMonth // ignore: cast_nullable_to_non_nullable
as int,hijriDay: null == hijriDay ? _self.hijriDay : hijriDay // ignore: cast_nullable_to_non_nullable
as int,hijriMonthName: null == hijriMonthName ? _self.hijriMonthName : hijriMonthName // ignore: cast_nullable_to_non_nullable
as String,hijriMonthNameArabic: freezed == hijriMonthNameArabic ? _self.hijriMonthNameArabic : hijriMonthNameArabic // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
