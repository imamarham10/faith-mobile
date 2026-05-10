// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dhikr_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DhikrGoal {

 String get id; String? get userId; String? get phraseArabic; String? get phraseEnglish; int get targetCount; int get currentCount; DhikrGoalPeriod get period; DateTime? get startDate; DateTime? get endDate; DateTime? get createdAt;
/// Create a copy of DhikrGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DhikrGoalCopyWith<DhikrGoal> get copyWith => _$DhikrGoalCopyWithImpl<DhikrGoal>(this as DhikrGoal, _$identity);

  /// Serializes this DhikrGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DhikrGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseEnglish, phraseEnglish) || other.phraseEnglish == phraseEnglish)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,phraseArabic,phraseEnglish,targetCount,currentCount,period,startDate,endDate,createdAt);

@override
String toString() {
  return 'DhikrGoal(id: $id, userId: $userId, phraseArabic: $phraseArabic, phraseEnglish: $phraseEnglish, targetCount: $targetCount, currentCount: $currentCount, period: $period, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DhikrGoalCopyWith<$Res>  {
  factory $DhikrGoalCopyWith(DhikrGoal value, $Res Function(DhikrGoal) _then) = _$DhikrGoalCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String? phraseArabic, String? phraseEnglish, int targetCount, int currentCount, DhikrGoalPeriod period, DateTime? startDate, DateTime? endDate, DateTime? createdAt
});




}
/// @nodoc
class _$DhikrGoalCopyWithImpl<$Res>
    implements $DhikrGoalCopyWith<$Res> {
  _$DhikrGoalCopyWithImpl(this._self, this._then);

  final DhikrGoal _self;
  final $Res Function(DhikrGoal) _then;

/// Create a copy of DhikrGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? phraseArabic = freezed,Object? phraseEnglish = freezed,Object? targetCount = null,Object? currentCount = null,Object? period = null,Object? startDate = freezed,Object? endDate = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,phraseArabic: freezed == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String?,phraseEnglish: freezed == phraseEnglish ? _self.phraseEnglish : phraseEnglish // ignore: cast_nullable_to_non_nullable
as String?,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DhikrGoalPeriod,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DhikrGoal].
extension DhikrGoalPatterns on DhikrGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DhikrGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DhikrGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DhikrGoal value)  $default,){
final _that = this;
switch (_that) {
case _DhikrGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DhikrGoal value)?  $default,){
final _that = this;
switch (_that) {
case _DhikrGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String? phraseArabic,  String? phraseEnglish,  int targetCount,  int currentCount,  DhikrGoalPeriod period,  DateTime? startDate,  DateTime? endDate,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DhikrGoal() when $default != null:
return $default(_that.id,_that.userId,_that.phraseArabic,_that.phraseEnglish,_that.targetCount,_that.currentCount,_that.period,_that.startDate,_that.endDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String? phraseArabic,  String? phraseEnglish,  int targetCount,  int currentCount,  DhikrGoalPeriod period,  DateTime? startDate,  DateTime? endDate,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DhikrGoal():
return $default(_that.id,_that.userId,_that.phraseArabic,_that.phraseEnglish,_that.targetCount,_that.currentCount,_that.period,_that.startDate,_that.endDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String? phraseArabic,  String? phraseEnglish,  int targetCount,  int currentCount,  DhikrGoalPeriod period,  DateTime? startDate,  DateTime? endDate,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DhikrGoal() when $default != null:
return $default(_that.id,_that.userId,_that.phraseArabic,_that.phraseEnglish,_that.targetCount,_that.currentCount,_that.period,_that.startDate,_that.endDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DhikrGoal implements DhikrGoal {
  const _DhikrGoal({required this.id, this.userId, this.phraseArabic, this.phraseEnglish, required this.targetCount, this.currentCount = 0, required this.period, this.startDate, this.endDate, this.createdAt});
  factory _DhikrGoal.fromJson(Map<String, dynamic> json) => _$DhikrGoalFromJson(json);

@override final  String id;
@override final  String? userId;
@override final  String? phraseArabic;
@override final  String? phraseEnglish;
@override final  int targetCount;
@override@JsonKey() final  int currentCount;
@override final  DhikrGoalPeriod period;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  DateTime? createdAt;

/// Create a copy of DhikrGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DhikrGoalCopyWith<_DhikrGoal> get copyWith => __$DhikrGoalCopyWithImpl<_DhikrGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DhikrGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DhikrGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.phraseArabic, phraseArabic) || other.phraseArabic == phraseArabic)&&(identical(other.phraseEnglish, phraseEnglish) || other.phraseEnglish == phraseEnglish)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,phraseArabic,phraseEnglish,targetCount,currentCount,period,startDate,endDate,createdAt);

@override
String toString() {
  return 'DhikrGoal(id: $id, userId: $userId, phraseArabic: $phraseArabic, phraseEnglish: $phraseEnglish, targetCount: $targetCount, currentCount: $currentCount, period: $period, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DhikrGoalCopyWith<$Res> implements $DhikrGoalCopyWith<$Res> {
  factory _$DhikrGoalCopyWith(_DhikrGoal value, $Res Function(_DhikrGoal) _then) = __$DhikrGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String? phraseArabic, String? phraseEnglish, int targetCount, int currentCount, DhikrGoalPeriod period, DateTime? startDate, DateTime? endDate, DateTime? createdAt
});




}
/// @nodoc
class __$DhikrGoalCopyWithImpl<$Res>
    implements _$DhikrGoalCopyWith<$Res> {
  __$DhikrGoalCopyWithImpl(this._self, this._then);

  final _DhikrGoal _self;
  final $Res Function(_DhikrGoal) _then;

/// Create a copy of DhikrGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? phraseArabic = freezed,Object? phraseEnglish = freezed,Object? targetCount = null,Object? currentCount = null,Object? period = null,Object? startDate = freezed,Object? endDate = freezed,Object? createdAt = freezed,}) {
  return _then(_DhikrGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,phraseArabic: freezed == phraseArabic ? _self.phraseArabic : phraseArabic // ignore: cast_nullable_to_non_nullable
as String?,phraseEnglish: freezed == phraseEnglish ? _self.phraseEnglish : phraseEnglish // ignore: cast_nullable_to_non_nullable
as String?,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DhikrGoalPeriod,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
