// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'festival_occurrence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FestivalOccurrence {

 HinduFestival get festival; DateTime get date;
/// Create a copy of FestivalOccurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalOccurrenceCopyWith<FestivalOccurrence> get copyWith => _$FestivalOccurrenceCopyWithImpl<FestivalOccurrence>(this as FestivalOccurrence, _$identity);

  /// Serializes this FestivalOccurrence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivalOccurrence&&(identical(other.festival, festival) || other.festival == festival)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,festival,date);

@override
String toString() {
  return 'FestivalOccurrence(festival: $festival, date: $date)';
}


}

/// @nodoc
abstract mixin class $FestivalOccurrenceCopyWith<$Res>  {
  factory $FestivalOccurrenceCopyWith(FestivalOccurrence value, $Res Function(FestivalOccurrence) _then) = _$FestivalOccurrenceCopyWithImpl;
@useResult
$Res call({
 HinduFestival festival, DateTime date
});


$HinduFestivalCopyWith<$Res> get festival;

}
/// @nodoc
class _$FestivalOccurrenceCopyWithImpl<$Res>
    implements $FestivalOccurrenceCopyWith<$Res> {
  _$FestivalOccurrenceCopyWithImpl(this._self, this._then);

  final FestivalOccurrence _self;
  final $Res Function(FestivalOccurrence) _then;

/// Create a copy of FestivalOccurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? festival = null,Object? date = null,}) {
  return _then(_self.copyWith(
festival: null == festival ? _self.festival : festival // ignore: cast_nullable_to_non_nullable
as HinduFestival,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of FestivalOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HinduFestivalCopyWith<$Res> get festival {
  
  return $HinduFestivalCopyWith<$Res>(_self.festival, (value) {
    return _then(_self.copyWith(festival: value));
  });
}
}


/// Adds pattern-matching-related methods to [FestivalOccurrence].
extension FestivalOccurrencePatterns on FestivalOccurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivalOccurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivalOccurrence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivalOccurrence value)  $default,){
final _that = this;
switch (_that) {
case _FestivalOccurrence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivalOccurrence value)?  $default,){
final _that = this;
switch (_that) {
case _FestivalOccurrence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HinduFestival festival,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivalOccurrence() when $default != null:
return $default(_that.festival,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HinduFestival festival,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _FestivalOccurrence():
return $default(_that.festival,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HinduFestival festival,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _FestivalOccurrence() when $default != null:
return $default(_that.festival,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FestivalOccurrence implements FestivalOccurrence {
  const _FestivalOccurrence({required this.festival, required this.date});
  factory _FestivalOccurrence.fromJson(Map<String, dynamic> json) => _$FestivalOccurrenceFromJson(json);

@override final  HinduFestival festival;
@override final  DateTime date;

/// Create a copy of FestivalOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalOccurrenceCopyWith<_FestivalOccurrence> get copyWith => __$FestivalOccurrenceCopyWithImpl<_FestivalOccurrence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FestivalOccurrenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivalOccurrence&&(identical(other.festival, festival) || other.festival == festival)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,festival,date);

@override
String toString() {
  return 'FestivalOccurrence(festival: $festival, date: $date)';
}


}

/// @nodoc
abstract mixin class _$FestivalOccurrenceCopyWith<$Res> implements $FestivalOccurrenceCopyWith<$Res> {
  factory _$FestivalOccurrenceCopyWith(_FestivalOccurrence value, $Res Function(_FestivalOccurrence) _then) = __$FestivalOccurrenceCopyWithImpl;
@override @useResult
$Res call({
 HinduFestival festival, DateTime date
});


@override $HinduFestivalCopyWith<$Res> get festival;

}
/// @nodoc
class __$FestivalOccurrenceCopyWithImpl<$Res>
    implements _$FestivalOccurrenceCopyWith<$Res> {
  __$FestivalOccurrenceCopyWithImpl(this._self, this._then);

  final _FestivalOccurrence _self;
  final $Res Function(_FestivalOccurrence) _then;

/// Create a copy of FestivalOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? festival = null,Object? date = null,}) {
  return _then(_FestivalOccurrence(
festival: null == festival ? _self.festival : festival // ignore: cast_nullable_to_non_nullable
as HinduFestival,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of FestivalOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HinduFestivalCopyWith<$Res> get festival {
  
  return $HinduFestivalCopyWith<$Res>(_self.festival, (value) {
    return _then(_self.copyWith(festival: value));
  });
}
}

// dart format on
