// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HadithBook {

// List endpoints (`/hadiths` paginated feed) embed a slim `{name, nameArabic}`
// projection without `id` — keep nullable so json_serializable doesn't
// throw a TypeError on the null cast.
 String? get id; String get name; String? get nameArabic; String? get author; String? get authorArabic; int get totalHadiths; bool get isPremium; String? get description; int get sortOrder;
/// Create a copy of HadithBook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadithBookCopyWith<HadithBook> get copyWith => _$HadithBookCopyWithImpl<HadithBook>(this as HadithBook, _$identity);

  /// Serializes this HadithBook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadithBook&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.author, author) || other.author == author)&&(identical(other.authorArabic, authorArabic) || other.authorArabic == authorArabic)&&(identical(other.totalHadiths, totalHadiths) || other.totalHadiths == totalHadiths)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.description, description) || other.description == description)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameArabic,author,authorArabic,totalHadiths,isPremium,description,sortOrder);

@override
String toString() {
  return 'HadithBook(id: $id, name: $name, nameArabic: $nameArabic, author: $author, authorArabic: $authorArabic, totalHadiths: $totalHadiths, isPremium: $isPremium, description: $description, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $HadithBookCopyWith<$Res>  {
  factory $HadithBookCopyWith(HadithBook value, $Res Function(HadithBook) _then) = _$HadithBookCopyWithImpl;
@useResult
$Res call({
 String? id, String name, String? nameArabic, String? author, String? authorArabic, int totalHadiths, bool isPremium, String? description, int sortOrder
});




}
/// @nodoc
class _$HadithBookCopyWithImpl<$Res>
    implements $HadithBookCopyWith<$Res> {
  _$HadithBookCopyWithImpl(this._self, this._then);

  final HadithBook _self;
  final $Res Function(HadithBook) _then;

/// Create a copy of HadithBook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? nameArabic = freezed,Object? author = freezed,Object? authorArabic = freezed,Object? totalHadiths = null,Object? isPremium = null,Object? description = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameArabic: freezed == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorArabic: freezed == authorArabic ? _self.authorArabic : authorArabic // ignore: cast_nullable_to_non_nullable
as String?,totalHadiths: null == totalHadiths ? _self.totalHadiths : totalHadiths // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HadithBook].
extension HadithBookPatterns on HadithBook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadithBook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadithBook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadithBook value)  $default,){
final _that = this;
switch (_that) {
case _HadithBook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadithBook value)?  $default,){
final _that = this;
switch (_that) {
case _HadithBook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  String? nameArabic,  String? author,  String? authorArabic,  int totalHadiths,  bool isPremium,  String? description,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadithBook() when $default != null:
return $default(_that.id,_that.name,_that.nameArabic,_that.author,_that.authorArabic,_that.totalHadiths,_that.isPremium,_that.description,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  String? nameArabic,  String? author,  String? authorArabic,  int totalHadiths,  bool isPremium,  String? description,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _HadithBook():
return $default(_that.id,_that.name,_that.nameArabic,_that.author,_that.authorArabic,_that.totalHadiths,_that.isPremium,_that.description,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  String? nameArabic,  String? author,  String? authorArabic,  int totalHadiths,  bool isPremium,  String? description,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _HadithBook() when $default != null:
return $default(_that.id,_that.name,_that.nameArabic,_that.author,_that.authorArabic,_that.totalHadiths,_that.isPremium,_that.description,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HadithBook implements HadithBook {
  const _HadithBook({this.id, required this.name, this.nameArabic, this.author, this.authorArabic, this.totalHadiths = 0, this.isPremium = false, this.description, this.sortOrder = 0});
  factory _HadithBook.fromJson(Map<String, dynamic> json) => _$HadithBookFromJson(json);

// List endpoints (`/hadiths` paginated feed) embed a slim `{name, nameArabic}`
// projection without `id` — keep nullable so json_serializable doesn't
// throw a TypeError on the null cast.
@override final  String? id;
@override final  String name;
@override final  String? nameArabic;
@override final  String? author;
@override final  String? authorArabic;
@override@JsonKey() final  int totalHadiths;
@override@JsonKey() final  bool isPremium;
@override final  String? description;
@override@JsonKey() final  int sortOrder;

/// Create a copy of HadithBook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadithBookCopyWith<_HadithBook> get copyWith => __$HadithBookCopyWithImpl<_HadithBook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HadithBookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadithBook&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameArabic, nameArabic) || other.nameArabic == nameArabic)&&(identical(other.author, author) || other.author == author)&&(identical(other.authorArabic, authorArabic) || other.authorArabic == authorArabic)&&(identical(other.totalHadiths, totalHadiths) || other.totalHadiths == totalHadiths)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.description, description) || other.description == description)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameArabic,author,authorArabic,totalHadiths,isPremium,description,sortOrder);

@override
String toString() {
  return 'HadithBook(id: $id, name: $name, nameArabic: $nameArabic, author: $author, authorArabic: $authorArabic, totalHadiths: $totalHadiths, isPremium: $isPremium, description: $description, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$HadithBookCopyWith<$Res> implements $HadithBookCopyWith<$Res> {
  factory _$HadithBookCopyWith(_HadithBook value, $Res Function(_HadithBook) _then) = __$HadithBookCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, String? nameArabic, String? author, String? authorArabic, int totalHadiths, bool isPremium, String? description, int sortOrder
});




}
/// @nodoc
class __$HadithBookCopyWithImpl<$Res>
    implements _$HadithBookCopyWith<$Res> {
  __$HadithBookCopyWithImpl(this._self, this._then);

  final _HadithBook _self;
  final $Res Function(_HadithBook) _then;

/// Create a copy of HadithBook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? nameArabic = freezed,Object? author = freezed,Object? authorArabic = freezed,Object? totalHadiths = null,Object? isPremium = null,Object? description = freezed,Object? sortOrder = null,}) {
  return _then(_HadithBook(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameArabic: freezed == nameArabic ? _self.nameArabic : nameArabic // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorArabic: freezed == authorArabic ? _self.authorArabic : authorArabic // ignore: cast_nullable_to_non_nullable
as String?,totalHadiths: null == totalHadiths ? _self.totalHadiths : totalHadiths // ignore: cast_nullable_to_non_nullable
as int,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
