import 'package:hive/hive.dart';

part 'clothing.g.dart';

@HiveType(typeId: 0)
class Clothing extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String imageUrl;

  @HiveField(2)
  String category; // tops, bottoms, dress, outerwear, shoes, accessories

  @HiveField(3)
  String subCategory; // t-shirt, jeans, skirt, coat...

  @HiveField(4)
  String color;

  @HiveField(5)
  String? pattern; // solid, striped, plaid, printed...

  @HiveField(6)
  List<String> styles; // casual, formal, sporty, dating...

  @HiveField(7)
  List<String> seasons; // spring, summer, autumn, winter

  @HiveField(8)
  String? brand;

  @HiveField(9)
  String? size;

  @HiveField(10)
  double? price;

  @HiveField(11)
  DateTime? purchaseDate;

  @HiveField(12)
  String locationStatus; // in_wardrobe, washing, wearing, storage

  @HiveField(13)
  String? locationRoom;

  @HiveField(14)
  String? locationFurniture;

  @HiveField(15)
  int wearCount;

  @HiveField(16)
  DateTime? lastWearDate;

  @HiveField(17)
  DateTime createdAt;

  @HiveField(18)
  DateTime? updatedAt;

  @HiveField(19)
  List<String> tags;

  @HiveField(20)
  bool isFavorite;

  @HiveField(21)
  String? notes;

  Clothing({
    required this.id,
    required this.imageUrl,
    required this.category,
    required this.subCategory,
    required this.color,
    this.pattern,
    this.styles = const [],
    this.seasons = const [],
    this.brand,
    this.size,
    this.price,
    this.purchaseDate,
    this.locationStatus = 'in_wardrobe',
    this.locationRoom,
    this.locationFurniture,
    this.wearCount = 0,
    this.lastWearDate,
    required this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.isFavorite = false,
    this.notes,
  });

  String get displayName {
    final parts = [color, subCategory];
    if (brand != null) parts.insert(0, brand!);
    return parts.join(' ');
  }

  void incrementWearCount() {
    wearCount++;
    lastWearDate = DateTime.now();
    updatedAt = DateTime.now();
    save();
  }
}
