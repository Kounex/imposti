// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
  uuid: json['uuid'] as String,
  name: json['name'] as String?,
  players:
      (json['players'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  amountMinImposters: (json['amountMinImposters'] as num?)?.toInt() ?? 1,
  amountMaxImposters: (json['amountMaxImposters'] as num?)?.toInt() ?? 1,
  categoryUuids:
      (json['categoryUuids'] as List<dynamic>).map((e) => e as String).toList(),
  imposterSeesCategoryName: json['imposterSeesCategoryName'] as bool? ?? false,
);

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'players': instance.players,
  'amountMinImposters': instance.amountMinImposters,
  'amountMaxImposters': instance.amountMaxImposters,
  'categoryUuids': instance.categoryUuids,
  'imposterSeesCategoryName': instance.imposterSeesCategoryName,
};
