// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Hadith {

 String get id; String get bookId; int get hadithNumber; String get textArabic; String get textEnglish; String? get chapterTitle; String? get chapterTitleArabic; String? get narratorChain; String? get narratorChainArabic; String? get grade; String? get reference; HadithBook? get book;
/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadithCopyWith<Hadith> get copyWith => _$HadithCopyWithImpl<Hadith>(this as Hadith, _$identity);

  /// Serializes this Hadith to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hadith&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.hadithNumber, hadithNumber) || other.hadithNumber == hadithNumber)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textEnglish, textEnglish) || other.textEnglish == textEnglish)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.chapterTitleArabic, chapterTitleArabic) || other.chapterTitleArabic == chapterTitleArabic)&&(identical(other.narratorChain, narratorChain) || other.narratorChain == narratorChain)&&(identical(other.narratorChainArabic, narratorChainArabic) || other.narratorChainArabic == narratorChainArabic)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.book, book) || other.book == book));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,hadithNumber,textArabic,textEnglish,chapterTitle,chapterTitleArabic,narratorChain,narratorChainArabic,grade,reference,book);

@override
String toString() {
  return 'Hadith(id: $id, bookId: $bookId, hadithNumber: $hadithNumber, textArabic: $textArabic, textEnglish: $textEnglish, chapterTitle: $chapterTitle, chapterTitleArabic: $chapterTitleArabic, narratorChain: $narratorChain, narratorChainArabic: $narratorChainArabic, grade: $grade, reference: $reference, book: $book)';
}


}

/// @nodoc
abstract mixin class $HadithCopyWith<$Res>  {
  factory $HadithCopyWith(Hadith value, $Res Function(Hadith) _then) = _$HadithCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, int hadithNumber, String textArabic, String textEnglish, String? chapterTitle, String? chapterTitleArabic, String? narratorChain, String? narratorChainArabic, String? grade, String? reference, HadithBook? book
});


$HadithBookCopyWith<$Res>? get book;

}
/// @nodoc
class _$HadithCopyWithImpl<$Res>
    implements $HadithCopyWith<$Res> {
  _$HadithCopyWithImpl(this._self, this._then);

  final Hadith _self;
  final $Res Function(Hadith) _then;

/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? hadithNumber = null,Object? textArabic = null,Object? textEnglish = null,Object? chapterTitle = freezed,Object? chapterTitleArabic = freezed,Object? narratorChain = freezed,Object? narratorChainArabic = freezed,Object? grade = freezed,Object? reference = freezed,Object? book = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,hadithNumber: null == hadithNumber ? _self.hadithNumber : hadithNumber // ignore: cast_nullable_to_non_nullable
as int,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textEnglish: null == textEnglish ? _self.textEnglish : textEnglish // ignore: cast_nullable_to_non_nullable
as String,chapterTitle: freezed == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String?,chapterTitleArabic: freezed == chapterTitleArabic ? _self.chapterTitleArabic : chapterTitleArabic // ignore: cast_nullable_to_non_nullable
as String?,narratorChain: freezed == narratorChain ? _self.narratorChain : narratorChain // ignore: cast_nullable_to_non_nullable
as String?,narratorChainArabic: freezed == narratorChainArabic ? _self.narratorChainArabic : narratorChainArabic // ignore: cast_nullable_to_non_nullable
as String?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as HadithBook?,
  ));
}
/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HadithBookCopyWith<$Res>? get book {
    if (_self.book == null) {
    return null;
  }

  return $HadithBookCopyWith<$Res>(_self.book!, (value) {
    return _then(_self.copyWith(book: value));
  });
}
}


/// Adds pattern-matching-related methods to [Hadith].
extension HadithPatterns on Hadith {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hadith() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hadith value)  $default,){
final _that = this;
switch (_that) {
case _Hadith():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hadith value)?  $default,){
final _that = this;
switch (_that) {
case _Hadith() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  int hadithNumber,  String textArabic,  String textEnglish,  String? chapterTitle,  String? chapterTitleArabic,  String? narratorChain,  String? narratorChainArabic,  String? grade,  String? reference,  HadithBook? book)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that.id,_that.bookId,_that.hadithNumber,_that.textArabic,_that.textEnglish,_that.chapterTitle,_that.chapterTitleArabic,_that.narratorChain,_that.narratorChainArabic,_that.grade,_that.reference,_that.book);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  int hadithNumber,  String textArabic,  String textEnglish,  String? chapterTitle,  String? chapterTitleArabic,  String? narratorChain,  String? narratorChainArabic,  String? grade,  String? reference,  HadithBook? book)  $default,) {final _that = this;
switch (_that) {
case _Hadith():
return $default(_that.id,_that.bookId,_that.hadithNumber,_that.textArabic,_that.textEnglish,_that.chapterTitle,_that.chapterTitleArabic,_that.narratorChain,_that.narratorChainArabic,_that.grade,_that.reference,_that.book);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  int hadithNumber,  String textArabic,  String textEnglish,  String? chapterTitle,  String? chapterTitleArabic,  String? narratorChain,  String? narratorChainArabic,  String? grade,  String? reference,  HadithBook? book)?  $default,) {final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that.id,_that.bookId,_that.hadithNumber,_that.textArabic,_that.textEnglish,_that.chapterTitle,_that.chapterTitleArabic,_that.narratorChain,_that.narratorChainArabic,_that.grade,_that.reference,_that.book);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hadith implements Hadith {
  const _Hadith({required this.id, required this.bookId, required this.hadithNumber, required this.textArabic, required this.textEnglish, this.chapterTitle, this.chapterTitleArabic, this.narratorChain, this.narratorChainArabic, this.grade, this.reference, this.book});
  factory _Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);

