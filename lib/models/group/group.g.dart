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
  zeroImposterMode: json['zeroImposterMode'] as bool? ?? false,
  mode:
      $enumDecodeNullable(_$PlayModeEnumMap, json['mode']) ??
      PlayMode.freestyle,
  modeTimeSeconds: (json['modeTimeSeconds'] as num?)?.toInt() ?? 60,
  modeTapMinTaps: (json['modeTapMinTaps'] as num?)?.toInt() ?? 10,
  modeTapMaxTaps: (json['modeTapMaxTaps'] as num?)?.toInt() ?? 30,
);

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'players': instance.players,
  'amountMinImposters': instance.amountMinImposters,
  'amountMaxImposters': instance.amountMaxImposters,
  'categoryUuids': instance.categoryUuids,
  'imposterSeesCategoryName': instance.imposterSeesCategoryName,
  'zeroImposterMode': instance.zeroImposterMode,
  'mode': _$PlayModeEnumMap[instance.mode]!,
  'modeTimeSeconds': instance.modeTimeSeconds,
  'modeTapMinTaps': instance.modeTapMinTaps,
  'modeTapMaxTaps': instance.modeTapMaxTaps,
};

const _$PlayModeEnumMap = {
  PlayMode.freestyle: 'freestyle',
  PlayMode.time: 'time',
  PlayMode.tap: 'tap',
};
