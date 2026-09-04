import 'package:hive/hive.dart';

part 'outfit_record.g.dart';

@HiveType(typeId: 2)
class OutfitRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? outfitId;

  @HiveField(2)
  List<String> clothingIds;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? weather;

  @HiveField(5)
  int? temperature;

  @HiveField(6)
  String? mood; // happy, neutral, tired...

  @HiveField(7)
  String? occasion;

  @HiveField(8)
  String? notes;

  @HiveField(9)
  String? imageUrl;

  @HiveField(10)
  DateTime createdAt;

  OutfitRecord({
    required this.id,
    this.outfitId,
    required this.clothingIds,
    required this.date,
    this.weather,
    this.temperature,
    this.mood,
    this.occasion,
    this.notes,
    this.imageUrl,
    required this.createdAt,
  });
}
