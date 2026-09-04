// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutfitRecordAdapter extends TypeAdapter<OutfitRecord> {
  @override
  final int typeId = 2;

  @override
  OutfitRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutfitRecord(
      id: fields[0] as String,
      outfitId: fields[1] as String?,
      clothingIds: (fields[2] as List).cast<String>(),
      date: fields[3] as DateTime,
      weather: fields[4] as String?,
      temperature: fields[5] as int?,
      mood: fields[6] as String?,
      occasion: fields[7] as String?,
      notes: fields[8] as String?,
      imageUrl: fields[9] as String?,
      createdAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OutfitRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.outfitId)
      ..writeByte(2)
      ..write(obj.clothingIds)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.weather)
      ..writeByte(5)
      ..write(obj.temperature)
      ..writeByte(6)
      ..write(obj.mood)
      ..writeByte(7)
      ..write(obj.occasion)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.imageUrl)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutfitRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
