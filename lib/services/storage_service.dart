import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

class StorageService {
  static const String clothingBoxName = 'clothes';
  static const String outfitBoxName = 'outfits';
  static const String recordBoxName = 'outfit_records';
  static const String profileBoxName = 'user_profile';
  static const String settingsBoxName = 'settings';

  late Box<Clothing> _clothingBox;
  late Box<Outfit> _outfitBox;
  late Box<OutfitRecord> _recordBox;
  late Box<UserProfile> _profileBox;
  late Box<dynamic> _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // 注册适配器
    Hive.registerAdapter(ClothingAdapter());
    Hive.registerAdapter(OutfitAdapter());
    Hive.registerAdapter(OutfitRecordAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    // 打开盒子
    _clothingBox = await Hive.openBox<Clothing>(clothingBoxName);
    _outfitBox = await Hive.openBox<Outfit>(outfitBoxName);
    _recordBox = await Hive.openBox<OutfitRecord>(recordBoxName);
    _profileBox = await Hive.openBox<UserProfile>(profileBoxName);
    _settingsBox = await Hive.openBox<dynamic>(settingsBoxName);
  }

  // ========== Clothes ==========
  
  List<Clothing> getAllClothes() {
    return _clothingBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Clothing> getClothesByCategory(String category) {
    return _clothingBox.values
        .where((c) => c.category == category)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Clothing> getClothesByLocation(String status) {
    return _clothingBox.values
        .where((c) => c.locationStatus == status)
        .toList();
  }

  List<Clothing> searchClothes(String query) {
    final lowerQuery = query.toLowerCase();
    return _clothingBox.values.where((c) {
      return c.color.toLowerCase().contains(lowerQuery) ||
          c.subCategory.toLowerCase().contains(lowerQuery) ||
          (c.brand?.toLowerCase().contains(lowerQuery) ?? false) ||
          c.tags.any((t) => t.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  Future<void> addClothing(Clothing clothing) async {
    await _clothingBox.put(clothing.id, clothing);
  }

  Future<void> updateClothing(Clothing clothing) async {
    clothing.updatedAt = DateTime.now();
    await clothing.save();
  }

  Future<void> deleteClothing(String id) async {
    await _clothingBox.delete(id);
  }

  Clothing? getClothing(String id) {
    return _clothingBox.get(id);
  }

  // ========== Outfits ==========

  List<Outfit> getAllOutfits() {
    return _outfitBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Outfit> getFavoriteOutfits() {
    return _outfitBox.values.where((o) => o.isFavorite).toList();
  }

  Future<void> addOutfit(Outfit outfit) async {
    await _outfitBox.put(outfit.id, outfit);
  }

  Future<void> deleteOutfit(String id) async {
    await _outfitBox.delete(id);
  }

  // ========== Outfit Records ==========

  List<OutfitRecord> getAllRecords() {
    return _recordBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<OutfitRecord> getRecordsByDateRange(DateTime start, DateTime end) {
    return _recordBox.values
        .where((r) => r.date.isAfter(start) && r.date.isBefore(end))
        .toList();
  }

  Future<void> addRecord(OutfitRecord record) async {
    await _recordBox.put(record.id, record);
  }

  // ========== User Profile ==========

  UserProfile? getProfile() {
    return _profileBox.get('profile');
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _profileBox.put('profile', profile);
  }

  // ========== Settings ==========

  T? getSetting<T>(String key) {
    return _settingsBox.get(key) as T?;
  }

  Future<void> setSetting<T>(String key, T value) async {
    await _settingsBox.put(key, value);
  }

  // ========== Statistics ==========

  Map<String, int> getCategoryStats() {
    final stats = <String, int>{};
    for (final clothing in _clothingBox.values) {
      stats[clothing.category] = (stats[clothing.category] ?? 0) + 1;
    }
    return stats;
  }

  int get totalClothes => _clothingBox.length;
  int get totalOutfits => _outfitBox.length;
  int get totalRecords => _recordBox.length;

  List<Clothing> getLeastWornClothes({int limit = 10}) {
    return _clothingBox.values.toList()
      ..sort((a, b) => a.wearCount.compareTo(b.wearCount));
  }

  List<Clothing> getMostWornClothes({int limit = 10}) {
    return _clothingBox.values.toList()
      ..sort((a, b) => b.wearCount.compareTo(a.wearCount));
  }
}
