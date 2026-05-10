// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dhikr_counter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DhikrCounter {

 String get id; String? get userId; String get name; String? get phraseArabic; String? get phraseEnglish; String? get phraseTransliteration; String? get meaning; int get count; int get targetCount; bool get isActive; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of DhikrCounter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DhikrCounterCopyWith<DhikrCounter> get copyWith => _$DhikrCounterCopyWithImpl<DhikrCounter>(this as DhikrCounter, _$identity);

  /// Serializes this DhikrCounter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DhikrCounter&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseEnglish, phraseEnglish) || other.phraseEnglish == phraseEnglish)&&(identical(other.phraseTransliteration, phraseTransliteration) || other.phraseTransliteration == phraseTransliteration)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.count, count) || other.count == count)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,phraseArabic,phraseEnglish,phraseTransliteration,meaning,count,targetCount,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'DhikrCounter(id: $id, userId: $userId, name: $name, phraseArabic: $phraseArabic, phraseEnglish: $phraseEnglish, phraseTransliteration: $phraseTransliteration, meaning: $meaning, count: $count, targetCount: $targetCount, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DhikrCounterCopyWith<$Res>  {
  factory $DhikrCounterCopyWith(DhikrCounter value, $Res Function(DhikrCounter) _then) = _$DhikrCounterCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String name, String? phraseArabic, String? phraseEnglish, String? phraseTransliteration, String? meaning, int count, int targetCount, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$DhikrCounterCopyWithImpl<$Res>
    implements $DhikrCounterCopyWith<$Res> {
  _$DhikrCounterCopyWithImpl(this._self, this._then);

  final DhikrCounter _self;
  final $Res Function(DhikrCounter) _then;

/// Create a copy of DhikrCounter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? phraseArabic = freezed,Object? phraseEnglish = freezed,Object? phraseTransliteration = freezed,Object? meaning = freezed,Object? count = null,Object? targetCount = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phraseArabic: freezed == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String?,phraseEnglish: freezed == phraseEnglish ? _self.phraseEnglish : phraseEnglish // ignore: cast_nullable_to_non_nullable
as String?,phraseTransliteration: freezed == phraseTransliteration ? _self.phraseTransliteration : phraseTransliteration // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DhikrCounter].
extension DhikrCounterPatterns on DhikrCounter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DhikrCounter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DhikrCounter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DhikrCounter value)  $default,){
final _that = this;
switch (_that) {
case _DhikrCounter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DhikrCounter value)?  $default,){
final _that = this;
switch (_that) {
case _DhikrCounter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String name,  String? phraseArabic,  String? phraseEnglish,  String? phraseTransliteration,  String? meaning,  int count,  int targetCount,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DhikrCounter() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.phraseArabic,_that.phraseEnglish,_that.phraseTransliteration,_that.meaning,_that.count,_that.targetCount,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String name,  String? phraseArabic,  String? phraseEnglish,  String? phraseTransliteration,  String? meaning,  int count,  int targetCount,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DhikrCounter():
return $default(_that.id,_that.userId,_that.name,_that.phraseArabic,_that.phraseEnglish,_that.phraseTransliteration,_that.meaning,_that.count,_that.targetCount,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String name,  String? phraseArabic,  String? phraseEnglish,  String? phraseTransliteration,  String? meaning,  int count,  int targetCount,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DhikrCounter() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.phraseArabic,_that.phraseEnglish,_that.phraseTransliteration,_that.meaning,_that.count,_that.targetCount,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DhikrCounter implements DhikrCounter {
  const _DhikrCounter({required this.id, this.userId, required this.name, this.phraseArabic, this.phraseEnglish, this.phraseTransliteration, this.meaning, this.count = 0, this.targetCount = 33, this.isActive = true, this.createdAt, this.updatedAt});
  factory _DhikrCounter.fromJson(Map<String, dynamic> json) => _$DhikrCounterFromJson(json);

@override final  String id;
@override final  String? userId;
@override final  String name;
@override final  String? phraseArabic;
@override final  String? phraseEnglish;
@override final  String? phraseTransliteration;
@override final  String? meaning;
@override@JsonKey() final  int count;
@override@JsonKey() final  int targetCount;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of DhikrCounter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DhikrCounterCopyWith<_DhikrCounter> get copyWith => __$DhikrCounterCopyWithImpl<_DhikrCounter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DhikrCounterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DhikrCounter&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseEnglish, phraseEnglish) || other.phraseEnglish == phraseEnglish)&&(identical(other.phraseTransliteration, phraseTransliteration) || other.phraseTransliteration == phraseTransliteration)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.count, count) || other.count == count)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,phraseArabic,phraseEnglish,phraseTransliteration,meaning,count,targetCount,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'DhikrCounter(id: $id, userId: $userId, name: $name, phraseArabic: $phraseArabic, phraseEnglish: $phraseEnglish, phraseTransliteration: $phraseTransliteration, meaning: $meaning, count: $count, targetCount: $targetCount, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DhikrCounterCopyWith<$Res> implements $DhikrCounterCopyWith<$Res> {
  factory _$DhikrCounterCopyWith(_DhikrCounter value, $Res Function(_DhikrCounter) _then) = __$DhikrCounterCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String name, String? phraseArabic, String? phraseEnglish, String? phraseTransliteration, String? meaning, int count, int targetCount, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$DhikrCounterCopyWithImpl<$Res>
    implements _$DhikrCounterCopyWith<$Res> {
  __$DhikrCounterCopyWithImpl(this._self, this._then);

  final _DhikrCounter _self;
  final $Res Function(_DhikrCounter) _then;

/// Create a copy of DhikrCounter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? name = null,Object? phraseArabic = freezed,Object? phraseEnglish = freezed,Object? phraseTransliteration = freezed,Object? meaning = freezed,Object? count = null,Object? targetCount = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_DhikrCounter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phraseArabic: freezed == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String?,phraseEnglish: freezed == phraseEnglish ? _self.phraseEnglish : phraseEnglish // ignore: cast_nullable_to_non_nullable
as String?,phraseTransliteration: freezed == phraseTransliteration ? _self.phraseTransliteration : phraseTransliteration // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
