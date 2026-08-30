// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scripture_audio_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScriptureAudioState {

 bool get isPlaying; bool get isBuffering; String? get currentTextSlug; int? get currentChapterNumber; String? get chapterTitle; AudioTrack? get currentTrack; List<AudioTrack> get availableTracks; String? get errorMessage; double get speed;
/// Create a copy of ScriptureAudioState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptureAudioStateCopyWith<ScriptureAudioState> get copyWith => _$ScriptureAudioStateCopyWithImpl<ScriptureAudioState>(this as ScriptureAudioState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptureAudioState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.currentTextSlug, currentTextSlug) || other.currentTextSlug == currentTextSlug)&&(identical(other.currentChapterNumber, currentChapterNumber) || other.currentChapterNumber == currentChapterNumber)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack)&&const DeepCollectionEquality().equals(other.availableTracks, availableTracks)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,isBuffering,currentTextSlug,currentChapterNumber,chapterTitle,currentTrack,const DeepCollectionEquality().hash(availableTracks),errorMessage,speed);

@override
String toString() {
  return 'ScriptureAudioState(isPlaying: $isPlaying, isBuffering: $isBuffering, currentTextSlug: $currentTextSlug, currentChapterNumber: $currentChapterNumber, chapterTitle: $chapterTitle, currentTrack: $currentTrack, availableTracks: $availableTracks, errorMessage: $errorMessage, speed: $speed)';
}


}

