// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  uuid: json['uuid'] as String,
  name: Map<String, String>.from(json['name'] as Map),
  base: json['base'] as bool? ?? false,
  emojiUnicode: json['emojiUnicode'] as String?,
  words:
      (json['words'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      const {},
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'base': instance.base,
  'emojiUnicode': instance.emojiUnicode,
  'words': instance.words,
};
