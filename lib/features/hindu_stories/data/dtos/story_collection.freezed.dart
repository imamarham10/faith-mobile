// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryCollection {

 String get id; String get slug; String get name; String get sourceText; bool get isPremium; DateTime? get createdAt; int get storyCount;
/// Create a copy of StoryCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCollectionCopyWith<StoryCollection> get copyWith => _$StoryCollectionCopyWithImpl<StoryCollection>(this as StoryCollection, _$identity);

  /// Serializes this StoryCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.storyCount, storyCount) || other.storyCount == storyCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,sourceText,isPremium,createdAt,storyCount);

@override
String toString() {
  return 'StoryCollection(id: $id, slug: $slug, name: $name, sourceText: $sourceText, isPremium: $isPremium, createdAt: $createdAt, storyCount: $storyCount)';
}


}

/// @nodoc
abstract mixin class $StoryCollectionCopyWith<$Res>  {
  factory $StoryCollectionCopyWith(StoryCollection value, $Res Function(StoryCollection) _then) = _$StoryCollectionCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String sourceText, bool isPremium, DateTime? createdAt, int storyCount
});




}
/// @nodoc
class _$StoryCollectionCopyWithImpl<$Res>
    implements $StoryCollectionCopyWith<$Res> {
  _$StoryCollectionCopyWithImpl(this._self, this._then);

  final StoryCollection _self;
  final $Res Function(StoryCollection) _then;

/// Create a copy of StoryCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? sourceText = null,Object? isPremium = null,Object? createdAt = freezed,Object? storyCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,storyCount: null == storyCount ? _self.storyCount : storyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryCollection].
extension StoryCollectionPatterns on StoryCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryCollection value)  $default,){
final _that = this;
switch (_that) {
case _StoryCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryCollection value)?  $default,){
final _that = this;
switch (_that) {
case _StoryCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String sourceText,  bool isPremium,  DateTime? createdAt,  int storyCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryCollection() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.sourceText,_that.isPremium,_that.createdAt,_that.storyCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String sourceText,  bool isPremium,  DateTime? createdAt,  int storyCount)  $default,) {final _that = this;
switch (_that) {
case _StoryCollection():
return $default(_that.id,_that.slug,_that.name,_that.sourceText,_that.isPremium,_that.createdAt,_that.storyCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String sourceText,  bool isPremium,  DateTime? createdAt,  int storyCount)?  $default,) {final _that = this;
switch (_that) {
case _StoryCollection() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.sourceText,_that.isPremium,_that.createdAt,_that.storyCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoryCollection implements StoryCollection {
  const _StoryCollection({required this.id, required this.slug, required this.name, required this.sourceText, this.isPremium = false, this.createdAt, this.storyCount = 0});
  factory _StoryCollection.fromJson(Map<String, dynamic> json) => _$StoryCollectionFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String name;
@override final  String sourceText;
@override@JsonKey() final  bool isPremium;
@override final  DateTime? createdAt;
@override@JsonKey() final  int storyCount;

/// Create a copy of StoryCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryCollectionCopyWith<_StoryCollection> get copyWith => __$StoryCollectionCopyWithImpl<_StoryCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.storyCount, storyCount) || other.storyCount == storyCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,name,sourceText,isPremium,createdAt,storyCount);

@override
String toString() {
  return 'StoryCollection(id: $id, slug: $slug, name: $name, sourceText: $sourceText, isPremium: $isPremium, createdAt: $createdAt, storyCount: $storyCount)';
}


}

/// @nodoc
abstract mixin class _$StoryCollectionCopyWith<$Res> implements $StoryCollectionCopyWith<$Res> {
  factory _$StoryCollectionCopyWith(_StoryCollection value, $Res Function(_StoryCollection) _then) = __$StoryCollectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String sourceText, bool isPremium, DateTime? createdAt, int storyCount
});




}
/// @nodoc
class __$StoryCollectionCopyWithImpl<$Res>
    implements _$StoryCollectionCopyWith<$Res> {
  __$StoryCollectionCopyWithImpl(this._self, this._then);

  final _StoryCollection _self;
  final $Res Function(_StoryCollection) _then;

/// Create a copy of StoryCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? sourceText = null,Object? isPremium = null,Object? createdAt = freezed,Object? storyCount = null,}) {
  return _then(_StoryCollection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,storyCount: null == storyCount ? _self.storyCount : storyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StoryCollectionRef {

 String get slug; String get name; String get sourceText;
/// Create a copy of StoryCollectionRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCollectionRefCopyWith<StoryCollectionRef> get copyWith => _$StoryCollectionRefCopyWithImpl<StoryCollectionRef>(this as StoryCollectionRef, _$identity);

  /// Serializes this StoryCollectionRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryCollectionRef&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,sourceText);

@override
String toString() {
  return 'StoryCollectionRef(slug: $slug, name: $name, sourceText: $sourceText)';
}


}

/// @nodoc
abstract mixin class $StoryCollectionRefCopyWith<$Res>  {
  factory $StoryCollectionRefCopyWith(StoryCollectionRef value, $Res Function(StoryCollectionRef) _then) = _$StoryCollectionRefCopyWithImpl;
@useResult
$Res call({
 String slug, String name, String sourceText
});




}
/// @nodoc
class _$StoryCollectionRefCopyWithImpl<$Res>
    implements $StoryCollectionRefCopyWith<$Res> {
  _$StoryCollectionRefCopyWithImpl(this._self, this._then);

  final StoryCollectionRef _self;
  final $Res Function(StoryCollectionRef) _then;

/// Create a copy of StoryCollectionRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? name = null,Object? sourceText = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryCollectionRef].
extension StoryCollectionRefPatterns on StoryCollectionRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryCollectionRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryCollectionRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryCollectionRef value)  $default,){
final _that = this;
switch (_that) {
case _StoryCollectionRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryCollectionRef value)?  $default,){
final _that = this;
switch (_that) {
case _StoryCollectionRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String name,  String sourceText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryCollectionRef() when $default != null:
return $default(_that.slug,_that.name,_that.sourceText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String name,  String sourceText)  $default,) {final _that = this;
switch (_that) {
case _StoryCollectionRef():
return $default(_that.slug,_that.name,_that.sourceText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String name,  String sourceText)?  $default,) {final _that = this;
switch (_that) {
case _StoryCollectionRef() when $default != null:
return $default(_that.slug,_that.name,_that.sourceText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoryCollectionRef implements StoryCollectionRef {
  const _StoryCollectionRef({required this.slug, required this.name, required this.sourceText});
  factory _StoryCollectionRef.fromJson(Map<String, dynamic> json) => _$StoryCollectionRefFromJson(json);

@override final  String slug;
@override final  String name;
@override final  String sourceText;

/// Create a copy of StoryCollectionRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryCollectionRefCopyWith<_StoryCollectionRef> get copyWith => __$StoryCollectionRefCopyWithImpl<_StoryCollectionRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryCollectionRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryCollectionRef&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,name,sourceText);

@override
String toString() {
  return 'StoryCollectionRef(slug: $slug, name: $name, sourceText: $sourceText)';
}


}

/// @nodoc
abstract mixin class _$StoryCollectionRefCopyWith<$Res> implements $StoryCollectionRefCopyWith<$Res> {
  factory _$StoryCollectionRefCopyWith(_StoryCollectionRef value, $Res Function(_StoryCollectionRef) _then) = __$StoryCollectionRefCopyWithImpl;
@override @useResult
$Res call({
 String slug, String name, String sourceText
});




}
/// @nodoc
class __$StoryCollectionRefCopyWithImpl<$Res>
    implements _$StoryCollectionRefCopyWith<$Res> {
  __$StoryCollectionRefCopyWithImpl(this._self, this._then);

  final _StoryCollectionRef _self;
  final $Res Function(_StoryCollectionRef) _then;

/// Create a copy of StoryCollectionRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? name = null,Object? sourceText = null,}) {
  return _then(_StoryCollectionRef(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
