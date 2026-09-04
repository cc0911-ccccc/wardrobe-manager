// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      nickname: fields[0] as String?,
      avatarUrl: fields[1] as String?,
      gender: fields[2] as String?,
      height: fields[3] as int?,
      weight: fields[4] as int?,
      stylePreferences: (fields[5] as List).cast<String>(),
      totalClothes: fields[6] as int,
      totalOutfits: fields[7] as int,
      totalWearDays: fields[8] as int,
      streakDays: fields[9] as int,
      lastActiveDate: fields[10] as DateTime?,
      points: fields[11] as int,
      achievements: (fields[12] as List).cast<String>(),
      createdAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.nickname)
      ..writeByte(1)
      ..write(obj.avatarUrl)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.stylePreferences)
      ..writeByte(6)
      ..write(obj.totalClothes)
      ..writeByte(7)
      ..write(obj.totalOutfits)
      ..writeByte(8)
      ..write(obj.totalWearDays)
      ..writeByte(9)
      ..write(obj.streakDays)
      ..writeByte(10)
      ..write(obj.lastActiveDate)
      ..writeByte(11)
      ..write(obj.points)
      ..writeByte(12)
      ..write(obj.achievements)
      ..writeByte(13)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
