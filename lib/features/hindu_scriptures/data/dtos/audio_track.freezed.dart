// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioTrack {

 String get reciterSlug; String get name; String get language; String? get credit; String get url; bool get isPremium;
/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioTrackCopyWith<AudioTrack> get copyWith => _$AudioTrackCopyWithImpl<AudioTrack>(this as AudioTrack, _$identity);

  /// Serializes this AudioTrack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioTrack&&(identical(other.reciterSlug, reciterSlug) || other.reciterSlug == reciterSlug)&&(identical(other.name, name) || other.name == name)&&(identical(other.language, language) || other.language == language)&&(identical(other.credit, credit) || other.credit == credit)&&(identical(other.url, url) || other.url == url)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reciterSlug,name,language,credit,url,isPremium);

@override
String toString() {
  return 'AudioTrack(reciterSlug: $reciterSlug, name: $name, language: $language, credit: $credit, url: $url, isPremium: $isPremium)';
}


}

/// @nodoc
abstract mixin class $AudioTrackCopyWith<$Res>  {
  factory $AudioTrackCopyWith(AudioTrack value, $Res Function(AudioTrack) _then) = _$AudioTrackCopyWithImpl;
@useResult
$Res call({
 String reciterSlug, String name, String language, String? credit, String url, bool isPremium
});




}
/// @nodoc
class _$AudioTrackCopyWithImpl<$Res>
    implements $AudioTrackCopyWith<$Res> {
  _$AudioTrackCopyWithImpl(this._self, this._then);

  final AudioTrack _self;
  final $Res Function(AudioTrack) _then;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reciterSlug = null,Object? name = null,Object? language = null,Object? credit = freezed,Object? url = null,Object? isPremium = null,}) {
  return _then(_self.copyWith(
reciterSlug: null == reciterSlug ? _self.reciterSlug : reciterSlug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,credit: freezed == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioTrack].
extension AudioTrackPatterns on AudioTrack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioTrack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioTrack value)  $default,){
final _that = this;
switch (_that) {
case _AudioTrack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioTrack value)?  $default,){
final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reciterSlug,  String name,  String language,  String? credit,  String url,  bool isPremium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
return $default(_that.reciterSlug,_that.name,_that.language,_that.credit,_that.url,_that.isPremium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reciterSlug,  String name,  String language,  String? credit,  String url,  bool isPremium)  $default,) {final _that = this;
switch (_that) {
case _AudioTrack():
return $default(_that.reciterSlug,_that.name,_that.language,_that.credit,_that.url,_that.isPremium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reciterSlug,  String name,  String language,  String? credit,  String url,  bool isPremium)?  $default,) {final _that = this;
switch (_that) {
case _AudioTrack() when $default != null:
return $default(_that.reciterSlug,_that.name,_that.language,_that.credit,_that.url,_that.isPremium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudioTrack implements AudioTrack {
  const _AudioTrack({required this.reciterSlug, required this.name, required this.language, this.credit, required this.url, this.isPremium = false});
  factory _AudioTrack.fromJson(Map<String, dynamic> json) => _$AudioTrackFromJson(json);

@override final  String reciterSlug;
@override final  String name;
@override final  String language;
@override final  String? credit;
@override final  String url;
@override@JsonKey() final  bool isPremium;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioTrackCopyWith<_AudioTrack> get copyWith => __$AudioTrackCopyWithImpl<_AudioTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioTrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioTrack&&(identical(other.reciterSlug, reciterSlug) || other.reciterSlug == reciterSlug)&&(identical(other.name, name) || other.name == name)&&(identical(other.language, language) || other.language == language)&&(identical(other.credit, credit) || other.credit == credit)&&(identical(other.url, url) || other.url == url)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reciterSlug,name,language,credit,url,isPremium);

@override
String toString() {
  return 'AudioTrack(reciterSlug: $reciterSlug, name: $name, language: $language, credit: $credit, url: $url, isPremium: $isPremium)';
}


}

/// @nodoc
abstract mixin class _$AudioTrackCopyWith<$Res> implements $AudioTrackCopyWith<$Res> {
  factory _$AudioTrackCopyWith(_AudioTrack value, $Res Function(_AudioTrack) _then) = __$AudioTrackCopyWithImpl;
@override @useResult
$Res call({
 String reciterSlug, String name, String language, String? credit, String url, bool isPremium
});




}
/// @nodoc
class __$AudioTrackCopyWithImpl<$Res>
    implements _$AudioTrackCopyWith<$Res> {
  __$AudioTrackCopyWithImpl(this._self, this._then);

  final _AudioTrack _self;
  final $Res Function(_AudioTrack) _then;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reciterSlug = null,Object? name = null,Object? language = null,Object? credit = freezed,Object? url = null,Object? isPremium = null,}) {
  return _then(_AudioTrack(
reciterSlug: null == reciterSlug ? _self.reciterSlug : reciterSlug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,credit: freezed == credit ? _self.credit : credit // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
