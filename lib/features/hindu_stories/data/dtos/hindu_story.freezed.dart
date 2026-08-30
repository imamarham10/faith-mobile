// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hindu_story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HinduStory {

 String get id; int? get storyNumber; String get title; String get summary; String? get deityKey; List<String> get characters; StoryCollectionRef? get collection;
/// Create a copy of HinduStory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HinduStoryCopyWith<HinduStory> get copyWith => _$HinduStoryCopyWithImpl<HinduStory>(this as HinduStory, _$identity);

  /// Serializes this HinduStory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HinduStory&&(identical(other.id, id) || other.id == id)&&(identical(other.storyNumber, storyNumber) || other.storyNumber == storyNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&const DeepCollectionEquality().equals(other.characters, characters)&&(identical(other.collection, collection) || other.collection == collection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storyNumber,title,summary,deityKey,const DeepCollectionEquality().hash(characters),collection);

@override
String toString() {
  return 'HinduStory(id: $id, storyNumber: $storyNumber, title: $title, summary: $summary, deityKey: $deityKey, characters: $characters, collection: $collection)';
}


}

/// @nodoc
abstract mixin class $HinduStoryCopyWith<$Res>  {
  factory $HinduStoryCopyWith(HinduStory value, $Res Function(HinduStory) _then) = _$HinduStoryCopyWithImpl;
@useResult
$Res call({
 String id, int? storyNumber, String title, String summary, String? deityKey, List<String> characters, StoryCollectionRef? collection
});


$StoryCollectionRefCopyWith<$Res>? get collection;

}
/// @nodoc
class _$HinduStoryCopyWithImpl<$Res>
    implements $HinduStoryCopyWith<$Res> {
  _$HinduStoryCopyWithImpl(this._self, this._then);

  final HinduStory _self;
  final $Res Function(HinduStory) _then;

/// Create a copy of HinduStory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storyNumber = freezed,Object? title = null,Object? summary = null,Object? deityKey = freezed,Object? characters = null,Object? collection = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storyNumber: freezed == storyNumber ? _self.storyNumber : storyNumber // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as StoryCollectionRef?,
  ));
}
/// Create a copy of HinduStory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryCollectionRefCopyWith<$Res>? get collection {
    if (_self.collection == null) {
    return null;
  }

  return $StoryCollectionRefCopyWith<$Res>(_self.collection!, (value) {
    return _then(_self.copyWith(collection: value));
  });
}
}


