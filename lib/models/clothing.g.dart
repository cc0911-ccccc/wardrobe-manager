// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothingAdapter extends TypeAdapter<Clothing> {
  @override
  final int typeId = 0;

  @override
  Clothing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Clothing(
      id: fields[0] as String,
      imageUrl: fields[1] as String,
      category: fields[2] as String,
      subCategory: fields[3] as String,
      color: fields[4] as String,
      pattern: fields[5] as String?,
      styles: (fields[6] as List).cast<String>(),
      seasons: (fields[7] as List).cast<String>(),
      brand: fields[8] as String?,
      size: fields[9] as String?,
      price: fields[10] as double?,
      purchaseDate: fields[11] as DateTime?,
      locationStatus: fields[12] as String,
      locationRoom: fields[13] as String?,
      locationFurniture: fields[14] as String?,
      wearCount: fields[15] as int,
      lastWearDate: fields[16] as DateTime?,
      createdAt: fields[17] as DateTime,
      updatedAt: fields[18] as DateTime?,
      tags: (fields[19] as List).cast<String>(),
      isFavorite: fields[20] as bool,
      notes: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Clothing obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.subCategory)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.pattern)
      ..writeByte(6)
      ..write(obj.styles)
      ..writeByte(7)
      ..write(obj.seasons)
      ..writeByte(8)
      ..write(obj.brand)
      ..writeByte(9)
      ..write(obj.size)
      ..writeByte(10)
      ..write(obj.price)
      ..writeByte(11)
      ..write(obj.purchaseDate)
      ..writeByte(12)
      ..write(obj.locationStatus)
      ..writeByte(13)
      ..write(obj.locationRoom)
      ..writeByte(14)
      ..write(obj.locationFurniture)
      ..writeByte(15)
      ..write(obj.wearCount)
      ..writeByte(16)
      ..write(obj.lastWearDate)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt)
      ..writeByte(19)
      ..write(obj.tags)
      ..writeByte(20)
      ..write(obj.isFavorite)
      ..writeByte(21)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