@override final  String id;
@override final  String bookId;
@override final  int hadithNumber;
@override final  String textArabic;
@override final  String textEnglish;
@override final  String? chapterTitle;
@override final  String? chapterTitleArabic;
@override final  String? narratorChain;
@override final  String? narratorChainArabic;
@override final  String? grade;
@override final  String? reference;
@override final  HadithBook? book;

/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadithCopyWith<_Hadith> get copyWith => __$HadithCopyWithImpl<_Hadith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HadithToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hadith&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.hadithNumber, hadithNumber) || other.hadithNumber == hadithNumber)&&(identical(other.textArabic, textArabic) || other.textArabic == textArabic)&&(identical(other.textEnglish, textEnglish) || other.textEnglish == textEnglish)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.chapterTitleArabic, chapterTitleArabic) || other.chapterTitleArabic == chapterTitleArabic)&&(identical(other.narratorChain, narratorChain) || other.narratorChain == narratorChain)&&(identical(other.narratorChainArabic, narratorChainArabic) || other.narratorChainArabic == narratorChainArabic)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.book, book) || other.book == book));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,hadithNumber,textArabic,textEnglish,chapterTitle,chapterTitleArabic,narratorChain,narratorChainArabic,grade,reference,book);

@override
String toString() {
  return 'Hadith(id: $id, bookId: $bookId, hadithNumber: $hadithNumber, textArabic: $textArabic, textEnglish: $textEnglish, chapterTitle: $chapterTitle, chapterTitleArabic: $chapterTitleArabic, narratorChain: $narratorChain, narratorChainArabic: $narratorChainArabic, grade: $grade, reference: $reference, book: $book)';
}


}

/// @nodoc
abstract mixin class _$HadithCopyWith<$Res> implements $HadithCopyWith<$Res> {
  factory _$HadithCopyWith(_Hadith value, $Res Function(_Hadith) _then) = __$HadithCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, int hadithNumber, String textArabic, String textEnglish, String? chapterTitle, String? chapterTitleArabic, String? narratorChain, String? narratorChainArabic, String? grade, String? reference, HadithBook? book
});


@override $HadithBookCopyWith<$Res>? get book;

}
/// @nodoc
class __$HadithCopyWithImpl<$Res>
    implements _$HadithCopyWith<$Res> {
  __$HadithCopyWithImpl(this._self, this._then);

  final _Hadith _self;
  final $Res Function(_Hadith) _then;

/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? hadithNumber = null,Object? textArabic = null,Object? textEnglish = null,Object? chapterTitle = freezed,Object? chapterTitleArabic = freezed,Object? narratorChain = freezed,Object? narratorChainArabic = freezed,Object? grade = freezed,Object? reference = freezed,Object? book = freezed,}) {
  return _then(_Hadith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,hadithNumber: null == hadithNumber ? _self.hadithNumber : hadithNumber // ignore: cast_nullable_to_non_nullable
as int,textArabic: null == textArabic ? _self.textArabic : textArabic // ignore: cast_nullable_to_non_nullable
as String,textEnglish: null == textEnglish ? _self.textEnglish : textEnglish // ignore: cast_nullable_to_non_nullable
as String,chapterTitle: freezed == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String?,chapterTitleArabic: freezed == chapterTitleArabic ? _self.chapterTitleArabic : chapterTitleArabic // ignore: cast_nullable_to_non_nullable
as String?,narratorChain: freezed == narratorChain ? _self.narratorChain : narratorChain // ignore: cast_nullable_to_non_nullable
as String?,narratorChainArabic: freezed == narratorChainArabic ? _self.narratorChainArabic : narratorChainArabic // ignore: cast_nullable_to_non_nullable
as String?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as HadithBook?,
  ));
}

/// Create a copy of Hadith
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HadithBookCopyWith<$Res>? get book {
    if (_self.book == null) {
    return null;
  }

  return $HadithBookCopyWith<$Res>(_self.book!, (value) {
    return _then(_self.copyWith(book: value));
  });
}
}

// dart format on
