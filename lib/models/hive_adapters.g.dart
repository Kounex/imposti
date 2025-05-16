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
    );
  }

  @override
  void write(BinaryWriter writer, Group obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.imposterSeesCategoryName);
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
