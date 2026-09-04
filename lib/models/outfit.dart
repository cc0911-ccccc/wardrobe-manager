import 'package:hive/hive.dart';

part 'outfit.g.dart';

@HiveType(typeId: 1)
class Outfit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> clothingIds;

  @HiveField(3)
  String? occasion; // casual, dating, interview, party...

  @HiveField(4)
  String? season;

  @HiveField(5)
  String? weather;

  @HiveField(6)
  String? description;

  @HiveField(7)
  String? generatedImageUrl;

  @HiveField(8)
  bool isAiGenerated;

  @HiveField(9)
  String? aiPrompt;

  @HiveField(10)
  int wearCount;

  @HiveField(11)
  DateTime? lastWearDate;

  @HiveField(12)
  bool isFavorite;

  @HiveField(13)
  DateTime createdAt;

  @HiveField(14)
  DateTime? updatedAt;

  Outfit({
    required this.id,
    required this.name,
    required this.clothingIds,
    this.occasion,
    this.season,
    this.weather,
    this.description,
    this.generatedImageUrl,
    this.isAiGenerated = false,
    this.aiPrompt,
    this.wearCount = 0,
    this.lastWearDate,
    this.isFavorite = false,
    required this.createdAt,
    this.updatedAt,
  });

  void incrementWearCount() {
    wearCount++;
    lastWearDate = DateTime.now();
    updatedAt = DateTime.now();
    save();
  }
}
