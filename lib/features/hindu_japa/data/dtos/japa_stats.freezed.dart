// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'japa_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JapaStats {

 int get totalCount; double get dailyAverage; int get currentStreak; int get longestStreak; String? get mostRecitedPhrase;
/// Create a copy of JapaStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JapaStatsCopyWith<JapaStats> get copyWith => _$JapaStatsCopyWithImpl<JapaStats>(this as JapaStats, _$identity);

  /// Serializes this JapaStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JapaStats&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.mostRecitedPhrase, mostRecitedPhrase) || other.mostRecitedPhrase == mostRecitedPhrase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,dailyAverage,currentStreak,longestStreak,mostRecitedPhrase);

@override
String toString() {
  return 'JapaStats(totalCount: $totalCount, dailyAverage: $dailyAverage, currentStreak: $currentStreak, longestStreak: $longestStreak, mostRecitedPhrase: $mostRecitedPhrase)';
}


}

/// @nodoc
abstract mixin class $JapaStatsCopyWith<$Res>  {
  factory $JapaStatsCopyWith(JapaStats value, $Res Function(JapaStats) _then) = _$JapaStatsCopyWithImpl;
@useResult
$Res call({
 int totalCount, double dailyAverage, int currentStreak, int longestStreak, String? mostRecitedPhrase
});




}
/// @nodoc
class _$JapaStatsCopyWithImpl<$Res>
    implements $JapaStatsCopyWith<$Res> {
  _$JapaStatsCopyWithImpl(this._self, this._then);

  final JapaStats _self;
  final $Res Function(JapaStats) _then;

/// Create a copy of JapaStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? dailyAverage = null,Object? currentStreak = null,Object? longestStreak = null,Object? mostRecitedPhrase = freezed,}) {
  return _then(_self.copyWith(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,mostRecitedPhrase: freezed == mostRecitedPhrase ? _self.mostRecitedPhrase : mostRecitedPhrase // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JapaStats].
extension JapaStatsPatterns on JapaStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JapaStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JapaStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JapaStats value)  $default,){
final _that = this;
switch (_that) {
case _JapaStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JapaStats value)?  $default,){
final _that = this;
switch (_that) {
case _JapaStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCount,  double dailyAverage,  int currentStreak,  int longestStreak,  String? mostRecitedPhrase)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JapaStats() when $default != null:
return $default(_that.totalCount,_that.dailyAverage,_that.currentStreak,_that.longestStreak,_that.mostRecitedPhrase);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCount,  double dailyAverage,  int currentStreak,  int longestStreak,  String? mostRecitedPhrase)  $default,) {final _that = this;
switch (_that) {
case _JapaStats():
return $default(_that.totalCount,_that.dailyAverage,_that.currentStreak,_that.longestStreak,_that.mostRecitedPhrase);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCount,  double dailyAverage,  int currentStreak,  int longestStreak,  String? mostRecitedPhrase)?  $default,) {final _that = this;
switch (_that) {
case _JapaStats() when $default != null:
return $default(_that.totalCount,_that.dailyAverage,_that.currentStreak,_that.longestStreak,_that.mostRecitedPhrase);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JapaStats implements JapaStats {
  const _JapaStats({this.totalCount = 0, this.dailyAverage = 0, this.currentStreak = 0, this.longestStreak = 0, this.mostRecitedPhrase});
  factory _JapaStats.fromJson(Map<String, dynamic> json) => _$JapaStatsFromJson(json);

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  double dailyAverage;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override final  String? mostRecitedPhrase;

/// Create a copy of JapaStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JapaStatsCopyWith<_JapaStats> get copyWith => __$JapaStatsCopyWithImpl<_JapaStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JapaStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JapaStats&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.dailyAverage, dailyAverage) || other.dailyAverage == dailyAverage)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.mostRecitedPhrase, mostRecitedPhrase) || other.mostRecitedPhrase == mostRecitedPhrase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,dailyAverage,currentStreak,longestStreak,mostRecitedPhrase);

@override
String toString() {
  return 'JapaStats(totalCount: $totalCount, dailyAverage: $dailyAverage, currentStreak: $currentStreak, longestStreak: $longestStreak, mostRecitedPhrase: $mostRecitedPhrase)';
}


}

/// @nodoc
abstract mixin class _$JapaStatsCopyWith<$Res> implements $JapaStatsCopyWith<$Res> {
  factory _$JapaStatsCopyWith(_JapaStats value, $Res Function(_JapaStats) _then) = __$JapaStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalCount, double dailyAverage, int currentStreak, int longestStreak, String? mostRecitedPhrase
});




}
/// @nodoc
class __$JapaStatsCopyWithImpl<$Res>
    implements _$JapaStatsCopyWith<$Res> {
  __$JapaStatsCopyWithImpl(this._self, this._then);

  final _JapaStats _self;
  final $Res Function(_JapaStats) _then;

/// Create a copy of JapaStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? dailyAverage = null,Object? currentStreak = null,Object? longestStreak = null,Object? mostRecitedPhrase = freezed,}) {
  return _then(_JapaStats(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,dailyAverage: null == dailyAverage ? _self.dailyAverage : dailyAverage // ignore: cast_nullable_to_non_nullable
as double,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,mostRecitedPhrase: freezed == mostRecitedPhrase ? _self.mostRecitedPhrase : mostRecitedPhrase // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