/// @nodoc
abstract mixin class $ScriptureAudioStateCopyWith<$Res>  {
  factory $ScriptureAudioStateCopyWith(ScriptureAudioState value, $Res Function(ScriptureAudioState) _then) = _$ScriptureAudioStateCopyWithImpl;
@useResult
$Res call({
 bool isPlaying, bool isBuffering, String? currentTextSlug, int? currentChapterNumber, String? chapterTitle, AudioTrack? currentTrack, List<AudioTrack> availableTracks, String? errorMessage, double speed
});


$AudioTrackCopyWith<$Res>? get currentTrack;

}
/// @nodoc
class _$ScriptureAudioStateCopyWithImpl<$Res>
    implements $ScriptureAudioStateCopyWith<$Res> {
  _$ScriptureAudioStateCopyWithImpl(this._self, this._then);

  final ScriptureAudioState _self;
  final $Res Function(ScriptureAudioState) _then;

/// Create a copy of ScriptureAudioState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPlaying = null,Object? isBuffering = null,Object? currentTextSlug = freezed,Object? currentChapterNumber = freezed,Object? chapterTitle = freezed,Object? currentTrack = freezed,Object? availableTracks = null,Object? errorMessage = freezed,Object? speed = null,}) {
  return _then(_self.copyWith(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,currentTextSlug: freezed == currentTextSlug ? _self.currentTextSlug : currentTextSlug // ignore: cast_nullable_to_non_nullable
as String?,currentChapterNumber: freezed == currentChapterNumber ? _self.currentChapterNumber : currentChapterNumber // ignore: cast_nullable_to_non_nullable
as int?,chapterTitle: freezed == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String?,currentTrack: freezed == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as AudioTrack?,availableTracks: null == availableTracks ? _self.availableTracks : availableTracks // ignore: cast_nullable_to_non_nullable
as List<AudioTrack>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ScriptureAudioState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioTrackCopyWith<$Res>? get currentTrack {
    if (_self.currentTrack == null) {
    return null;
  }

  return $AudioTrackCopyWith<$Res>(_self.currentTrack!, (value) {
    return _then(_self.copyWith(currentTrack: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScriptureAudioState].
extension ScriptureAudioStatePatterns on ScriptureAudioState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScriptureAudioState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScriptureAudioState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScriptureAudioState value)  $default,){
final _that = this;
switch (_that) {
case _ScriptureAudioState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScriptureAudioState value)?  $default,){
final _that = this;
switch (_that) {
case _ScriptureAudioState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPlaying,  bool isBuffering,  String? currentTextSlug,  int? currentChapterNumber,  String? chapterTitle,  AudioTrack? currentTrack,  List<AudioTrack> availableTracks,  String? errorMessage,  double speed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScriptureAudioState() when $default != null:
return $default(_that.isPlaying,_that.isBuffering,_that.currentTextSlug,_that.currentChapterNumber,_that.chapterTitle,_that.currentTrack,_that.availableTracks,_that.errorMessage,_that.speed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPlaying,  bool isBuffering,  String? currentTextSlug,  int? currentChapterNumber,  String? chapterTitle,  AudioTrack? currentTrack,  List<AudioTrack> availableTracks,  String? errorMessage,  double speed)  $default,) {final _that = this;
switch (_that) {
case _ScriptureAudioState():
return $default(_that.isPlaying,_that.isBuffering,_that.currentTextSlug,_that.currentChapterNumber,_that.chapterTitle,_that.currentTrack,_that.availableTracks,_that.errorMessage,_that.speed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPlaying,  bool isBuffering,  String? currentTextSlug,  int? currentChapterNumber,  String? chapterTitle,  AudioTrack? currentTrack,  List<AudioTrack> availableTracks,  String? errorMessage,  double speed)?  $default,) {final _that = this;
switch (_that) {
case _ScriptureAudioState() when $default != null:
return $default(_that.isPlaying,_that.isBuffering,_that.currentTextSlug,_that.currentChapterNumber,_that.chapterTitle,_that.currentTrack,_that.availableTracks,_that.errorMessage,_that.speed);case _:
  return null;

}
}

}

/// @nodoc


class _ScriptureAudioState extends ScriptureAudioState {
  const _ScriptureAudioState({this.isPlaying = false, this.isBuffering = false, this.currentTextSlug, this.currentChapterNumber, this.chapterTitle, this.currentTrack, final  List<AudioTrack> availableTracks = const <AudioTrack>[], this.errorMessage, this.speed = 1.0}): _availableTracks = availableTracks,super._();
  

@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isBuffering;
@override final  String? currentTextSlug;
@override final  int? currentChapterNumber;
@override final  String? chapterTitle;
@override final  AudioTrack? currentTrack;
 final  List<AudioTrack> _availableTracks;
@override@JsonKey() List<AudioTrack> get availableTracks {
  if (_availableTracks is EqualUnmodifiableListView) return _availableTracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableTracks);
}

@override final  String? errorMessage;
@override@JsonKey() final  double speed;

/// Create a copy of ScriptureAudioState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScriptureAudioStateCopyWith<_ScriptureAudioState> get copyWith => __$ScriptureAudioStateCopyWithImpl<_ScriptureAudioState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScriptureAudioState&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.currentTextSlug, currentTextSlug) || other.currentTextSlug == currentTextSlug)&&(identical(other.currentChapterNumber, currentChapterNumber) || other.currentChapterNumber == currentChapterNumber)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack)&&const DeepCollectionEquality().equals(other._availableTracks, _availableTracks)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode => Object.hash(runtimeType,isPlaying,isBuffering,currentTextSlug,currentChapterNumber,chapterTitle,currentTrack,const DeepCollectionEquality().hash(_availableTracks),errorMessage,speed);

@override
String toString() {
  return 'ScriptureAudioState(isPlaying: $isPlaying, isBuffering: $isBuffering, currentTextSlug: $currentTextSlug, currentChapterNumber: $currentChapterNumber, chapterTitle: $chapterTitle, currentTrack: $currentTrack, availableTracks: $availableTracks, errorMessage: $errorMessage, speed: $speed)';
}


}

/// @nodoc
abstract mixin class _$ScriptureAudioStateCopyWith<$Res> implements $ScriptureAudioStateCopyWith<$Res> {
  factory _$ScriptureAudioStateCopyWith(_ScriptureAudioState value, $Res Function(_ScriptureAudioState) _then) = __$ScriptureAudioStateCopyWithImpl;
@override @useResult
$Res call({
 bool isPlaying, bool isBuffering, String? currentTextSlug, int? currentChapterNumber, String? chapterTitle, AudioTrack? currentTrack, List<AudioTrack> availableTracks, String? errorMessage, double speed
});


@override $AudioTrackCopyWith<$Res>? get currentTrack;

}
/// @nodoc
class __$ScriptureAudioStateCopyWithImpl<$Res>
    implements _$ScriptureAudioStateCopyWith<$Res> {
  __$ScriptureAudioStateCopyWithImpl(this._self, this._then);

  final _ScriptureAudioState _self;
  final $Res Function(_ScriptureAudioState) _then;

/// Create a copy of ScriptureAudioState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPlaying = null,Object? isBuffering = null,Object? currentTextSlug = freezed,Object? currentChapterNumber = freezed,Object? chapterTitle = freezed,Object? currentTrack = freezed,Object? availableTracks = null,Object? errorMessage = freezed,Object? speed = null,}) {
  return _then(_ScriptureAudioState(
isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,currentTextSlug: freezed == currentTextSlug ? _self.currentTextSlug : currentTextSlug // ignore: cast_nullable_to_non_nullable
as String?,currentChapterNumber: freezed == currentChapterNumber ? _self.currentChapterNumber : currentChapterNumber // ignore: cast_nullable_to_non_nullable
as int?,chapterTitle: freezed == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String?,currentTrack: freezed == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as AudioTrack?,availableTracks: null == availableTracks ? _self._availableTracks : availableTracks // ignore: cast_nullable_to_non_nullable
as List<AudioTrack>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ScriptureAudioState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioTrackCopyWith<$Res>? get currentTrack {
    if (_self.currentTrack == null) {
    return null;
  }

  return $AudioTrackCopyWith<$Res>(_self.currentTrack!, (value) {
    return _then(_self.copyWith(currentTrack: value));
  });
}
}

// dart format on
