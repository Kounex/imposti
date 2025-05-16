// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Category {

 String get uuid; Map<String, String> get name; bool get base; String? get emojiUnicode; Map<String, List<String>> get words;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.uuid, uuid) || other.uuid == uuid)&&const DeepCollectionEquality().equals(other.name, name)&&(identical(other.base, base) || other.base == base)&&(identical(other.emojiUnicode, emojiUnicode) || other.emojiUnicode == emojiUnicode)&&const DeepCollectionEquality().equals(other.words, words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,const DeepCollectionEquality().hash(name),base,emojiUnicode,const DeepCollectionEquality().hash(words));

@override
String toString() {
  return 'Category(uuid: $uuid, name: $name, base: $base, emojiUnicode: $emojiUnicode, words: $words)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String uuid, Map<String, String> name, bool base, String? emojiUnicode, Map<String, List<String>> words
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? name = null,Object? base = null,Object? emojiUnicode = freezed,Object? words = null,}) {
  return _then(Category(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as Map<String, String>,base: null == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as bool,emojiUnicode: freezed == emojiUnicode ? _self.emojiUnicode : emojiUnicode // ignore: cast_nullable_to_non_nullable
as String?,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}

}


// dart format on
