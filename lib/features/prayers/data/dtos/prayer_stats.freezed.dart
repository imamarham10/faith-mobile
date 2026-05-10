// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrayerStats {

 int get totalQaza; int get fajrQaza; int get dhuhrQaza; int get asrQaza; int get maghribQaza; int get ishaQaza;
/// Create a copy of PrayerStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerStatsCopyWith<PrayerStats> get copyWith => _$PrayerStatsCopyWithImpl<PrayerStats>(this as PrayerStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerStats&&(identical(other.totalQaza, totalQaza) || other.totalQaza == totalQaza)&&(identical(other.fajrQaza, fajrQaza) || other.fajrQaza == fajrQaza)&&(identical(other.dhuhrQaza, dhuhrQaza) || other.dhuhrQaza == dhuhrQaza)&&(identical(other.asrQaza, asrQaza) || other.asrQaza == asrQaza)&&(identical(other.maghribQaza, maghribQaza) || other.maghribQaza == maghribQaza)&&(identical(other.ishaQaza, ishaQaza) || other.ishaQaza == ishaQaza));
}


@override
int get hashCode => Object.hash(runtimeType,totalQaza,fajrQaza,dhuhrQaza,asrQaza,maghribQaza,ishaQaza);

@override
String toString() {
  return 'PrayerStats(totalQaza: $totalQaza, fajrQaza: $fajrQaza, dhuhrQaza: $dhuhrQaza, asrQaza: $asrQaza, maghribQaza: $maghribQaza, ishaQaza: $ishaQaza)';
}


}

/// @nodoc
abstract mixin class $PrayerStatsCopyWith<$Res>  {
  factory $PrayerStatsCopyWith(PrayerStats value, $Res Function(PrayerStats) _then) = _$PrayerStatsCopyWithImpl;
@useResult
$Res call({
 int totalQaza, int fajrQaza, int dhuhrQaza, int asrQaza, int maghribQaza, int ishaQaza
});




}
/// @nodoc
class _$PrayerStatsCopyWithImpl<$Res>
    implements $PrayerStatsCopyWith<$Res> {
  _$PrayerStatsCopyWithImpl(this._self, this._then);

  final PrayerStats _self;
  final $Res Function(PrayerStats) _then;

/// Create a copy of PrayerStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalQaza = null,Object? fajrQaza = null,Object? dhuhrQaza = null,Object? asrQaza = null,Object? maghribQaza = null,Object? ishaQaza = null,}) {
  return _then(_self.copyWith(
totalQaza: null == totalQaza ? _self.totalQaza : totalQaza // ignore: cast_nullable_to_non_nullable
as int,fajrQaza: null == fajrQaza ? _self.fajrQaza : fajrQaza // ignore: cast_nullable_to_non_nullable
as int,dhuhrQaza: null == dhuhrQaza ? _self.dhuhrQaza : dhuhrQaza // ignore: cast_nullable_to_non_nullable
as int,asrQaza: null == asrQaza ? _self.asrQaza : asrQaza // ignore: cast_nullable_to_non_nullable
as int,maghribQaza: null == maghribQaza ? _self.maghribQaza : maghribQaza // ignore: cast_nullable_to_non_nullable
as int,ishaQaza: null == ishaQaza ? _self.ishaQaza : ishaQaza // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrayerStats].
extension PrayerStatsPatterns on PrayerStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrayerStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrayerStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrayerStats value)  $default,){
final _that = this;
switch (_that) {
case _PrayerStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrayerStats value)?  $default,){
final _that = this;
switch (_that) {
case _PrayerStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalQaza,  int fajrQaza,  int dhuhrQaza,  int asrQaza,  int maghribQaza,  int ishaQaza)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrayerStats() when $default != null:
return $default(_that.totalQaza,_that.fajrQaza,_that.dhuhrQaza,_that.asrQaza,_that.maghribQaza,_that.ishaQaza);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalQaza,  int fajrQaza,  int dhuhrQaza,  int asrQaza,  int maghribQaza,  int ishaQaza)  $default,) {final _that = this;
switch (_that) {
case _PrayerStats():
return $default(_that.totalQaza,_that.fajrQaza,_that.dhuhrQaza,_that.asrQaza,_that.maghribQaza,_that.ishaQaza);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalQaza,  int fajrQaza,  int dhuhrQaza,  int asrQaza,  int maghribQaza,  int ishaQaza)?  $default,) {final _that = this;
switch (_that) {
case _PrayerStats() when $default != null:
return $default(_that.totalQaza,_that.fajrQaza,_that.dhuhrQaza,_that.asrQaza,_that.maghribQaza,_that.ishaQaza);case _:
  return null;

}
}

}

