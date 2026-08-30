// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panchang_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeWindow {

 DateTime get start; DateTime get end;
/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<TimeWindow> get copyWith => _$TimeWindowCopyWithImpl<TimeWindow>(this as TimeWindow, _$identity);

  /// Serializes this TimeWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeWindow&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'TimeWindow(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $TimeWindowCopyWith<$Res>  {
  factory $TimeWindowCopyWith(TimeWindow value, $Res Function(TimeWindow) _then) = _$TimeWindowCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class _$TimeWindowCopyWithImpl<$Res>
    implements $TimeWindowCopyWith<$Res> {
  _$TimeWindowCopyWithImpl(this._self, this._then);

  final TimeWindow _self;
  final $Res Function(TimeWindow) _then;

/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeWindow].
extension TimeWindowPatterns on TimeWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeWindow value)  $default,){
final _that = this;
switch (_that) {
case _TimeWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeWindow value)?  $default,){
final _that = this;
switch (_that) {
case _TimeWindow() when $default != null:
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
case _TimeWindow() when $default != null:
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
case _TimeWindow():
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
case _TimeWindow() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeWindow implements TimeWindow {
  const _TimeWindow({required this.start, required this.end});
  factory _TimeWindow.fromJson(Map<String, dynamic> json) => _$TimeWindowFromJson(json);

@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeWindowCopyWith<_TimeWindow> get copyWith => __$TimeWindowCopyWithImpl<_TimeWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeWindow&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'TimeWindow(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$TimeWindowCopyWith<$Res> implements $TimeWindowCopyWith<$Res> {
  factory _$TimeWindowCopyWith(_TimeWindow value, $Res Function(_TimeWindow) _then) = __$TimeWindowCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class __$TimeWindowCopyWithImpl<$Res>
    implements _$TimeWindowCopyWith<$Res> {
  __$TimeWindowCopyWithImpl(this._self, this._then);

  final _TimeWindow _self;
  final $Res Function(_TimeWindow) _then;

/// Create a copy of TimeWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_TimeWindow(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TithiInfo {

 int get number; String get name; String get nameSanskrit; String get paksha;// 'shukla' | 'krishna'
 DateTime? get endTime;
/// Create a copy of TithiInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TithiInfoCopyWith<TithiInfo> get copyWith => _$TithiInfoCopyWithImpl<TithiInfo>(this as TithiInfo, _$identity);

  /// Serializes this TithiInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TithiInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.paksha, paksha) || other.paksha == paksha)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit,paksha,endTime);

@override
String toString() {
  return 'TithiInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit, paksha: $paksha, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $TithiInfoCopyWith<$Res>  {
  factory $TithiInfoCopyWith(TithiInfo value, $Res Function(TithiInfo) _then) = _$TithiInfoCopyWithImpl;
@useResult
$Res call({
 int number, String name, String nameSanskrit, String paksha, DateTime? endTime
});




}
/// @nodoc
class _$TithiInfoCopyWithImpl<$Res>
    implements $TithiInfoCopyWith<$Res> {
  _$TithiInfoCopyWithImpl(this._self, this._then);

  final TithiInfo _self;
  final $Res Function(TithiInfo) _then;

/// Create a copy of TithiInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,Object? paksha = null,Object? endTime = freezed,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,paksha: null == paksha ? _self.paksha : paksha // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TithiInfo].
extension TithiInfoPatterns on TithiInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TithiInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TithiInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TithiInfo value)  $default,){
final _that = this;
switch (_that) {
case _TithiInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TithiInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TithiInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit,  String paksha,  DateTime? endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TithiInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit,_that.paksha,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit,  String paksha,  DateTime? endTime)  $default,) {final _that = this;
switch (_that) {
case _TithiInfo():
return $default(_that.number,_that.name,_that.nameSanskrit,_that.paksha,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String name,  String nameSanskrit,  String paksha,  DateTime? endTime)?  $default,) {final _that = this;
switch (_that) {
case _TithiInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit,_that.paksha,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TithiInfo implements TithiInfo {
  const _TithiInfo({required this.number, required this.name, required this.nameSanskrit, required this.paksha, this.endTime});
  factory _TithiInfo.fromJson(Map<String, dynamic> json) => _$TithiInfoFromJson(json);

@override final  int number;
@override final  String name;
@override final  String nameSanskrit;
@override final  String paksha;
// 'shukla' | 'krishna'
@override final  DateTime? endTime;

/// Create a copy of TithiInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TithiInfoCopyWith<_TithiInfo> get copyWith => __$TithiInfoCopyWithImpl<_TithiInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TithiInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TithiInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.paksha, paksha) || other.paksha == paksha)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit,paksha,endTime);

@override
String toString() {
  return 'TithiInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit, paksha: $paksha, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$TithiInfoCopyWith<$Res> implements $TithiInfoCopyWith<$Res> {
  factory _$TithiInfoCopyWith(_TithiInfo value, $Res Function(_TithiInfo) _then) = __$TithiInfoCopyWithImpl;
@override @useResult
$Res call({
 int number, String name, String nameSanskrit, String paksha, DateTime? endTime
});




}
/// @nodoc
class __$TithiInfoCopyWithImpl<$Res>
    implements _$TithiInfoCopyWith<$Res> {
  __$TithiInfoCopyWithImpl(this._self, this._then);

  final _TithiInfo _self;
  final $Res Function(_TithiInfo) _then;

/// Create a copy of TithiInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,Object? paksha = null,Object? endTime = freezed,}) {
  return _then(_TithiInfo(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,paksha: null == paksha ? _self.paksha : paksha // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$NakshatraInfo {

 int get number; String get name; String get nameSanskrit; String get deity; DateTime? get endTime;
/// Create a copy of NakshatraInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NakshatraInfoCopyWith<NakshatraInfo> get copyWith => _$NakshatraInfoCopyWithImpl<NakshatraInfo>(this as NakshatraInfo, _$identity);

  /// Serializes this NakshatraInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NakshatraInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.deity, deity) || other.deity == deity)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit,deity,endTime);

@override
String toString() {
  return 'NakshatraInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit, deity: $deity, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $NakshatraInfoCopyWith<$Res>  {
  factory $NakshatraInfoCopyWith(NakshatraInfo value, $Res Function(NakshatraInfo) _then) = _$NakshatraInfoCopyWithImpl;
@useResult
$Res call({
 int number, String name, String nameSanskrit, String deity, DateTime? endTime
});




}
/// @nodoc
class _$NakshatraInfoCopyWithImpl<$Res>
    implements $NakshatraInfoCopyWith<$Res> {
  _$NakshatraInfoCopyWithImpl(this._self, this._then);

  final NakshatraInfo _self;
  final $Res Function(NakshatraInfo) _then;

/// Create a copy of NakshatraInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,Object? deity = null,Object? endTime = freezed,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,deity: null == deity ? _self.deity : deity // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NakshatraInfo].
extension NakshatraInfoPatterns on NakshatraInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NakshatraInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NakshatraInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NakshatraInfo value)  $default,){
final _that = this;
switch (_that) {
case _NakshatraInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NakshatraInfo value)?  $default,){
final _that = this;
switch (_that) {
case _NakshatraInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit,  String deity,  DateTime? endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NakshatraInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit,_that.deity,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit,  String deity,  DateTime? endTime)  $default,) {final _that = this;
switch (_that) {
case _NakshatraInfo():
return $default(_that.number,_that.name,_that.nameSanskrit,_that.deity,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String name,  String nameSanskrit,  String deity,  DateTime? endTime)?  $default,) {final _that = this;
switch (_that) {
case _NakshatraInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit,_that.deity,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NakshatraInfo implements NakshatraInfo {
  const _NakshatraInfo({required this.number, required this.name, required this.nameSanskrit, required this.deity, this.endTime});
  factory _NakshatraInfo.fromJson(Map<String, dynamic> json) => _$NakshatraInfoFromJson(json);

@override final  int number;
@override final  String name;
@override final  String nameSanskrit;
@override final  String deity;
@override final  DateTime? endTime;

/// Create a copy of NakshatraInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NakshatraInfoCopyWith<_NakshatraInfo> get copyWith => __$NakshatraInfoCopyWithImpl<_NakshatraInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NakshatraInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NakshatraInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.deity, deity) || other.deity == deity)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit,deity,endTime);

@override
String toString() {
  return 'NakshatraInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit, deity: $deity, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$NakshatraInfoCopyWith<$Res> implements $NakshatraInfoCopyWith<$Res> {
  factory _$NakshatraInfoCopyWith(_NakshatraInfo value, $Res Function(_NakshatraInfo) _then) = __$NakshatraInfoCopyWithImpl;
@override @useResult
$Res call({
 int number, String name, String nameSanskrit, String deity, DateTime? endTime
});




}
/// @nodoc
class __$NakshatraInfoCopyWithImpl<$Res>
    implements _$NakshatraInfoCopyWith<$Res> {
  __$NakshatraInfoCopyWithImpl(this._self, this._then);

  final _NakshatraInfo _self;
  final $Res Function(_NakshatraInfo) _then;

/// Create a copy of NakshatraInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,Object? deity = null,Object? endTime = freezed,}) {
  return _then(_NakshatraInfo(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,deity: null == deity ? _self.deity : deity // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$YogaInfo {

 int get number; String get name; String get nameSanskrit;
/// Create a copy of YogaInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YogaInfoCopyWith<YogaInfo> get copyWith => _$YogaInfoCopyWithImpl<YogaInfo>(this as YogaInfo, _$identity);

  /// Serializes this YogaInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YogaInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit);

@override
String toString() {
  return 'YogaInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit)';
}


}

/// @nodoc
abstract mixin class $YogaInfoCopyWith<$Res>  {
  factory $YogaInfoCopyWith(YogaInfo value, $Res Function(YogaInfo) _then) = _$YogaInfoCopyWithImpl;
@useResult
$Res call({
 int number, String name, String nameSanskrit
});




}
/// @nodoc
class _$YogaInfoCopyWithImpl<$Res>
    implements $YogaInfoCopyWith<$Res> {
  _$YogaInfoCopyWithImpl(this._self, this._then);

  final YogaInfo _self;
  final $Res Function(YogaInfo) _then;

/// Create a copy of YogaInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [YogaInfo].
extension YogaInfoPatterns on YogaInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YogaInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YogaInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YogaInfo value)  $default,){
final _that = this;
switch (_that) {
case _YogaInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YogaInfo value)?  $default,){
final _that = this;
switch (_that) {
case _YogaInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YogaInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit)  $default,) {final _that = this;
switch (_that) {
case _YogaInfo():
return $default(_that.number,_that.name,_that.nameSanskrit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String name,  String nameSanskrit)?  $default,) {final _that = this;
switch (_that) {
case _YogaInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YogaInfo implements YogaInfo {
  const _YogaInfo({required this.number, required this.name, required this.nameSanskrit});
  factory _YogaInfo.fromJson(Map<String, dynamic> json) => _$YogaInfoFromJson(json);

@override final  int number;
@override final  String name;
@override final  String nameSanskrit;

/// Create a copy of YogaInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YogaInfoCopyWith<_YogaInfo> get copyWith => __$YogaInfoCopyWithImpl<_YogaInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YogaInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YogaInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit);

@override
String toString() {
  return 'YogaInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit)';
}


}

/// @nodoc
abstract mixin class _$YogaInfoCopyWith<$Res> implements $YogaInfoCopyWith<$Res> {
  factory _$YogaInfoCopyWith(_YogaInfo value, $Res Function(_YogaInfo) _then) = __$YogaInfoCopyWithImpl;
@override @useResult
$Res call({
 int number, String name, String nameSanskrit
});




}
/// @nodoc
class __$YogaInfoCopyWithImpl<$Res>
    implements _$YogaInfoCopyWith<$Res> {
  __$YogaInfoCopyWithImpl(this._self, this._then);

  final _YogaInfo _self;
  final $Res Function(_YogaInfo) _then;

/// Create a copy of YogaInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,}) {
  return _then(_YogaInfo(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KaranaInfo {

 int get number; String get name; String get nameSanskrit; bool get isAuspicious;
/// Create a copy of KaranaInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KaranaInfoCopyWith<KaranaInfo> get copyWith => _$KaranaInfoCopyWithImpl<KaranaInfo>(this as KaranaInfo, _$identity);

  /// Serializes this KaranaInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KaranaInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.isAuspicious, isAuspicious) || other.isAuspicious == isAuspicious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit,isAuspicious);

@override
String toString() {
  return 'KaranaInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit, isAuspicious: $isAuspicious)';
}


}

/// @nodoc
abstract mixin class $KaranaInfoCopyWith<$Res>  {
  factory $KaranaInfoCopyWith(KaranaInfo value, $Res Function(KaranaInfo) _then) = _$KaranaInfoCopyWithImpl;
@useResult
$Res call({
 int number, String name, String nameSanskrit, bool isAuspicious
});




}
/// @nodoc
class _$KaranaInfoCopyWithImpl<$Res>
    implements $KaranaInfoCopyWith<$Res> {
  _$KaranaInfoCopyWithImpl(this._self, this._then);

  final KaranaInfo _self;
  final $Res Function(KaranaInfo) _then;

/// Create a copy of KaranaInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,Object? isAuspicious = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,isAuspicious: null == isAuspicious ? _self.isAuspicious : isAuspicious // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [KaranaInfo].
extension KaranaInfoPatterns on KaranaInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KaranaInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KaranaInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KaranaInfo value)  $default,){
final _that = this;
switch (_that) {
case _KaranaInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KaranaInfo value)?  $default,){
final _that = this;
switch (_that) {
case _KaranaInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit,  bool isAuspicious)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KaranaInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit,_that.isAuspicious);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit,  bool isAuspicious)  $default,) {final _that = this;
switch (_that) {
case _KaranaInfo():
return $default(_that.number,_that.name,_that.nameSanskrit,_that.isAuspicious);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String name,  String nameSanskrit,  bool isAuspicious)?  $default,) {final _that = this;
switch (_that) {
case _KaranaInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit,_that.isAuspicious);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KaranaInfo implements KaranaInfo {
  const _KaranaInfo({required this.number, required this.name, required this.nameSanskrit, required this.isAuspicious});
  factory _KaranaInfo.fromJson(Map<String, dynamic> json) => _$KaranaInfoFromJson(json);

@override final  int number;
@override final  String name;
@override final  String nameSanskrit;
@override final  bool isAuspicious;

/// Create a copy of KaranaInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KaranaInfoCopyWith<_KaranaInfo> get copyWith => __$KaranaInfoCopyWithImpl<_KaranaInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KaranaInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KaranaInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit)&&(identical(other.isAuspicious, isAuspicious) || other.isAuspicious == isAuspicious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit,isAuspicious);

@override
String toString() {
  return 'KaranaInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit, isAuspicious: $isAuspicious)';
}


}

/// @nodoc
abstract mixin class _$KaranaInfoCopyWith<$Res> implements $KaranaInfoCopyWith<$Res> {
  factory _$KaranaInfoCopyWith(_KaranaInfo value, $Res Function(_KaranaInfo) _then) = __$KaranaInfoCopyWithImpl;
@override @useResult
$Res call({
 int number, String name, String nameSanskrit, bool isAuspicious
});




}
/// @nodoc
class __$KaranaInfoCopyWithImpl<$Res>
    implements _$KaranaInfoCopyWith<$Res> {
  __$KaranaInfoCopyWithImpl(this._self, this._then);

  final _KaranaInfo _self;
  final $Res Function(_KaranaInfo) _then;

/// Create a copy of KaranaInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,Object? isAuspicious = null,}) {
  return _then(_KaranaInfo(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,isAuspicious: null == isAuspicious ? _self.isAuspicious : isAuspicious // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$VaaraInfo {

 int get number; String get name; String get nameSanskrit;
/// Create a copy of VaaraInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaaraInfoCopyWith<VaaraInfo> get copyWith => _$VaaraInfoCopyWithImpl<VaaraInfo>(this as VaaraInfo, _$identity);

  /// Serializes this VaaraInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaaraInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit);

@override
String toString() {
  return 'VaaraInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit)';
}


}

/// @nodoc
abstract mixin class $VaaraInfoCopyWith<$Res>  {
  factory $VaaraInfoCopyWith(VaaraInfo value, $Res Function(VaaraInfo) _then) = _$VaaraInfoCopyWithImpl;
@useResult
$Res call({
 int number, String name, String nameSanskrit
});




}
/// @nodoc
class _$VaaraInfoCopyWithImpl<$Res>
    implements $VaaraInfoCopyWith<$Res> {
  _$VaaraInfoCopyWithImpl(this._self, this._then);

  final VaaraInfo _self;
  final $Res Function(VaaraInfo) _then;

/// Create a copy of VaaraInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VaaraInfo].
extension VaaraInfoPatterns on VaaraInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaaraInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaaraInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaaraInfo value)  $default,){
final _that = this;
switch (_that) {
case _VaaraInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaaraInfo value)?  $default,){
final _that = this;
switch (_that) {
case _VaaraInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaaraInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String name,  String nameSanskrit)  $default,) {final _that = this;
switch (_that) {
case _VaaraInfo():
return $default(_that.number,_that.name,_that.nameSanskrit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String name,  String nameSanskrit)?  $default,) {final _that = this;
switch (_that) {
case _VaaraInfo() when $default != null:
return $default(_that.number,_that.name,_that.nameSanskrit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaaraInfo implements VaaraInfo {
  const _VaaraInfo({required this.number, required this.name, required this.nameSanskrit});
  factory _VaaraInfo.fromJson(Map<String, dynamic> json) => _$VaaraInfoFromJson(json);

@override final  int number;
@override final  String name;
@override final  String nameSanskrit;

/// Create a copy of VaaraInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaaraInfoCopyWith<_VaaraInfo> get copyWith => __$VaaraInfoCopyWithImpl<_VaaraInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaaraInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaaraInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,name,nameSanskrit);

@override
String toString() {
  return 'VaaraInfo(number: $number, name: $name, nameSanskrit: $nameSanskrit)';
}


}

/// @nodoc
abstract mixin class _$VaaraInfoCopyWith<$Res> implements $VaaraInfoCopyWith<$Res> {
  factory _$VaaraInfoCopyWith(_VaaraInfo value, $Res Function(_VaaraInfo) _then) = __$VaaraInfoCopyWithImpl;
@override @useResult
$Res call({
 int number, String name, String nameSanskrit
});




}
/// @nodoc
class __$VaaraInfoCopyWithImpl<$Res>
    implements _$VaaraInfoCopyWith<$Res> {
  __$VaaraInfoCopyWithImpl(this._self, this._then);

  final _VaaraInfo _self;
  final $Res Function(_VaaraInfo) _then;

/// Create a copy of VaaraInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? name = null,Object? nameSanskrit = null,}) {
  return _then(_VaaraInfo(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: null == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AuspiciousTimes {

 TimeWindow get brahmaMuhurta; TimeWindow? get abhijitMuhurta; TimeWindow get rahuKaal; TimeWindow get yamagandam; TimeWindow get gulika;
/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuspiciousTimesCopyWith<AuspiciousTimes> get copyWith => _$AuspiciousTimesCopyWithImpl<AuspiciousTimes>(this as AuspiciousTimes, _$identity);

  /// Serializes this AuspiciousTimes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuspiciousTimes&&(identical(other.brahmaMuhurta, brahmaMuhurta) || other.brahmaMuhurta == brahmaMuhurta)&&(identical(other.abhijitMuhurta, abhijitMuhurta) || other.abhijitMuhurta == abhijitMuhurta)&&(identical(other.rahuKaal, rahuKaal) || other.rahuKaal == rahuKaal)&&(identical(other.yamagandam, yamagandam) || other.yamagandam == yamagandam)&&(identical(other.gulika, gulika) || other.gulika == gulika));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,brahmaMuhurta,abhijitMuhurta,rahuKaal,yamagandam,gulika);

@override
String toString() {
  return 'AuspiciousTimes(brahmaMuhurta: $brahmaMuhurta, abhijitMuhurta: $abhijitMuhurta, rahuKaal: $rahuKaal, yamagandam: $yamagandam, gulika: $gulika)';
}


}

/// @nodoc
abstract mixin class $AuspiciousTimesCopyWith<$Res>  {
  factory $AuspiciousTimesCopyWith(AuspiciousTimes value, $Res Function(AuspiciousTimes) _then) = _$AuspiciousTimesCopyWithImpl;
@useResult
$Res call({
 TimeWindow brahmaMuhurta, TimeWindow? abhijitMuhurta, TimeWindow rahuKaal, TimeWindow yamagandam, TimeWindow gulika
});


$TimeWindowCopyWith<$Res> get brahmaMuhurta;$TimeWindowCopyWith<$Res>? get abhijitMuhurta;$TimeWindowCopyWith<$Res> get rahuKaal;$TimeWindowCopyWith<$Res> get yamagandam;$TimeWindowCopyWith<$Res> get gulika;

}
/// @nodoc
class _$AuspiciousTimesCopyWithImpl<$Res>
    implements $AuspiciousTimesCopyWith<$Res> {
  _$AuspiciousTimesCopyWithImpl(this._self, this._then);

  final AuspiciousTimes _self;
  final $Res Function(AuspiciousTimes) _then;

/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brahmaMuhurta = null,Object? abhijitMuhurta = freezed,Object? rahuKaal = null,Object? yamagandam = null,Object? gulika = null,}) {
  return _then(_self.copyWith(
brahmaMuhurta: null == brahmaMuhurta ? _self.brahmaMuhurta : brahmaMuhurta // ignore: cast_nullable_to_non_nullable
as TimeWindow,abhijitMuhurta: freezed == abhijitMuhurta ? _self.abhijitMuhurta : abhijitMuhurta // ignore: cast_nullable_to_non_nullable
as TimeWindow?,rahuKaal: null == rahuKaal ? _self.rahuKaal : rahuKaal // ignore: cast_nullable_to_non_nullable
as TimeWindow,yamagandam: null == yamagandam ? _self.yamagandam : yamagandam // ignore: cast_nullable_to_non_nullable
as TimeWindow,gulika: null == gulika ? _self.gulika : gulika // ignore: cast_nullable_to_non_nullable
as TimeWindow,
  ));
}
/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get brahmaMuhurta {
  
  return $TimeWindowCopyWith<$Res>(_self.brahmaMuhurta, (value) {
    return _then(_self.copyWith(brahmaMuhurta: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res>? get abhijitMuhurta {
    if (_self.abhijitMuhurta == null) {
    return null;
  }

  return $TimeWindowCopyWith<$Res>(_self.abhijitMuhurta!, (value) {
    return _then(_self.copyWith(abhijitMuhurta: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get rahuKaal {
  
  return $TimeWindowCopyWith<$Res>(_self.rahuKaal, (value) {
    return _then(_self.copyWith(rahuKaal: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get yamagandam {
  
  return $TimeWindowCopyWith<$Res>(_self.yamagandam, (value) {
    return _then(_self.copyWith(yamagandam: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get gulika {
  
  return $TimeWindowCopyWith<$Res>(_self.gulika, (value) {
    return _then(_self.copyWith(gulika: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuspiciousTimes].
extension AuspiciousTimesPatterns on AuspiciousTimes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuspiciousTimes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuspiciousTimes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuspiciousTimes value)  $default,){
final _that = this;
switch (_that) {
case _AuspiciousTimes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuspiciousTimes value)?  $default,){
final _that = this;
switch (_that) {
case _AuspiciousTimes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimeWindow brahmaMuhurta,  TimeWindow? abhijitMuhurta,  TimeWindow rahuKaal,  TimeWindow yamagandam,  TimeWindow gulika)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuspiciousTimes() when $default != null:
return $default(_that.brahmaMuhurta,_that.abhijitMuhurta,_that.rahuKaal,_that.yamagandam,_that.gulika);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimeWindow brahmaMuhurta,  TimeWindow? abhijitMuhurta,  TimeWindow rahuKaal,  TimeWindow yamagandam,  TimeWindow gulika)  $default,) {final _that = this;
switch (_that) {
case _AuspiciousTimes():
return $default(_that.brahmaMuhurta,_that.abhijitMuhurta,_that.rahuKaal,_that.yamagandam,_that.gulika);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimeWindow brahmaMuhurta,  TimeWindow? abhijitMuhurta,  TimeWindow rahuKaal,  TimeWindow yamagandam,  TimeWindow gulika)?  $default,) {final _that = this;
switch (_that) {
case _AuspiciousTimes() when $default != null:
return $default(_that.brahmaMuhurta,_that.abhijitMuhurta,_that.rahuKaal,_that.yamagandam,_that.gulika);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuspiciousTimes implements AuspiciousTimes {
  const _AuspiciousTimes({required this.brahmaMuhurta, this.abhijitMuhurta, required this.rahuKaal, required this.yamagandam, required this.gulika});
  factory _AuspiciousTimes.fromJson(Map<String, dynamic> json) => _$AuspiciousTimesFromJson(json);

@override final  TimeWindow brahmaMuhurta;
@override final  TimeWindow? abhijitMuhurta;
@override final  TimeWindow rahuKaal;
@override final  TimeWindow yamagandam;
@override final  TimeWindow gulika;

/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuspiciousTimesCopyWith<_AuspiciousTimes> get copyWith => __$AuspiciousTimesCopyWithImpl<_AuspiciousTimes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuspiciousTimesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuspiciousTimes&&(identical(other.brahmaMuhurta, brahmaMuhurta) || other.brahmaMuhurta == brahmaMuhurta)&&(identical(other.abhijitMuhurta, abhijitMuhurta) || other.abhijitMuhurta == abhijitMuhurta)&&(identical(other.rahuKaal, rahuKaal) || other.rahuKaal == rahuKaal)&&(identical(other.yamagandam, yamagandam) || other.yamagandam == yamagandam)&&(identical(other.gulika, gulika) || other.gulika == gulika));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,brahmaMuhurta,abhijitMuhurta,rahuKaal,yamagandam,gulika);

@override
String toString() {
  return 'AuspiciousTimes(brahmaMuhurta: $brahmaMuhurta, abhijitMuhurta: $abhijitMuhurta, rahuKaal: $rahuKaal, yamagandam: $yamagandam, gulika: $gulika)';
}


}

/// @nodoc
abstract mixin class _$AuspiciousTimesCopyWith<$Res> implements $AuspiciousTimesCopyWith<$Res> {
  factory _$AuspiciousTimesCopyWith(_AuspiciousTimes value, $Res Function(_AuspiciousTimes) _then) = __$AuspiciousTimesCopyWithImpl;
@override @useResult
$Res call({
 TimeWindow brahmaMuhurta, TimeWindow? abhijitMuhurta, TimeWindow rahuKaal, TimeWindow yamagandam, TimeWindow gulika
});


@override $TimeWindowCopyWith<$Res> get brahmaMuhurta;@override $TimeWindowCopyWith<$Res>? get abhijitMuhurta;@override $TimeWindowCopyWith<$Res> get rahuKaal;@override $TimeWindowCopyWith<$Res> get yamagandam;@override $TimeWindowCopyWith<$Res> get gulika;

}
/// @nodoc
class __$AuspiciousTimesCopyWithImpl<$Res>
    implements _$AuspiciousTimesCopyWith<$Res> {
  __$AuspiciousTimesCopyWithImpl(this._self, this._then);

  final _AuspiciousTimes _self;
  final $Res Function(_AuspiciousTimes) _then;

/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brahmaMuhurta = null,Object? abhijitMuhurta = freezed,Object? rahuKaal = null,Object? yamagandam = null,Object? gulika = null,}) {
  return _then(_AuspiciousTimes(
brahmaMuhurta: null == brahmaMuhurta ? _self.brahmaMuhurta : brahmaMuhurta // ignore: cast_nullable_to_non_nullable
as TimeWindow,abhijitMuhurta: freezed == abhijitMuhurta ? _self.abhijitMuhurta : abhijitMuhurta // ignore: cast_nullable_to_non_nullable
as TimeWindow?,rahuKaal: null == rahuKaal ? _self.rahuKaal : rahuKaal // ignore: cast_nullable_to_non_nullable
as TimeWindow,yamagandam: null == yamagandam ? _self.yamagandam : yamagandam // ignore: cast_nullable_to_non_nullable
as TimeWindow,gulika: null == gulika ? _self.gulika : gulika // ignore: cast_nullable_to_non_nullable
as TimeWindow,
  ));
}

/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get brahmaMuhurta {
  
  return $TimeWindowCopyWith<$Res>(_self.brahmaMuhurta, (value) {
    return _then(_self.copyWith(brahmaMuhurta: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res>? get abhijitMuhurta {
    if (_self.abhijitMuhurta == null) {
    return null;
  }

  return $TimeWindowCopyWith<$Res>(_self.abhijitMuhurta!, (value) {
    return _then(_self.copyWith(abhijitMuhurta: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get rahuKaal {
  
  return $TimeWindowCopyWith<$Res>(_self.rahuKaal, (value) {
    return _then(_self.copyWith(rahuKaal: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get yamagandam {
  
  return $TimeWindowCopyWith<$Res>(_self.yamagandam, (value) {
    return _then(_self.copyWith(yamagandam: value));
  });
}/// Create a copy of AuspiciousTimes
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeWindowCopyWith<$Res> get gulika {
  
  return $TimeWindowCopyWith<$Res>(_self.gulika, (value) {
    return _then(_self.copyWith(gulika: value));
  });
}
}


/// @nodoc
mixin _$FestivalSummary {

 String get slug; String get nameEnglish; String? get nameSanskrit;
/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalSummaryCopyWith<FestivalSummary> get copyWith => _$FestivalSummaryCopyWithImpl<FestivalSummary>(this as FestivalSummary, _$identity);

  /// Serializes this FestivalSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivalSummary&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nameEnglish,nameSanskrit);

@override
String toString() {
  return 'FestivalSummary(slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit)';
}


}

/// @nodoc
abstract mixin class $FestivalSummaryCopyWith<$Res>  {
  factory $FestivalSummaryCopyWith(FestivalSummary value, $Res Function(FestivalSummary) _then) = _$FestivalSummaryCopyWithImpl;
@useResult
$Res call({
 String slug, String nameEnglish, String? nameSanskrit
});




}
/// @nodoc
class _$FestivalSummaryCopyWithImpl<$Res>
    implements $FestivalSummaryCopyWith<$Res> {
  _$FestivalSummaryCopyWithImpl(this._self, this._then);

  final FestivalSummary _self;
  final $Res Function(FestivalSummary) _then;

/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = freezed,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FestivalSummary].
extension FestivalSummaryPatterns on FestivalSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivalSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivalSummary value)  $default,){
final _that = this;
switch (_that) {
case _FestivalSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivalSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String nameEnglish,  String? nameSanskrit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
return $default(_that.slug,_that.nameEnglish,_that.nameSanskrit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String nameEnglish,  String? nameSanskrit)  $default,) {final _that = this;
switch (_that) {
case _FestivalSummary():
return $default(_that.slug,_that.nameEnglish,_that.nameSanskrit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String nameEnglish,  String? nameSanskrit)?  $default,) {final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
return $default(_that.slug,_that.nameEnglish,_that.nameSanskrit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FestivalSummary implements FestivalSummary {
  const _FestivalSummary({required this.slug, required this.nameEnglish, this.nameSanskrit});
  factory _FestivalSummary.fromJson(Map<String, dynamic> json) => _$FestivalSummaryFromJson(json);

@override final  String slug;
@override final  String nameEnglish;
@override final  String? nameSanskrit;

/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalSummaryCopyWith<_FestivalSummary> get copyWith => __$FestivalSummaryCopyWithImpl<_FestivalSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FestivalSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivalSummary&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameEnglish, nameEnglish) || other.nameEnglish == nameEnglish)&&(identical(other.nameSanskrit, nameSanskrit) || other.nameSanskrit == nameSanskrit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nameEnglish,nameSanskrit);

@override
String toString() {
  return 'FestivalSummary(slug: $slug, nameEnglish: $nameEnglish, nameSanskrit: $nameSanskrit)';
}


}

/// @nodoc
abstract mixin class _$FestivalSummaryCopyWith<$Res> implements $FestivalSummaryCopyWith<$Res> {
  factory _$FestivalSummaryCopyWith(_FestivalSummary value, $Res Function(_FestivalSummary) _then) = __$FestivalSummaryCopyWithImpl;
@override @useResult
$Res call({
 String slug, String nameEnglish, String? nameSanskrit
});




}
/// @nodoc
class __$FestivalSummaryCopyWithImpl<$Res>
    implements _$FestivalSummaryCopyWith<$Res> {
  __$FestivalSummaryCopyWithImpl(this._self, this._then);

  final _FestivalSummary _self;
  final $Res Function(_FestivalSummary) _then;

/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? nameEnglish = null,Object? nameSanskrit = freezed,}) {
  return _then(_FestivalSummary(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameEnglish: null == nameEnglish ? _self.nameEnglish : nameEnglish // ignore: cast_nullable_to_non_nullable
as String,nameSanskrit: freezed == nameSanskrit ? _self.nameSanskrit : nameSanskrit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PanchangDay {

 String get date;// 'yyyy-MM-dd'
 String get timezone; TithiInfo get tithi; NakshatraInfo get nakshatra; YogaInfo get yoga; KaranaInfo get karana; VaaraInfo get vaara; DateTime get sunrise; DateTime get sunset; DateTime? get moonrise; DateTime? get moonset; AuspiciousTimes get auspicious; List<FestivalSummary> get festivals;
/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanchangDayCopyWith<PanchangDay> get copyWith => _$PanchangDayCopyWithImpl<PanchangDay>(this as PanchangDay, _$identity);

  /// Serializes this PanchangDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanchangDay&&(identical(other.date, date) || other.date == date)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.tithi, tithi) || other.tithi == tithi)&&(identical(other.nakshatra, nakshatra) || other.nakshatra == nakshatra)&&(identical(other.yoga, yoga) || other.yoga == yoga)&&(identical(other.karana, karana) || other.karana == karana)&&(identical(other.vaara, vaara) || other.vaara == vaara)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset)&&(identical(other.moonrise, moonrise) || other.moonrise == moonrise)&&(identical(other.moonset, moonset) || other.moonset == moonset)&&(identical(other.auspicious, auspicious) || other.auspicious == auspicious)&&const DeepCollectionEquality().equals(other.festivals, festivals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,timezone,tithi,nakshatra,yoga,karana,vaara,sunrise,sunset,moonrise,moonset,auspicious,const DeepCollectionEquality().hash(festivals));

@override
String toString() {
  return 'PanchangDay(date: $date, timezone: $timezone, tithi: $tithi, nakshatra: $nakshatra, yoga: $yoga, karana: $karana, vaara: $vaara, sunrise: $sunrise, sunset: $sunset, moonrise: $moonrise, moonset: $moonset, auspicious: $auspicious, festivals: $festivals)';
}


}

/// @nodoc
abstract mixin class $PanchangDayCopyWith<$Res>  {
  factory $PanchangDayCopyWith(PanchangDay value, $Res Function(PanchangDay) _then) = _$PanchangDayCopyWithImpl;
@useResult
$Res call({
 String date, String timezone, TithiInfo tithi, NakshatraInfo nakshatra, YogaInfo yoga, KaranaInfo karana, VaaraInfo vaara, DateTime sunrise, DateTime sunset, DateTime? moonrise, DateTime? moonset, AuspiciousTimes auspicious, List<FestivalSummary> festivals
});


$TithiInfoCopyWith<$Res> get tithi;$NakshatraInfoCopyWith<$Res> get nakshatra;$YogaInfoCopyWith<$Res> get yoga;$KaranaInfoCopyWith<$Res> get karana;$VaaraInfoCopyWith<$Res> get vaara;$AuspiciousTimesCopyWith<$Res> get auspicious;

}
/// @nodoc
class _$PanchangDayCopyWithImpl<$Res>
    implements $PanchangDayCopyWith<$Res> {
  _$PanchangDayCopyWithImpl(this._self, this._then);

  final PanchangDay _self;
  final $Res Function(PanchangDay) _then;

/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? timezone = null,Object? tithi = null,Object? nakshatra = null,Object? yoga = null,Object? karana = null,Object? vaara = null,Object? sunrise = null,Object? sunset = null,Object? moonrise = freezed,Object? moonset = freezed,Object? auspicious = null,Object? festivals = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,tithi: null == tithi ? _self.tithi : tithi // ignore: cast_nullable_to_non_nullable
as TithiInfo,nakshatra: null == nakshatra ? _self.nakshatra : nakshatra // ignore: cast_nullable_to_non_nullable
as NakshatraInfo,yoga: null == yoga ? _self.yoga : yoga // ignore: cast_nullable_to_non_nullable
as YogaInfo,karana: null == karana ? _self.karana : karana // ignore: cast_nullable_to_non_nullable
as KaranaInfo,vaara: null == vaara ? _self.vaara : vaara // ignore: cast_nullable_to_non_nullable
as VaaraInfo,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,moonrise: freezed == moonrise ? _self.moonrise : moonrise // ignore: cast_nullable_to_non_nullable
as DateTime?,moonset: freezed == moonset ? _self.moonset : moonset // ignore: cast_nullable_to_non_nullable
as DateTime?,auspicious: null == auspicious ? _self.auspicious : auspicious // ignore: cast_nullable_to_non_nullable
as AuspiciousTimes,festivals: null == festivals ? _self.festivals : festivals // ignore: cast_nullable_to_non_nullable
as List<FestivalSummary>,
  ));
}
/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TithiInfoCopyWith<$Res> get tithi {
  
  return $TithiInfoCopyWith<$Res>(_self.tithi, (value) {
    return _then(_self.copyWith(tithi: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NakshatraInfoCopyWith<$Res> get nakshatra {
  
  return $NakshatraInfoCopyWith<$Res>(_self.nakshatra, (value) {
    return _then(_self.copyWith(nakshatra: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YogaInfoCopyWith<$Res> get yoga {
  
  return $YogaInfoCopyWith<$Res>(_self.yoga, (value) {
    return _then(_self.copyWith(yoga: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KaranaInfoCopyWith<$Res> get karana {
  
  return $KaranaInfoCopyWith<$Res>(_self.karana, (value) {
    return _then(_self.copyWith(karana: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaaraInfoCopyWith<$Res> get vaara {
  
  return $VaaraInfoCopyWith<$Res>(_self.vaara, (value) {
    return _then(_self.copyWith(vaara: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuspiciousTimesCopyWith<$Res> get auspicious {
  
  return $AuspiciousTimesCopyWith<$Res>(_self.auspicious, (value) {
    return _then(_self.copyWith(auspicious: value));
  });
}
}


/// Adds pattern-matching-related methods to [PanchangDay].
extension PanchangDayPatterns on PanchangDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanchangDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanchangDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanchangDay value)  $default,){
final _that = this;
switch (_that) {
case _PanchangDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanchangDay value)?  $default,){
final _that = this;
switch (_that) {
case _PanchangDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String timezone,  TithiInfo tithi,  NakshatraInfo nakshatra,  YogaInfo yoga,  KaranaInfo karana,  VaaraInfo vaara,  DateTime sunrise,  DateTime sunset,  DateTime? moonrise,  DateTime? moonset,  AuspiciousTimes auspicious,  List<FestivalSummary> festivals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanchangDay() when $default != null:
return $default(_that.date,_that.timezone,_that.tithi,_that.nakshatra,_that.yoga,_that.karana,_that.vaara,_that.sunrise,_that.sunset,_that.moonrise,_that.moonset,_that.auspicious,_that.festivals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String timezone,  TithiInfo tithi,  NakshatraInfo nakshatra,  YogaInfo yoga,  KaranaInfo karana,  VaaraInfo vaara,  DateTime sunrise,  DateTime sunset,  DateTime? moonrise,  DateTime? moonset,  AuspiciousTimes auspicious,  List<FestivalSummary> festivals)  $default,) {final _that = this;
switch (_that) {
case _PanchangDay():
return $default(_that.date,_that.timezone,_that.tithi,_that.nakshatra,_that.yoga,_that.karana,_that.vaara,_that.sunrise,_that.sunset,_that.moonrise,_that.moonset,_that.auspicious,_that.festivals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String timezone,  TithiInfo tithi,  NakshatraInfo nakshatra,  YogaInfo yoga,  KaranaInfo karana,  VaaraInfo vaara,  DateTime sunrise,  DateTime sunset,  DateTime? moonrise,  DateTime? moonset,  AuspiciousTimes auspicious,  List<FestivalSummary> festivals)?  $default,) {final _that = this;
switch (_that) {
case _PanchangDay() when $default != null:
return $default(_that.date,_that.timezone,_that.tithi,_that.nakshatra,_that.yoga,_that.karana,_that.vaara,_that.sunrise,_that.sunset,_that.moonrise,_that.moonset,_that.auspicious,_that.festivals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanchangDay implements PanchangDay {
  const _PanchangDay({required this.date, required this.timezone, required this.tithi, required this.nakshatra, required this.yoga, required this.karana, required this.vaara, required this.sunrise, required this.sunset, this.moonrise, this.moonset, required this.auspicious, final  List<FestivalSummary> festivals = const <FestivalSummary>[]}): _festivals = festivals;
  factory _PanchangDay.fromJson(Map<String, dynamic> json) => _$PanchangDayFromJson(json);

@override final  String date;
// 'yyyy-MM-dd'
@override final  String timezone;
@override final  TithiInfo tithi;
@override final  NakshatraInfo nakshatra;
@override final  YogaInfo yoga;
@override final  KaranaInfo karana;
@override final  VaaraInfo vaara;
@override final  DateTime sunrise;
@override final  DateTime sunset;
@override final  DateTime? moonrise;
@override final  DateTime? moonset;
@override final  AuspiciousTimes auspicious;
 final  List<FestivalSummary> _festivals;
@override@JsonKey() List<FestivalSummary> get festivals {
  if (_festivals is EqualUnmodifiableListView) return _festivals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_festivals);
}


/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanchangDayCopyWith<_PanchangDay> get copyWith => __$PanchangDayCopyWithImpl<_PanchangDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanchangDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanchangDay&&(identical(other.date, date) || other.date == date)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.tithi, tithi) || other.tithi == tithi)&&(identical(other.nakshatra, nakshatra) || other.nakshatra == nakshatra)&&(identical(other.yoga, yoga) || other.yoga == yoga)&&(identical(other.karana, karana) || other.karana == karana)&&(identical(other.vaara, vaara) || other.vaara == vaara)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset)&&(identical(other.moonrise, moonrise) || other.moonrise == moonrise)&&(identical(other.moonset, moonset) || other.moonset == moonset)&&(identical(other.auspicious, auspicious) || other.auspicious == auspicious)&&const DeepCollectionEquality().equals(other._festivals, _festivals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,timezone,tithi,nakshatra,yoga,karana,vaara,sunrise,sunset,moonrise,moonset,auspicious,const DeepCollectionEquality().hash(_festivals));

@override
String toString() {
  return 'PanchangDay(date: $date, timezone: $timezone, tithi: $tithi, nakshatra: $nakshatra, yoga: $yoga, karana: $karana, vaara: $vaara, sunrise: $sunrise, sunset: $sunset, moonrise: $moonrise, moonset: $moonset, auspicious: $auspicious, festivals: $festivals)';
}


}

/// @nodoc
abstract mixin class _$PanchangDayCopyWith<$Res> implements $PanchangDayCopyWith<$Res> {
  factory _$PanchangDayCopyWith(_PanchangDay value, $Res Function(_PanchangDay) _then) = __$PanchangDayCopyWithImpl;
@override @useResult
$Res call({
 String date, String timezone, TithiInfo tithi, NakshatraInfo nakshatra, YogaInfo yoga, KaranaInfo karana, VaaraInfo vaara, DateTime sunrise, DateTime sunset, DateTime? moonrise, DateTime? moonset, AuspiciousTimes auspicious, List<FestivalSummary> festivals
});


@override $TithiInfoCopyWith<$Res> get tithi;@override $NakshatraInfoCopyWith<$Res> get nakshatra;@override $YogaInfoCopyWith<$Res> get yoga;@override $KaranaInfoCopyWith<$Res> get karana;@override $VaaraInfoCopyWith<$Res> get vaara;@override $AuspiciousTimesCopyWith<$Res> get auspicious;

}
/// @nodoc
class __$PanchangDayCopyWithImpl<$Res>
    implements _$PanchangDayCopyWith<$Res> {
  __$PanchangDayCopyWithImpl(this._self, this._then);

  final _PanchangDay _self;
  final $Res Function(_PanchangDay) _then;

/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? timezone = null,Object? tithi = null,Object? nakshatra = null,Object? yoga = null,Object? karana = null,Object? vaara = null,Object? sunrise = null,Object? sunset = null,Object? moonrise = freezed,Object? moonset = freezed,Object? auspicious = null,Object? festivals = null,}) {
  return _then(_PanchangDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,tithi: null == tithi ? _self.tithi : tithi // ignore: cast_nullable_to_non_nullable
as TithiInfo,nakshatra: null == nakshatra ? _self.nakshatra : nakshatra // ignore: cast_nullable_to_non_nullable
as NakshatraInfo,yoga: null == yoga ? _self.yoga : yoga // ignore: cast_nullable_to_non_nullable
as YogaInfo,karana: null == karana ? _self.karana : karana // ignore: cast_nullable_to_non_nullable
as KaranaInfo,vaara: null == vaara ? _self.vaara : vaara // ignore: cast_nullable_to_non_nullable
as VaaraInfo,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,moonrise: freezed == moonrise ? _self.moonrise : moonrise // ignore: cast_nullable_to_non_nullable
as DateTime?,moonset: freezed == moonset ? _self.moonset : moonset // ignore: cast_nullable_to_non_nullable
as DateTime?,auspicious: null == auspicious ? _self.auspicious : auspicious // ignore: cast_nullable_to_non_nullable
as AuspiciousTimes,festivals: null == festivals ? _self._festivals : festivals // ignore: cast_nullable_to_non_nullable
as List<FestivalSummary>,
  ));
}

/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TithiInfoCopyWith<$Res> get tithi {
  
  return $TithiInfoCopyWith<$Res>(_self.tithi, (value) {
    return _then(_self.copyWith(tithi: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NakshatraInfoCopyWith<$Res> get nakshatra {
  
  return $NakshatraInfoCopyWith<$Res>(_self.nakshatra, (value) {
    return _then(_self.copyWith(nakshatra: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YogaInfoCopyWith<$Res> get yoga {
  
  return $YogaInfoCopyWith<$Res>(_self.yoga, (value) {
    return _then(_self.copyWith(yoga: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KaranaInfoCopyWith<$Res> get karana {
  
  return $KaranaInfoCopyWith<$Res>(_self.karana, (value) {
    return _then(_self.copyWith(karana: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaaraInfoCopyWith<$Res> get vaara {
  
  return $VaaraInfoCopyWith<$Res>(_self.vaara, (value) {
    return _then(_self.copyWith(vaara: value));
  });
}/// Create a copy of PanchangDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuspiciousTimesCopyWith<$Res> get auspicious {
  
  return $AuspiciousTimesCopyWith<$Res>(_self.auspicious, (value) {
    return _then(_self.copyWith(auspicious: value));
  });
}
}

// dart format on
