// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'puja_times.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeBand {

 DateTime get start; DateTime get end;
/// Create a copy of TimeBand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeBandCopyWith<TimeBand> get copyWith => _$TimeBandCopyWithImpl<TimeBand>(this as TimeBand, _$identity);

  /// Serializes this TimeBand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeBand&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'TimeBand(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $TimeBandCopyWith<$Res>  {
  factory $TimeBandCopyWith(TimeBand value, $Res Function(TimeBand) _then) = _$TimeBandCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class _$TimeBandCopyWithImpl<$Res>
    implements $TimeBandCopyWith<$Res> {
  _$TimeBandCopyWithImpl(this._self, this._then);

  final TimeBand _self;
  final $Res Function(TimeBand) _then;

/// Create a copy of TimeBand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeBand].
extension TimeBandPatterns on TimeBand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeBand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeBand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeBand value)  $default,){
final _that = this;
switch (_that) {
case _TimeBand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeBand value)?  $default,){
final _that = this;
switch (_that) {
case _TimeBand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeBand() when $default != null:
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end)  $default,) {final _that = this;
switch (_that) {
case _TimeBand():
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end)?  $default,) {final _that = this;
switch (_that) {
case _TimeBand() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeBand implements TimeBand {
  const _TimeBand({required this.start, required this.end});
  factory _TimeBand.fromJson(Map<String, dynamic> json) => _$TimeBandFromJson(json);

@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of TimeBand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeBandCopyWith<_TimeBand> get copyWith => __$TimeBandCopyWithImpl<_TimeBand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeBandToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeBand&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'TimeBand(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$TimeBandCopyWith<$Res> implements $TimeBandCopyWith<$Res> {
  factory _$TimeBandCopyWith(_TimeBand value, $Res Function(_TimeBand) _then) = __$TimeBandCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class __$TimeBandCopyWithImpl<$Res>
    implements _$TimeBandCopyWith<$Res> {
  __$TimeBandCopyWithImpl(this._self, this._then);

  final _TimeBand _self;
  final $Res Function(_TimeBand) _then;

/// Create a copy of TimeBand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_TimeBand(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SandhyaInfo {

 String get name;// 'pratah' | 'madhyahna' | 'sayam'
 String get nameSanskrit; String get nameEnglish; TimeBand get band; bool get isCurrent;
/// Create a copy of SandhyaInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SandhyaInfoCopyWith<SandhyaInfo> get copyWith => _$SandhyaInfoCopyWithImpl<SandhyaInfo>(this as SandhyaInfo, _$identity);

  /// Serializes this SandhyaInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SandhyaInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.band, band) || other.band == band)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nameSanskrit,nameEnglish,band,isCurrent);

@override
String toString() {
  return 'SandhyaInfo(name: $name, nameSanskrit: $nameSanskrit, nameEnglish: $nameEnglish, band: $band, isCurrent: $isCurrent)';
}


}

/// @nodoc
abstract mixin class $SandhyaInfoCopyWith<$Res>  {
  factory $SandhyaInfoCopyWith(SandhyaInfo value, $Res Function(SandhyaInfo) _then) = _$SandhyaInfoCopyWithImpl;
@useResult
$Res call({
 String name, String nameSanskrit, String nameEnglish, TimeBand band, bool isCurrent
});


$TimeBandCopyWith<$Res> get band;

}
/// @nodoc
class _$SandhyaInfoCopyWithImpl<$Res>
    implements $SandhyaInfoCopyWith<$Res> {
  _$SandhyaInfoCopyWithImpl(this._self, this._then);

  final SandhyaInfo _self;
  final $Res Function(SandhyaInfo) _then;

/// Create a copy of SandhyaInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? nameSanskrit = null,Object? nameEnglish = null,Object? band = null,Object? isCurrent = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as TimeBand,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SandhyaInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeBandCopyWith<$Res> get band {
  
  return $TimeBandCopyWith<$Res>(_self.band, (value) {
    return _then(_self.copyWith(band: value));
  });
}
}


/// Adds pattern-matching-related methods to [SandhyaInfo].
extension SandhyaInfoPatterns on SandhyaInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SandhyaInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SandhyaInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SandhyaInfo value)  $default,){
final _that = this;
switch (_that) {
case _SandhyaInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SandhyaInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SandhyaInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String nameSanskrit,  String nameEnglish,  TimeBand band,  bool isCurrent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SandhyaInfo() when $default != null:
return $default(_that.name,_that.nameSanskrit,_that.nameEnglish,_that.band,_that.isCurrent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String nameSanskrit,  String nameEnglish,  TimeBand band,  bool isCurrent)  $default,) {final _that = this;
switch (_that) {
case _SandhyaInfo():
return $default(_that.name,_that.nameSanskrit,_that.nameEnglish,_that.band,_that.isCurrent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String nameSanskrit,  String nameEnglish,  TimeBand band,  bool isCurrent)?  $default,) {final _that = this;
switch (_that) {
case _SandhyaInfo() when $default != null:
return $default(_that.name,_that.nameSanskrit,_that.nameEnglish,_that.band,_that.isCurrent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SandhyaInfo implements SandhyaInfo {
  const _SandhyaInfo({required this.name, required this.nameSanskrit, required this.nameEnglish, required this.band, required this.isCurrent});
  factory _SandhyaInfo.fromJson(Map<String, dynamic> json) => _$SandhyaInfoFromJson(json);

@override final  String name;
// 'pratah' | 'madhyahna' | 'sayam'
@override final  String nameSanskrit;
@override final  String nameEnglish;
@override final  TimeBand band;
@override final  bool isCurrent;

/// Create a copy of SandhyaInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SandhyaInfoCopyWith<_SandhyaInfo> get copyWith => __$SandhyaInfoCopyWithImpl<_SandhyaInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SandhyaInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SandhyaInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.band, band) || other.band == band)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nameSanskrit,nameEnglish,band,isCurrent);

@override
String toString() {
  return 'SandhyaInfo(name: $name, nameSanskrit: $nameSanskrit, nameEnglish: $nameEnglish, band: $band, isCurrent: $isCurrent)';
}


}

/// @nodoc
abstract mixin class _$SandhyaInfoCopyWith<$Res> implements $SandhyaInfoCopyWith<$Res> {
  factory _$SandhyaInfoCopyWith(_SandhyaInfo value, $Res Function(_SandhyaInfo) _then) = __$SandhyaInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String nameSanskrit, String nameEnglish, TimeBand band, bool isCurrent
});


@override $TimeBandCopyWith<$Res> get band;

}
/// @nodoc
class __$SandhyaInfoCopyWithImpl<$Res>
    implements _$SandhyaInfoCopyWith<$Res> {
  __$SandhyaInfoCopyWithImpl(this._self, this._then);

  final _SandhyaInfo _self;
  final $Res Function(_SandhyaInfo) _then;

/// Create a copy of SandhyaInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? nameSanskrit = null,Object? nameEnglish = null,Object? band = null,Object? isCurrent = null,}) {
  return _then(_SandhyaInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as TimeBand,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SandhyaInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeBandCopyWith<$Res> get band {
  
  return $TimeBandCopyWith<$Res>(_self.band, (value) {
    return _then(_self.copyWith(band: value));
  });
}
}


/// @nodoc
mixin _$NextSandhya {

 String get sandhya; int get startsInSeconds;
/// Create a copy of NextSandhya
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NextSandhyaCopyWith<NextSandhya> get copyWith => _$NextSandhyaCopyWithImpl<NextSandhya>(this as NextSandhya, _$identity);

  /// Serializes this NextSandhya to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextSandhya&&(identical(other.sandhya, sandhya) || other.sandhya == sandhya)&&(identical(other.startsInSeconds, startsInSeconds) || other.startsInSeconds == startsInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sandhya,startsInSeconds);

@override
String toString() {
  return 'NextSandhya(sandhya: $sandhya, startsInSeconds: $startsInSeconds)';
}


}

/// @nodoc
abstract mixin class $NextSandhyaCopyWith<$Res>  {
  factory $NextSandhyaCopyWith(NextSandhya value, $Res Function(NextSandhya) _then) = _$NextSandhyaCopyWithImpl;
@useResult
$Res call({
 String sandhya, int startsInSeconds
});




}
/// @nodoc
class _$NextSandhyaCopyWithImpl<$Res>
    implements $NextSandhyaCopyWith<$Res> {
  _$NextSandhyaCopyWithImpl(this._self, this._then);

  final NextSandhya _self;
  final $Res Function(NextSandhya) _then;

/// Create a copy of NextSandhya
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sandhya = null,Object? startsInSeconds = null,}) {
  return _then(_self.copyWith(
sandhya: null == sandhya ? _self.sandhya : sandhya // ignore: cast_nullable_to_non_nullable
as String,startsInSeconds: null == startsInSeconds ? _self.startsInSeconds : startsInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NextSandhya].
extension NextSandhyaPatterns on NextSandhya {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NextSandhya value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextSandhya() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NextSandhya value)  $default,){
final _that = this;
switch (_that) {
case _NextSandhya():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NextSandhya value)?  $default,){
final _that = this;
switch (_that) {
case _NextSandhya() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sandhya,  int startsInSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextSandhya() when $default != null:
return $default(_that.sandhya,_that.startsInSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sandhya,  int startsInSeconds)  $default,) {final _that = this;
switch (_that) {
case _NextSandhya():
return $default(_that.sandhya,_that.startsInSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sandhya,  int startsInSeconds)?  $default,) {final _that = this;
switch (_that) {
case _NextSandhya() when $default != null:
return $default(_that.sandhya,_that.startsInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NextSandhya implements NextSandhya {
  const _NextSandhya({required this.sandhya, required this.startsInSeconds});
  factory _NextSandhya.fromJson(Map<String, dynamic> json) => _$NextSandhyaFromJson(json);

@override final  String sandhya;
@override final  int startsInSeconds;

/// Create a copy of NextSandhya
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NextSandhyaCopyWith<_NextSandhya> get copyWith => __$NextSandhyaCopyWithImpl<_NextSandhya>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NextSandhyaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextSandhya&&(identical(other.sandhya, sandhya) || other.sandhya == sandhya)&&(identical(other.startsInSeconds, startsInSeconds) || other.startsInSeconds == startsInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sandhya,startsInSeconds);

@override
String toString() {
  return 'NextSandhya(sandhya: $sandhya, startsInSeconds: $startsInSeconds)';
}


}

/// @nodoc
abstract mixin class _$NextSandhyaCopyWith<$Res> implements $NextSandhyaCopyWith<$Res> {
  factory _$NextSandhyaCopyWith(_NextSandhya value, $Res Function(_NextSandhya) _then) = __$NextSandhyaCopyWithImpl;
@override @useResult
$Res call({
 String sandhya, int startsInSeconds
});




}
/// @nodoc
class __$NextSandhyaCopyWithImpl<$Res>
    implements _$NextSandhyaCopyWith<$Res> {
  __$NextSandhyaCopyWithImpl(this._self, this._then);

  final _NextSandhya _self;
  final $Res Function(_NextSandhya) _then;

/// Create a copy of NextSandhya
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sandhya = null,Object? startsInSeconds = null,}) {
  return _then(_NextSandhya(
sandhya: null == sandhya ? _self.sandhya : sandhya // ignore: cast_nullable_to_non_nullable
as String,startsInSeconds: null == startsInSeconds ? _self.startsInSeconds : startsInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PujaTimes {

 String get date;// 'yyyy-MM-dd'
 String get timezone; DateTime get sunrise; DateTime get sunset; DateTime get solarNoon; List<SandhyaInfo> get sandhyas; NextSandhya? get next;
/// Create a copy of PujaTimes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PujaTimesCopyWith<PujaTimes> get copyWith => _$PujaTimesCopyWithImpl<PujaTimes>(this as PujaTimes, _$identity);

  /// Serializes this PujaTimes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PujaTimes&&(identical(other.date, date) || other.date == date)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset)&&(identical(other.solarNoon, solarNoon) || other.solarNoon == solarNoon)&&const DeepCollectionEquality().equals(other.sandhyas, sandhyas)&&(identical(other.next, next) || other.next == next));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,timezone,sunrise,sunset,solarNoon,const DeepCollectionEquality().hash(sandhyas),next);

@override
String toString() {
  return 'PujaTimes(date: $date, timezone: $timezone, sunrise: $sunrise, sunset: $sunset, solarNoon: $solarNoon, sandhyas: $sandhyas, next: $next)';
}


}

/// @nodoc
abstract mixin class $PujaTimesCopyWith<$Res>  {
  factory $PujaTimesCopyWith(PujaTimes value, $Res Function(PujaTimes) _then) = _$PujaTimesCopyWithImpl;
@useResult
$Res call({
 String date, String timezone, DateTime sunrise, DateTime sunset, DateTime solarNoon, List<SandhyaInfo> sandhyas, NextSandhya? next
});


$NextSandhyaCopyWith<$Res>? get next;

}
/// @nodoc
class _$PujaTimesCopyWithImpl<$Res>
    implements $PujaTimesCopyWith<$Res> {
  _$PujaTimesCopyWithImpl(this._self, this._then);

  final PujaTimes _self;
  final $Res Function(PujaTimes) _then;

/// Create a copy of PujaTimes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? timezone = null,Object? sunrise = null,Object? sunset = null,Object? solarNoon = null,Object? sandhyas = null,Object? next = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,solarNoon: null == solarNoon ? _self.solarNoon : solarNoon // ignore: cast_nullable_to_non_nullable
as DateTime,sandhyas: null == sandhyas ? _self.sandhyas : sandhyas // ignore: cast_nullable_to_non_nullable
as List<SandhyaInfo>,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as NextSandhya?,
  ));
}
/// Create a copy of PujaTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextSandhyaCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $NextSandhyaCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}


/// Adds pattern-matching-related methods to [PujaTimes].
extension PujaTimesPatterns on PujaTimes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PujaTimes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PujaTimes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PujaTimes value)  $default,){
final _that = this;
switch (_that) {
case _PujaTimes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PujaTimes value)?  $default,){
final _that = this;
switch (_that) {
case _PujaTimes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String timezone,  DateTime sunrise,  DateTime sunset,  DateTime solarNoon,  List<SandhyaInfo> sandhyas,  NextSandhya? next)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PujaTimes() when $default != null:
return $default(_that.date,_that.timezone,_that.sunrise,_that.sunset,_that.solarNoon,_that.sandhyas,_that.next);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String timezone,  DateTime sunrise,  DateTime sunset,  DateTime solarNoon,  List<SandhyaInfo> sandhyas,  NextSandhya? next)  $default,) {final _that = this;
switch (_that) {
case _PujaTimes():
return $default(_that.date,_that.timezone,_that.sunrise,_that.sunset,_that.solarNoon,_that.sandhyas,_that.next);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String timezone,  DateTime sunrise,  DateTime sunset,  DateTime solarNoon,  List<SandhyaInfo> sandhyas,  NextSandhya? next)?  $default,) {final _that = this;
switch (_that) {
case _PujaTimes() when $default != null:
return $default(_that.date,_that.timezone,_that.sunrise,_that.sunset,_that.solarNoon,_that.sandhyas,_that.next);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PujaTimes implements PujaTimes {
  const _PujaTimes({required this.date, required this.timezone, required this.sunrise, required this.sunset, required this.solarNoon, final  List<SandhyaInfo> sandhyas = const <SandhyaInfo>[], this.next}): _sandhyas = sandhyas;
  factory _PujaTimes.fromJson(Map<String, dynamic> json) => _$PujaTimesFromJson(json);

@override final  String date;
// 'yyyy-MM-dd'
@override final  String timezone;
@override final  DateTime sunrise;
@override final  DateTime sunset;
@override final  DateTime solarNoon;
 final  List<SandhyaInfo> _sandhyas;
@override@JsonKey() List<SandhyaInfo> get sandhyas {
  if (_sandhyas is EqualUnmodifiableListView) return _sandhyas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sandhyas);
}

@override final  NextSandhya? next;

/// Create a copy of PujaTimes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PujaTimesCopyWith<_PujaTimes> get copyWith => __$PujaTimesCopyWithImpl<_PujaTimes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PujaTimesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PujaTimes&&(identical(other.date, date) || other.date == date)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset)&&(identical(other.solarNoon, solarNoon) || other.solarNoon == solarNoon)&&const DeepCollectionEquality().equals(other._sandhyas, _sandhyas)&&(identical(other.next, next) || other.next == next));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,timezone,sunrise,sunset,solarNoon,const DeepCollectionEquality().hash(_sandhyas),next);

@override
String toString() {
  return 'PujaTimes(date: $date, timezone: $timezone, sunrise: $sunrise, sunset: $sunset, solarNoon: $solarNoon, sandhyas: $sandhyas, next: $next)';
}


}

/// @nodoc
abstract mixin class _$PujaTimesCopyWith<$Res> implements $PujaTimesCopyWith<$Res> {
  factory _$PujaTimesCopyWith(_PujaTimes value, $Res Function(_PujaTimes) _then) = __$PujaTimesCopyWithImpl;
@override @useResult
$Res call({
 String date, String timezone, DateTime sunrise, DateTime sunset, DateTime solarNoon, List<SandhyaInfo> sandhyas, NextSandhya? next
});


@override $NextSandhyaCopyWith<$Res>? get next;

}
/// @nodoc
class __$PujaTimesCopyWithImpl<$Res>
    implements _$PujaTimesCopyWith<$Res> {
  __$PujaTimesCopyWithImpl(this._self, this._then);

  final _PujaTimes _self;
  final $Res Function(_PujaTimes) _then;

/// Create a copy of PujaTimes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? timezone = null,Object? sunrise = null,Object? sunset = null,Object? solarNoon = null,Object? sandhyas = null,Object? next = freezed,}) {
  return _then(_PujaTimes(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,solarNoon: null == solarNoon ? _self.solarNoon : solarNoon // ignore: cast_nullable_to_non_nullable
as DateTime,sandhyas: null == sandhyas ? _self._sandhyas : sandhyas // ignore: cast_nullable_to_non_nullable
as List<SandhyaInfo>,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as NextSandhya?,
  ));
}

/// Create a copy of PujaTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextSandhyaCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $NextSandhyaCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}

// dart format on
