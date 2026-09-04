import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../services/ai_service.dart';

class WardrobeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final AIService _aiService = AIService();
  
  // 状态
  List<Clothing> _clothes = [];
  List<Outfit> _outfits = [];
  List<OutfitRecord> _records = [];
  UserProfile? _profile;
  
  bool _isLoading = false;
  String? _error;
  
  // 筛选状态
  String? _selectedCategory;
  String? _selectedLocation;
  String _searchQuery = '';
  
  // Getters
  List<Clothing> get clothes => _filterClothes();
  List<Outfit> get outfits => _outfits;
  List<OutfitRecord> get records => _records;
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalClothes => _clothes.length;
  int get totalOutfits => _outfits.length;
  
  // 初始化
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _storage.init();
      _loadData();
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  void _loadData() {
    _clothes = _storage.getAllClothes();
    _outfits = _storage.getAllOutfits();
    _records = _storage.getAllRecords();
    _profile = _storage.getProfile();
    
    // 如果没有用户配置，创建默认的
    if (_profile == null) {
      _profile = UserProfile(createdAt: DateTime.now());
      _storage.saveProfile(_profile!);
    }
  }
  
  // ========== 筛选 ==========
  
  List<Clothing> _filterClothes() {
    var filtered = _clothes;
    
    if (_selectedCategory != null) {
      filtered = filtered.where((c) => c.category == _selectedCategory).toList();
    }
    
    if (_selectedLocation != null) {
      filtered = filtered.where((c) => c.locationStatus == _selectedLocation).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.color.toLowerCase().contains(query) ||
            c.subCategory.toLowerCase().contains(query) ||
            (c.brand?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
    
    return filtered;
  }
  
  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  void setLocationFilter(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  // ========== 衣服管理 ==========
  
  Future<void> addClothing(Clothing clothing) async {
    await _storage.addClothing(clothing);
    _clothes.insert(0, clothing);
    
    // 更新统计
    _profile?.totalClothes = _clothes.length;
    _profile?.addPoints(10); // 添加衣服奖励积分
    await _storage.saveProfile(_profile!);
    
    notifyListeners();
  }
  
  Future<void> updateClothing(Clothing clothing) async {
    await _storage.updateClothing(clothing);
    final index = _clothes.indexWhere((c) => c.id == clothing.id);
    if (index != -1) {
      _clothes[index] = clothing;
    }
    notifyListeners();
  }
  
  Future<void> deleteClothing(String id) async {
    await _storage.deleteClothing(id);
    _clothes.removeWhere((c) => c.id == id);
    
    _profile?.totalClothes = _clothes.length;
    await _storage.saveProfile(_profile!);
    
    notifyListeners();
  }
  
  Future<Clothing?> recognizeAndAddClothing(String imagePath) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _aiService.recognizeClothing(imagePath);
      
      final clothing = Clothing(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: imagePath,
        category: result.category,
        subCategory: result.subCategory,
        color: result.color,
        pattern: result.pattern,
        styles: result.styles,
        seasons: result.seasons,
        brand: result.brand,
        createdAt: DateTime.now(),
      );
      
      await addClothing(clothing);
      return clothing;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// 从 base64 图像识别并添加衣服（Web 端使用）
  Future<Clothing?> recognizeAndAddClothingFromBase64(String base64Image) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _aiService.recognizeClothingFromBase64(base64Image);
      
      final clothing = Clothing(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: 'data:image/jpeg;base64,$base64Image',
        category: result.category,
        subCategory: result.subCategory,
        color: result.color,
        pattern: result.pattern,
        styles: result.styles,
        seasons: result.seasons,
        brand: result.brand,
        createdAt: DateTime.now(),
      );
      
      await addClothing(clothing);
      return clothing;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // ========== 穿搭管理 ==========
  
  Future<void> addOutfit(Outfit outfit) async {
    await _storage.addOutfit(outfit);
    _outfits.insert(0, outfit);
    
    _profile?.totalOutfits = _outfits.length;
    _profile?.addPoints(15);
    await _storage.saveProfile(_profile!);
    
    notifyListeners();
  }
  
  Future<void> deleteOutfit(String id) async {
    await _storage.deleteOutfit(id);
    _outfits.removeWhere((o) => o.id == id);
    notifyListeners();
  }
  
  Future<OutfitSuggestion?> generateOutfitSuggestion({
    required String prompt,
    String? occasion,
    String? season,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final clothingIds = _clothes.map((c) => c.id).toList();
      final suggestion = await _aiService.generateOutfitSuggestion(
        prompt: prompt,
        occasion: occasion,
        season: season,
        availableClothingIds: clothingIds,
        availableClothes: _clothes,
      );
      return suggestion;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // ========== 穿搭记录 ==========
  
  Future<void> addOutfitRecord(OutfitRecord record) async {
    await _storage.addRecord(record);
    _records.insert(0, record);
    
    // 更新衣服穿着次数
    for (final id in record.clothingIds) {
      final clothing = _clothes.firstWhere((c) => c.id == id, orElse: () => throw Exception('Clothing not found'));
      clothing.incrementWearCount();
    }
    
    _profile?.totalWearDays++;
    _profile?.addPoints(5);
    await _storage.saveProfile(_profile!);
    
    notifyListeners();
  }
  
  // ========== 统计 ==========
  
  Map<String, int> getCategoryStats() {
    return _storage.getCategoryStats();
  }
  
  List<Clothing> getLeastWornClothes({int limit = 10}) {
    return _storage.getLeastWornClothes(limit: limit);
  }
  
  List<Clothing> getMostWornClothes({int limit = 10}) {
    return _storage.getMostWornClothes(limit: limit);
  }
  
  // ========== 用户配置 ==========
  
  Future<void> updateProfile({
    String? nickname,
    String? avatarUrl,
    String? gender,
    int? height,
    int? weight,
    List<String>? stylePreferences,
  }) async {
    if (_profile == null) return;
    
    if (nickname != null) _profile!.nickname = nickname;
    if (avatarUrl != null) _profile!.avatarUrl = avatarUrl;
    if (gender != null) _profile!.gender = gender;
    if (height != null) _profile!.height = height;
    if (weight != null) _profile!.weight = weight;
    if (stylePreferences != null) _profile!.stylePreferences = stylePreferences;
    
    await _storage.saveProfile(_profile!);
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
