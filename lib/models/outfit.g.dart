// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutfitAdapter extends TypeAdapter<Outfit> {
  @override
  final int typeId = 1;

  @override
  Outfit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Outfit(
      id: fields[0] as String,
      name: fields[1] as String,
      clothingIds: (fields[2] as List).cast<String>(),
      occasion: fields[3] as String?,
      season: fields[4] as String?,
      weather: fields[5] as String?,
      description: fields[6] as String?,
      generatedImageUrl: fields[7] as String?,
      isAiGenerated: fields[8] as bool,
      aiPrompt: fields[9] as String?,
      wearCount: fields[10] as int,
      lastWearDate: fields[11] as DateTime?,
      isFavorite: fields[12] as bool,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Outfit obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.clothingIds)
      ..writeByte(3)
      ..write(obj.occasion)
      ..writeByte(4)
      ..write(obj.season)
      ..writeByte(5)
      ..write(obj.weather)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.generatedImageUrl)
      ..writeByte(8)
      ..write(obj.isAiGenerated)
      ..writeByte(9)
      ..write(obj.aiPrompt)
      ..writeByte(10)
      ..write(obj.wearCount)
      ..writeByte(11)
      ..write(obj.lastWearDate)
      ..writeByte(12)
      ..write(obj.isFavorite)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutfitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