/// @nodoc


class _PrayerStats extends PrayerStats {
  const _PrayerStats({required this.totalQaza, required this.fajrQaza, required this.dhuhrQaza, required this.asrQaza, required this.maghribQaza, required this.ishaQaza}): super._();
  

@override final  int totalQaza;
@override final  int fajrQaza;
@override final  int dhuhrQaza;
@override final  int asrQaza;
@override final  int maghribQaza;
@override final  int ishaQaza;

/// Create a copy of PrayerStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrayerStatsCopyWith<_PrayerStats> get copyWith => __$PrayerStatsCopyWithImpl<_PrayerStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrayerStats&&(identical(other.totalQaza, totalQaza) || other.totalQaza == totalQaza)&&(identical(other.fajrQaza, fajrQaza) || other.fajrQaza == fajrQaza)&&(identical(other.dhuhrQaza, dhuhrQaza) || other.dhuhrQaza == dhuhrQaza)&&(identical(other.asrQaza, asrQaza) || other.asrQaza == asrQaza)&&(identical(other.maghribQaza, maghribQaza) || other.maghribQaza == maghribQaza)&&(identical(other.ishaQaza, ishaQaza) || other.ishaQaza == ishaQaza));
}


@override
int get hashCode => Object.hash(runtimeType,totalQaza,fajrQaza,dhuhrQaza,asrQaza,maghribQaza,ishaQaza);

@override
String toString() {
  return 'PrayerStats(totalQaza: $totalQaza, fajrQaza: $fajrQaza, dhuhrQaza: $dhuhrQaza, asrQaza: $asrQaza, maghribQaza: $maghribQaza, ishaQaza: $ishaQaza)';
}


}

/// @nodoc
abstract mixin class _$PrayerStatsCopyWith<$Res> implements $PrayerStatsCopyWith<$Res> {
  factory _$PrayerStatsCopyWith(_PrayerStats value, $Res Function(_PrayerStats) _then) = __$PrayerStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalQaza, int fajrQaza, int dhuhrQaza, int asrQaza, int maghribQaza, int ishaQaza
});




}
/// @nodoc
class __$PrayerStatsCopyWithImpl<$Res>
    implements _$PrayerStatsCopyWith<$Res> {
  __$PrayerStatsCopyWithImpl(this._self, this._then);

  final _PrayerStats _self;
  final $Res Function(_PrayerStats) _then;

/// Create a copy of PrayerStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalQaza = null,Object? fajrQaza = null,Object? dhuhrQaza = null,Object? asrQaza = null,Object? maghribQaza = null,Object? ishaQaza = null,}) {
  return _then(_PrayerStats(
totalQaza: null == totalQaza ? _self.totalQaza : totalQaza // ignore: cast_nullable_to_non_nullable
as int,fajrQaza: null == fajrQaza ? _self.fajrQaza : fajrQaza // ignore: cast_nullable_to_non_nullable
as int,dhuhrQaza: null == dhuhrQaza ? _self.dhuhrQaza : dhuhrQaza // ignore: cast_nullable_to_non_nullable
as int,asrQaza: null == asrQaza ? _self.asrQaza : asrQaza // ignore: cast_nullable_to_non_nullable
as int,maghribQaza: null == maghribQaza ? _self.maghribQaza : maghribQaza // ignore: cast_nullable_to_non_nullable
as int,ishaQaza: null == ishaQaza ? _self.ishaQaza : ishaQaza // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
