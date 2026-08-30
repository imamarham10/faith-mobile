// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panchang_month.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PanchangMonth {

 int get year; int get month; List<PanchangDay> get days;
/// Create a copy of PanchangMonth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanchangMonthCopyWith<PanchangMonth> get copyWith => _$PanchangMonthCopyWithImpl<PanchangMonth>(this as PanchangMonth, _$identity);

  /// Serializes this PanchangMonth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanchangMonth&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'PanchangMonth(year: $year, month: $month, days: $days)';
}


}

/// @nodoc
abstract mixin class $PanchangMonthCopyWith<$Res>  {
  factory $PanchangMonthCopyWith(PanchangMonth value, $Res Function(PanchangMonth) _then) = _$PanchangMonthCopyWithImpl;
@useResult
$Res call({
 int year, int month, List<PanchangDay> days
});




}
/// @nodoc
class _$PanchangMonthCopyWithImpl<$Res>
    implements $PanchangMonthCopyWith<$Res> {
  _$PanchangMonthCopyWithImpl(this._self, this._then);

  final PanchangMonth _self;
  final $Res Function(PanchangMonth) _then;

/// Create a copy of PanchangMonth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? days = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<PanchangDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [PanchangMonth].
extension PanchangMonthPatterns on PanchangMonth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanchangMonth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanchangMonth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanchangMonth value)  $default,){
final _that = this;
switch (_that) {
case _PanchangMonth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanchangMonth value)?  $default,){
final _that = this;
switch (_that) {
case _PanchangMonth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  List<PanchangDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanchangMonth() when $default != null:
return $default(_that.year,_that.month,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  List<PanchangDay> days)  $default,) {final _that = this;
switch (_that) {
case _PanchangMonth():
return $default(_that.year,_that.month,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  List<PanchangDay> days)?  $default,) {final _that = this;
switch (_that) {
case _PanchangMonth() when $default != null:
return $default(_that.year,_that.month,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanchangMonth implements PanchangMonth {
  const _PanchangMonth({required this.year, required this.month, final  List<PanchangDay> days = const <PanchangDay>[]}): _days = days;
  factory _PanchangMonth.fromJson(Map<String, dynamic> json) => _$PanchangMonthFromJson(json);

@override final  int year;
@override final  int month;
 final  List<PanchangDay> _days;
@override@JsonKey() List<PanchangDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of PanchangMonth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanchangMonthCopyWith<_PanchangMonth> get copyWith => __$PanchangMonthCopyWithImpl<_PanchangMonth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanchangMonthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanchangMonth&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'PanchangMonth(year: $year, month: $month, days: $days)';
}


}

/// @nodoc
abstract mixin class _$PanchangMonthCopyWith<$Res> implements $PanchangMonthCopyWith<$Res> {
  factory _$PanchangMonthCopyWith(_PanchangMonth value, $Res Function(_PanchangMonth) _then) = __$PanchangMonthCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, List<PanchangDay> days
});




}
/// @nodoc
class __$PanchangMonthCopyWithImpl<$Res>
    implements _$PanchangMonthCopyWith<$Res> {
  __$PanchangMonthCopyWithImpl(this._self, this._then);

  final _PanchangMonth _self;
  final $Res Function(_PanchangMonth) _then;

/// Create a copy of PanchangMonth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? days = null,}) {
  return _then(_PanchangMonth(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<PanchangDay>,
  ));
}


}

// dart format on