/// Adds pattern-matching-related methods to [HinduStory].
extension HinduStoryPatterns on HinduStory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HinduStory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HinduStory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HinduStory value)  $default,){
final _that = this;
switch (_that) {
case _HinduStory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HinduStory value)?  $default,){
final _that = this;
switch (_that) {
case _HinduStory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int? storyNumber,  String title,  String summary,  String? deityKey,  List<String> characters,  StoryCollectionRef? collection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HinduStory() when $default != null:
return $default(_that.id,_that.storyNumber,_that.title,_that.summary,_that.deityKey,_that.characters,_that.collection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int? storyNumber,  String title,  String summary,  String? deityKey,  List<String> characters,  StoryCollectionRef? collection)  $default,) {final _that = this;
switch (_that) {
case _HinduStory():
return $default(_that.id,_that.storyNumber,_that.title,_that.summary,_that.deityKey,_that.characters,_that.collection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int? storyNumber,  String title,  String summary,  String? deityKey,  List<String> characters,  StoryCollectionRef? collection)?  $default,) {final _that = this;
switch (_that) {
case _HinduStory() when $default != null:
return $default(_that.id,_that.storyNumber,_that.title,_that.summary,_that.deityKey,_that.characters,_that.collection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HinduStory implements HinduStory {
  const _HinduStory({required this.id, this.storyNumber, required this.title, required this.summary, this.deityKey, final  List<String> characters = const <String>[], this.collection}): _characters = characters;
  factory _HinduStory.fromJson(Map<String, dynamic> json) => _$HinduStoryFromJson(json);

@override final  String id;
@override final  int? storyNumber;
@override final  String title;
@override final  String summary;
@override final  String? deityKey;
 final  List<String> _characters;
@override@JsonKey() List<String> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}

@override final  StoryCollectionRef? collection;

/// Create a copy of HinduStory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HinduStoryCopyWith<_HinduStory> get copyWith => __$HinduStoryCopyWithImpl<_HinduStory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HinduStoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HinduStory&&(identical(other.id, id) || other.id == id)&&(identical(other.storyNumber, storyNumber) || other.storyNumber == storyNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&const DeepCollectionEquality().equals(other._characters, _characters)&&(identical(other.collection, collection) || other.collection == collection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storyNumber,title,summary,deityKey,const DeepCollectionEquality().hash(_characters),collection);

@override
String toString() {
  return 'HinduStory(id: $id, storyNumber: $storyNumber, title: $title, summary: $summary, deityKey: $deityKey, characters: $characters, collection: $collection)';
}


}

/// @nodoc
abstract mixin class _$HinduStoryCopyWith<$Res> implements $HinduStoryCopyWith<$Res> {
  factory _$HinduStoryCopyWith(_HinduStory value, $Res Function(_HinduStory) _then) = __$HinduStoryCopyWithImpl;
@override @useResult
$Res call({
 String id, int? storyNumber, String title, String summary, String? deityKey, List<String> characters, StoryCollectionRef? collection
});


@override $StoryCollectionRefCopyWith<$Res>? get collection;

}
/// @nodoc
class __$HinduStoryCopyWithImpl<$Res>
    implements _$HinduStoryCopyWith<$Res> {
  __$HinduStoryCopyWithImpl(this._self, this._then);

  final _HinduStory _self;
  final $Res Function(_HinduStory) _then;

/// Create a copy of HinduStory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storyNumber = freezed,Object? title = null,Object? summary = null,Object? deityKey = freezed,Object? characters = null,Object? collection = freezed,}) {
  return _then(_HinduStory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storyNumber: freezed == storyNumber ? _self.storyNumber : storyNumber // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as StoryCollectionRef?,
  ));
}

/// Create a copy of HinduStory
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryCollectionRefCopyWith<$Res>? get collection {
    if (_self.collection == null) {
    return null;
  }

  return $StoryCollectionRefCopyWith<$Res>(_self.collection!, (value) {
    return _then(_self.copyWith(collection: value));
  });
}
}


/// @nodoc
mixin _$HinduStoryDetail {

 String get id; int? get storyNumber; String get title; String get summary; String get body; String? get deityKey; List<String> get characters; StoryCollectionRef? get collection;
/// Create a copy of HinduStoryDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HinduStoryDetailCopyWith<HinduStoryDetail> get copyWith => _$HinduStoryDetailCopyWithImpl<HinduStoryDetail>(this as HinduStoryDetail, _$identity);

  /// Serializes this HinduStoryDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HinduStoryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.storyNumber, storyNumber) || other.storyNumber == storyNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&const DeepCollectionEquality().equals(other.characters, characters)&&(identical(other.collection, collection) || other.collection == collection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storyNumber,title,summary,body,deityKey,const DeepCollectionEquality().hash(characters),collection);

@override
String toString() {
  return 'HinduStoryDetail(id: $id, storyNumber: $storyNumber, title: $title, summary: $summary, body: $body, deityKey: $deityKey, characters: $characters, collection: $collection)';
}


}

/// @nodoc
abstract mixin class $HinduStoryDetailCopyWith<$Res>  {
  factory $HinduStoryDetailCopyWith(HinduStoryDetail value, $Res Function(HinduStoryDetail) _then) = _$HinduStoryDetailCopyWithImpl;
@useResult
$Res call({
 String id, int? storyNumber, String title, String summary, String body, String? deityKey, List<String> characters, StoryCollectionRef? collection
});


$StoryCollectionRefCopyWith<$Res>? get collection;

}
/// @nodoc
class _$HinduStoryDetailCopyWithImpl<$Res>
    implements $HinduStoryDetailCopyWith<$Res> {
  _$HinduStoryDetailCopyWithImpl(this._self, this._then);

  final HinduStoryDetail _self;
  final $Res Function(HinduStoryDetail) _then;

/// Create a copy of HinduStoryDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storyNumber = freezed,Object? title = null,Object? summary = null,Object? body = null,Object? deityKey = freezed,Object? characters = null,Object? collection = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storyNumber: freezed == storyNumber ? _self.storyNumber : storyNumber // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as StoryCollectionRef?,
  ));
}
/// Create a copy of HinduStoryDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryCollectionRefCopyWith<$Res>? get collection {
    if (_self.collection == null) {
    return null;
  }

  return $StoryCollectionRefCopyWith<$Res>(_self.collection!, (value) {
    return _then(_self.copyWith(collection: value));
  });
}
}


