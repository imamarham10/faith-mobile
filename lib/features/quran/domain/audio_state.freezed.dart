// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioState {

 bool get isPlaying; bool get isBuffering; int? get currentSurah; int? get currentAyah; int? get totalVerses; String? get surahName; String? get title; String? get errorMessage; double get speed;
/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioStateCopyWith<AudioState> get copyWith => _$AudioStateCopyWithImpl<AudioState>(this as AudioState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.currentSurah, currentSurah) || other.currentSurah == currentSurah)&&(identical(other.currentAyah, currentAyah) || other.currentAyah == currentAyah)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.title, title) || other.title == title)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,isBuffering,currentSurah,currentAyah,totalVerses,surahName,title,errorMessage,speed);

@override
String toString() {
  return 'AudioState(isPlaying: $isPlaying, isBuffering: $isBuffering, currentSurah: $currentSurah, currentAyah: $currentAyah, totalVerses: $totalVerses, surahName: $surahName, title: $title, errorMessage: $errorMessage, speed: $speed)';
}


}

/// @nodoc
abstract mixin class $AudioStateCopyWith<$Res>  {
  factory $AudioStateCopyWith(AudioState value, $Res Function(AudioState) _then) = _$AudioStateCopyWithImpl;
@useResult
$Res call({
 bool isPlaying, bool isBuffering, int? currentSurah, int? currentAyah, int? totalVerses, String? surahName, String? title, String? errorMessage, double speed
});




}
/// @nodoc
class _$AudioStateCopyWithImpl<$Res>
    implements $AudioStateCopyWith<$Res> {
  _$AudioStateCopyWithImpl(this._self, this._then);

  final AudioState _self;
  final $Res Function(AudioState) _then;

/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPlaying = null,Object? isBuffering = null,Object? currentSurah = freezed,Object? currentAyah = freezed,Object? totalVerses = freezed,Object? surahName = freezed,Object? title = freezed,Object? errorMessage = freezed,Object? speed = null,}) {
  return _then(_self.copyWith(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,currentSurah: freezed == currentSurah ? _self.currentSurah : currentSurah // ignore: cast_nullable_to_non_nullable
as int?,currentAyah: freezed == currentAyah ? _self.currentAyah : currentAyah // ignore: cast_nullable_to_non_nullable
as int?,totalVerses: freezed == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int?,surahName: freezed == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioState].
extension AudioStatePatterns on AudioState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioState value)  $default,){
final _that = this;
switch (_that) {
case _AudioState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioState value)?  $default,){
final _that = this;
switch (_that) {
case _AudioState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPlaying,  bool isBuffering,  int? currentSurah,  int? currentAyah,  int? totalVerses,  String? surahName,  String? title,  String? errorMessage,  double speed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioState() when $default != null:
return $default(_that.isPlaying,_that.isBuffering,_that.currentSurah,_that.currentAyah,_that.totalVerses,_that.surahName,_that.title,_that.errorMessage,_that.speed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPlaying,  bool isBuffering,  int? currentSurah,  int? currentAyah,  int? totalVerses,  String? surahName,  String? title,  String? errorMessage,  double speed)  $default,) {final _that = this;
switch (_that) {
case _AudioState():
return $default(_that.isPlaying,_that.isBuffering,_that.currentSurah,_that.currentAyah,_that.totalVerses,_that.surahName,_that.title,_that.errorMessage,_that.speed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPlaying,  bool isBuffering,  int? currentSurah,  int? currentAyah,  int? totalVerses,  String? surahName,  String? title,  String? errorMessage,  double speed)?  $default,) {final _that = this;
switch (_that) {
case _AudioState() when $default != null:
return $default(_that.isPlaying,_that.isBuffering,_that.currentSurah,_that.currentAyah,_that.totalVerses,_that.surahName,_that.title,_that.errorMessage,_that.speed);case _:
  return null;

}
}

}

/// @nodoc


class _AudioState extends AudioState {
  const _AudioState({this.isPlaying = false, this.isBuffering = false, this.currentSurah, this.currentAyah, this.totalVerses, this.surahName, this.title, this.errorMessage, this.speed = 1.0}): super._();
  

@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isBuffering;
@override final  int? currentSurah;
@override final  int? currentAyah;
@override final  int? totalVerses;
@override final  String? surahName;
@override final  String? title;
@override final  String? errorMessage;
@override@JsonKey() final  double speed;

/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioStateCopyWith<_AudioState> get copyWith => __$AudioStateCopyWithImpl<_AudioState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.currentSurah, currentSurah) || other.currentSurah == currentSurah)&&(identical(other.currentAyah, currentAyah) || other.currentAyah == currentAyah)&&(identical(other.totalVerses, totalVerses) || other.totalVerses == totalVerses)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.title, title) || other.title == title)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,isBuffering,currentSurah,currentAyah,totalVerses,surahName,title,errorMessage,speed);

@override
String toString() {
  return 'AudioState(isPlaying: $isPlaying, isBuffering: $isBuffering, currentSurah: $currentSurah, currentAyah: $currentAyah, totalVerses: $totalVerses, surahName: $surahName, title: $title, errorMessage: $errorMessage, speed: $speed)';
}


}

/// @nodoc
abstract mixin class _$AudioStateCopyWith<$Res> implements $AudioStateCopyWith<$Res> {
  factory _$AudioStateCopyWith(_AudioState value, $Res Function(_AudioState) _then) = __$AudioStateCopyWithImpl;
@override @useResult
$Res call({
 bool isPlaying, bool isBuffering, int? currentSurah, int? currentAyah, int? totalVerses, String? surahName, String? title, String? errorMessage, double speed
});




}
/// @nodoc
class __$AudioStateCopyWithImpl<$Res>
    implements _$AudioStateCopyWith<$Res> {
  __$AudioStateCopyWithImpl(this._self, this._then);

  final _AudioState _self;
  final $Res Function(_AudioState) _then;

/// Create a copy of AudioState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,Object? isBuffering = null,Object? currentSurah = freezed,Object? currentAyah = freezed,Object? totalVerses = freezed,Object? surahName = freezed,Object? title = freezed,Object? errorMessage = freezed,Object? speed = null,}) {
  return _then(_AudioState(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,currentSurah: freezed == currentSurah ? _self.currentSurah : currentSurah // ignore: cast_nullable_to_non_nullable
as int?,currentAyah: freezed == currentAyah ? _self.currentAyah : currentAyah // ignore: cast_nullable_to_non_nullable
as int?,totalVerses: freezed == totalVerses ? _self.totalVerses : totalVerses // ignore: cast_nullable_to_non_nullable
as int?,surahName: freezed == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
