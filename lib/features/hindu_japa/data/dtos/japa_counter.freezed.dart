// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'japa_counter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JapaCounter {

 String get id; String? get userId; String get name; String? get mantraSanskrit; String? get mantraEnglish; int get count; int? get targetCount; String? get deityKey; bool get isActive; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of JapaCounter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JapaCounterCopyWith<JapaCounter> get copyWith => _$JapaCounterCopyWithImpl<JapaCounter>(this as JapaCounter, _$identity);

  /// Serializes this JapaCounter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JapaCounter&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.mantraSanskrit, mantraSanskrit) || other.mantraSanskrit == mantraSanskrit)&&(identical(other.mantraEnglish, mantraEnglish) || other.mantraEnglish == mantraEnglish)&&(identical(other.count, count) || other.count == count)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,mantraSanskrit,mantraEnglish,count,targetCount,deityKey,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'JapaCounter(id: $id, userId: $userId, name: $name, mantraSanskrit: $mantraSanskrit, mantraEnglish: $mantraEnglish, count: $count, targetCount: $targetCount, deityKey: $deityKey, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JapaCounterCopyWith<$Res>  {
  factory $JapaCounterCopyWith(JapaCounter value, $Res Function(JapaCounter) _then) = _$JapaCounterCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String name, String? mantraSanskrit, String? mantraEnglish, int count, int? targetCount, String? deityKey, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$JapaCounterCopyWithImpl<$Res>
    implements $JapaCounterCopyWith<$Res> {
  _$JapaCounterCopyWithImpl(this._self, this._then);

  final JapaCounter _self;
  final $Res Function(JapaCounter) _then;

/// Create a copy of JapaCounter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? mantraSanskrit = freezed,Object? mantraEnglish = freezed,Object? count = null,Object? targetCount = freezed,Object? deityKey = freezed,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mantraSanskrit: freezed == mantraSanskrit ? _self.mantraSanskrit : mantraSanskrit // ignore: cast_nullable_to_non_nullable
as String?,mantraEnglish: freezed == mantraEnglish ? _self.mantraEnglish : mantraEnglish // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,targetCount: freezed == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int?,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JapaCounter].
extension JapaCounterPatterns on JapaCounter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JapaCounter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JapaCounter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JapaCounter value)  $default,){
final _that = this;
switch (_that) {
case _JapaCounter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JapaCounter value)?  $default,){
final _that = this;
switch (_that) {
case _JapaCounter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String name,  String? mantraSanskrit,  String? mantraEnglish,  int count,  int? targetCount,  String? deityKey,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JapaCounter() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.mantraSanskrit,_that.mantraEnglish,_that.count,_that.targetCount,_that.deityKey,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String name,  String? mantraSanskrit,  String? mantraEnglish,  int count,  int? targetCount,  String? deityKey,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JapaCounter():
return $default(_that.id,_that.userId,_that.name,_that.mantraSanskrit,_that.mantraEnglish,_that.count,_that.targetCount,_that.deityKey,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String name,  String? mantraSanskrit,  String? mantraEnglish,  int count,  int? targetCount,  String? deityKey,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JapaCounter() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.mantraSanskrit,_that.mantraEnglish,_that.count,_that.targetCount,_that.deityKey,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JapaCounter implements JapaCounter {
  const _JapaCounter({required this.id, this.userId, required this.name, this.mantraSanskrit, this.mantraEnglish, this.count = 0, this.targetCount, this.deityKey, this.isActive = true, this.createdAt, this.updatedAt});
  factory _JapaCounter.fromJson(Map<String, dynamic> json) => _$JapaCounterFromJson(json);

@override final  String id;
@override final  String? userId;
@override final  String name;
@override final  String? mantraSanskrit;
@override final  String? mantraEnglish;
@override@JsonKey() final  int count;
@override final  int? targetCount;
@override final  String? deityKey;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of JapaCounter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JapaCounterCopyWith<_JapaCounter> get copyWith => __$JapaCounterCopyWithImpl<_JapaCounter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JapaCounterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JapaCounter&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.mantraSanskrit, mantraSanskrit) || other.mantraSanskrit == mantraSanskrit)&&(identical(other.mantraEnglish, mantraEnglish) || other.mantraEnglish == mantraEnglish)&&(identical(other.count, count) || other.count == count)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.deityKey, deityKey) || other.deityKey == deityKey)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,mantraSanskrit,mantraEnglish,count,targetCount,deityKey,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'JapaCounter(id: $id, userId: $userId, name: $name, mantraSanskrit: $mantraSanskrit, mantraEnglish: $mantraEnglish, count: $count, targetCount: $targetCount, deityKey: $deityKey, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JapaCounterCopyWith<$Res> implements $JapaCounterCopyWith<$Res> {
  factory _$JapaCounterCopyWith(_JapaCounter value, $Res Function(_JapaCounter) _then) = __$JapaCounterCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String name, String? mantraSanskrit, String? mantraEnglish, int count, int? targetCount, String? deityKey, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$JapaCounterCopyWithImpl<$Res>
    implements _$JapaCounterCopyWith<$Res> {
  __$JapaCounterCopyWithImpl(this._self, this._then);

  final _JapaCounter _self;
  final $Res Function(_JapaCounter) _then;

/// Create a copy of JapaCounter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? mantraSanskrit = freezed,Object? mantraEnglish = freezed,Object? count = null,Object? targetCount = freezed,Object? deityKey = freezed,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_JapaCounter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mantraSanskrit: freezed == mantraSanskrit ? _self.mantraSanskrit : mantraSanskrit // ignore: cast_nullable_to_non_nullable
as String?,mantraEnglish: freezed == mantraEnglish ? _self.mantraEnglish : mantraEnglish // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,targetCount: freezed == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int?,deityKey: freezed == deityKey ? _self.deityKey : deityKey // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
