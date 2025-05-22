// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class GroupAdapter extends TypeAdapter<Group> {
  @override
  final int typeId = 1;

  @override
  Group read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Group(
      uuid: fields[0] as String,
      name: fields[1] as String?,
      players:
          fields[2] == null ? const [] : (fields[2] as List).cast<String>(),
      amountMinImposters: fields[3] == null ? 1 : (fields[3] as num).toInt(),
      amountMaxImposters: fields[4] == null ? 1 : (fields[4] as num).toInt(),
      categoryUuids: (fields[6] as List).cast<String>(),
      imposterSeesCategoryName: fields[7] == null ? false : fields[7] as bool,
      zeroImposterMode: fields[8] == null ? false : fields[8] as bool,
      mode: fields[9] == null ? PlayMode.freestyle : fields[9] as PlayMode,
      modeTimeSeconds: fields[10] == null ? 60 : (fields[10] as num).toInt(),
      modeTapMinTaps: fields[11] == null ? 10 : (fields[11] as num).toInt(),
      modeTapMaxTaps: fields[12] == null ? 30 : (fields[12] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Group obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.players)
      ..writeByte(3)
      ..write(obj.amountMinImposters)
      ..writeByte(4)
      ..write(obj.amountMaxImposters)
      ..writeByte(6)
      ..write(obj.categoryUuids)
      ..writeByte(7)
      ..write(obj.imposterSeesCategoryName)
      ..writeByte(8)
      ..write(obj.zeroImposterMode)
      ..writeByte(9)
      ..write(obj.mode)
      ..writeByte(10)
      ..write(obj.modeTimeSeconds)
      ..writeByte(11)
      ..write(obj.modeTapMinTaps)
      ..writeByte(12)
      ..write(obj.modeTapMaxTaps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      uuid: fields[0] as String,
      name: (fields[1] as Map).cast<String, String>(),
      base: fields[2] == null ? false : fields[2] as bool,
      emojiUnicode: fields[4] as String?,
      words:
          fields[3] == null
              ? const {}
              : (fields[3] as Map).map(
                (dynamic k, dynamic v) =>
                    MapEntry(k as String, (v as List).cast<String>()),
              ),
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.base)
      ..writeByte(3)
      ..write(obj.words)
      ..writeByte(4)
      ..write(obj.emojiUnicode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayModeAdapter extends TypeAdapter<PlayMode> {
  @override
  final int typeId = 3;

  @override
  PlayMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlayMode.freestyle;
      case 1:
        return PlayMode.time;
      case 2:
        return PlayMode.tap;
      default:
        return PlayMode.freestyle;
    }
  }

  @override
  void write(BinaryWriter writer, PlayMode obj) {
    switch (obj) {
      case PlayMode.freestyle:
        writer.writeByte(0);
      case PlayMode.time:
        writer.writeByte(1);
      case PlayMode.tap:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