/// Adds pattern-matching-related methods to [HinduStoryDetail].
extension HinduStoryDetailPatterns on HinduStoryDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HinduStoryDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HinduStoryDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HinduStoryDetail value)  $default,){
final _that = this;
switch (_that) {
case _HinduStoryDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HinduStoryDetail value)?  $default,){
final _that = this;
switch (_that) {
case _HinduStoryDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int? storyNumber,  String title,  String summary,  String body,  String? deityKey,  List<String> characters,  StoryCollectionRef? collection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HinduStoryDetail() when $default != null:
return $default(_that.id,_that.storyNumber,_that.title,_that.summary,_that.body,_that.deityKey,_that.characters,_that.collection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int? storyNumber,  String title,  String summary,  String body,  String? deityKey,  List<String> characters,  StoryCollectionRef? collection)  $default,) {final _that = this;
switch (_that) {
case _HinduStoryDetail():
return $default(_that.id,_that.storyNumber,_that.title,_that.summary,_that.body,_that.deityKey,_that.characters,_that.collection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int? storyNumber,  String title,  String summary,  String body,  String? deityKey,  List<String> characters,  StoryCollectionRef? collection)?  $default,) {final _that = this;
switch (_that) {
case _HinduStoryDetail() when $default != null:
return $default(_that.id,_that.storyNumber,_that.title,_that.summary,_that.body,_that.deityKey,_that.characters,_that.collection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HinduStoryDetail implements HinduStoryDetail {
  const _HinduStoryDetail({required this.id, this.storyNumber, required this.title, required this.summary, required this.body, this.deityKey, final  List<String> characters = const <String>[], this.collection}): _characters = characters;
  factory _HinduStoryDetail.fromJson(Map<String, dynamic> json) => _$HinduStoryDetailFromJson(json);

@override final  String id;
@override final  int? storyNumber;
@override final  String title;
@override final  String summary;
@override final  String body;
@override final  String? deityKey;
 final  List<String> _characters;
@override@JsonKey() List<String> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}

@override final  StoryCollectionRef? collection;

/// Create a copy of HinduStoryDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HinduStoryDetailCopyWith<_HinduStoryDetail> get copyWith => __$HinduStoryDetailCopyWithImpl<_HinduStoryDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HinduStoryDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HinduStoryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.storyNumber, storyNumber) || other.storyNumber == storyNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&const DeepCollectionEquality().equals(other._characters, _characters)&&(identical(other.collection, collection) || other.collection == collection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storyNumber,title,summary,body,deityKey,const DeepCollectionEquality().hash(_characters),collection);

@override
String toString() {
  return 'HinduStoryDetail(id: $id, storyNumber: $storyNumber, title: $title, summary: $summary, body: $body, deityKey: $deityKey, characters: $characters, collection: $collection)';
}


}

/// @nodoc
abstract mixin class _$HinduStoryDetailCopyWith<$Res> implements $HinduStoryDetailCopyWith<$Res> {
  factory _$HinduStoryDetailCopyWith(_HinduStoryDetail value, $Res Function(_HinduStoryDetail) _then) = __$HinduStoryDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, int? storyNumber, String title, String summary, String body, String? deityKey, List<String> characters, StoryCollectionRef? collection
});


@override $StoryCollectionRefCopyWith<$Res>? get collection;

}
/// @nodoc
class __$HinduStoryDetailCopyWithImpl<$Res>
    implements _$HinduStoryDetailCopyWith<$Res> {
  __$HinduStoryDetailCopyWithImpl(this._self, this._then);

  final _HinduStoryDetail _self;
  final $Res Function(_HinduStoryDetail) _then;

/// Create a copy of HinduStoryDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storyNumber = freezed,Object? title = null,Object? summary = null,Object? body = null,Object? deityKey = freezed,Object? characters = null,Object? collection = freezed,}) {
  return _then(_HinduStoryDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storyNumber: freezed == storyNumber ? _self.storyNumber : storyNumber // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as StoryCollectionRef?,
  ));
}

/// Create a copy of HinduStoryDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryCollectionRefCopyWith<$Res>? get collection {
    if (_self.collection == null) {
    return null;
  }

  return $StoryCollectionRefCopyWith<$Res>(_self.collection!, (value) {
    return _then(_self.copyWith(collection: value));
  });
}
}

// dart format on
