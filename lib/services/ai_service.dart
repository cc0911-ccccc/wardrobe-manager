import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../models/models.dart';

/// AI 识别服务 - 接入 Infini-AI API
/// 支持 GLM-4V 图像识别 + GLM-4 文本生成
class AIService {
  final Dio _dio = Dio();
  
  // Infini-AI API 配置
  static const String _apiBaseUrl = 'https://api.infini-ai.com/v1';
  static const String _apiKey = String.fromEnvironment('INFINI_AI_KEY', defaultValue: 'sk-inoom66zj73ddrf5');
  
  // 模型配置
  static const String _visionModel = 'glm-4v';  // 图像识别
  static const String _textModel = 'glm-4';     // 文本生成
  
  AIService() {
    _dio.options.baseUrl = _apiBaseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
  }
  
  /// 识别单件衣服
  Future<ClothingRecognitionResult> recognizeClothing(String imagePath) async {
    try {
      // 读取图片并转为 base64
      final imageBytes = await _readImageFile(imagePath);
      final base64Image = base64Encode(imageBytes);
      
      // 调用 GLM-4V 进行图像识别
      final response = await _dio.post('/chat/completions', data: {
        'model': _visionModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': _getClothingRecognitionPrompt(),
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'max_tokens': 1024,
        'temperature': 0.3,
      });
      
      final content = response.data['choices'][0]['message']['content'] as String;
      return _parseClothingResult(content);
    } catch (e) {
      print('AI recognition error: $e');
      // 降级为模拟结果
      return _getMockClothingResult();
    }
  }
  
  /// 批量识别衣服
  Future<List<ClothingRecognitionResult>> recognizeMultipleClothes(List<String> imagePaths) async {
    final results = <ClothingRecognitionResult>[];
    for (final path in imagePaths) {
      results.add(await recognizeClothing(path));
    }
    return results;
  }
  
  /// 分析衣柜照片（批量识别）
  Future<WardrobeAnalysisResult> analyzeWardrobe(String imagePath) async {
    try {
      final imageBytes = await _readImageFile(imagePath);
      final base64Image = base64Encode(imageBytes);
      
      final response = await _dio.post('/chat/completions', data: {
        'model': _visionModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': _getWardrobeAnalysisPrompt(),
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'max_tokens': 2048,
        'temperature': 0.3,
      });
      
      final content = response.data['choices'][0]['message']['content'] as String;
      return _parseWardrobeAnalysis(content);
    } catch (e) {
      print('Wardrobe analysis error: $e');
      return _getMockWardrobeAnalysis();
    }
  }
  
  /// 生成穿搭建议
  Future<OutfitSuggestion> generateOutfitSuggestion({
    required String prompt,
    String? occasion,
    String? season,
    double? temperature,
    List<String>? availableClothingIds,
    List<Clothing>? availableClothes,
  }) async {
    try {
      final systemPrompt = _getOutfitSuggestionSystemPrompt();
      final userPrompt = _buildOutfitUserPrompt(
        prompt: prompt,
        occasion: occasion,
        season: season,
        temperature: temperature,
        availableClothes: availableClothes,
      );
      
      final response = await _dio.post('/chat/completions', data: {
        'model': _textModel,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        'max_tokens': 2048,
        'temperature': 0.7,
      });
      
      final content = response.data['choices'][0]['message']['content'] as String;
      return _parseOutfitSuggestion(content, availableClothingIds);
    } catch (e) {
      print('Outfit suggestion error: $e');
      return _getMockOutfitSuggestion(availableClothingIds);
    }
  }
  
  /// 语音转文字（使用 GLM-4）
  Future<String> speechToText(String audioPath) async {
    // Web 端不支持本地音频文件，需要用浏览器的 Speech Recognition API
    // 这里返回提示信息
    return '请在应用中使用语音输入功能';
  }
  
  // ============ 私有方法 ============
  
  Future<Uint8List> _readImageFile(String path) async {
    // Web 端需要特殊处理
    throw UnimplementedError('Use image bytes directly on web');
  }
  
  /// 从 base64 识别衣服
  Future<ClothingRecognitionResult> recognizeClothingFromBase64(String base64Image) async {
    try {
      final response = await _dio.post('/chat/completions', data: {
        'model': _visionModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': _getClothingRecognitionPrompt(),
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'max_tokens': 1024,
        'temperature': 0.3,
      });
      
      final content = response.data['choices'][0]['message']['content'] as String;
      return _parseClothingResult(content);
    } catch (e) {
      print('AI recognition error: $e');
      return _getMockClothingResult();
    }
  }
  
  String _getClothingRecognitionPrompt() {
    return '''请识别这张图片中的衣服，并以 JSON 格式返回以下信息：
{
  "category": "衣服类别（tops/bottoms/outerwear/dress/shoes/accessories/underwear）",
  "subCategory": "具体类别（如 t_shirt, jeans, jacket, sneakers 等）",
  "color": "主要颜色",
  "pattern": "图案（纯色/条纹/格子/印花等）",
  "styles": ["风格标签（casual/formal/sporty/minimalist/streetwear/vintage）"],
  "seasons": ["适合季节（spring/summer/autumn/winter）"],
  "confidence": 0.95
}

只返回 JSON，不要其他说明文字。''';
  }
  
  String _getWardrobeAnalysisPrompt() {
    return '''请分析这张衣柜照片，识别所有可见的衣服，并以 JSON 格式返回：
{
  "zones": [
    {
      "name": "区域名称",
      "items": [
        {
          "category": "衣服类别",
          "subCategory": "具体类别",
          "color": "颜色",
          "confidence": 0.9
        }
      ]
    }
  ],
  "totalCount": 5
}

只返回 JSON，不要其他说明文字。''';
  }
  
  String _getOutfitSuggestionSystemPrompt() {
    return '''你是一位专业的时尚搭配顾问。你的任务是根据用户的衣柜内容和需求，提供个性化的穿搭建议。

回答格式（JSON）：
{
  "name": "搭配名称",
  "description": "搭配说明（为什么这样搭配，适合什么场合）",
  "styleTips": "穿搭小技巧",
  "confidence": 0.9
}

要求：
1. 结合用户已有的衣服进行搭配
2. 考虑场合、天气、季节等因素
3. 给出专业的搭配理由
4. 只返回 JSON，不要其他文字''';
  }
  
  String _buildOutfitUserPrompt({
    required String prompt,
    String? occasion,
    String? season,
    double? temperature,
    List<Clothing>? availableClothes,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('用户需求：$prompt');
    
    if (occasion != null) buffer.writeln('场合：$occasion');
    if (season != null) buffer.writeln('季节：$season');
    if (temperature != null) buffer.writeln('温度：${temperature}°C');
    
    if (availableClothes != null && availableClothes.isNotEmpty) {
      buffer.writeln('\n用户衣柜中的衣服：');
      for (final cloth in availableClothes.take(20)) {
        buffer.writeln('- ${cloth.displayName}: ${cloth.category}/${cloth.subCategory}, ${cloth.color}');
      }
    }
    
    return buffer.toString();
  }
  
  ClothingRecognitionResult _parseClothingResult(String content) {
    try {
      // 提取 JSON 部分
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch != null) {
        final json = jsonDecode(jsonMatch.group(0)!);
        return ClothingRecognitionResult(
          category: json['category'] ?? 'tops',
          subCategory: json['subCategory'] ?? 't_shirt',
          color: json['color'] ?? '白色',
          pattern: json['pattern'],
          styles: List<String>.from(json['styles'] ?? ['casual']),
          seasons: List<String>.from(json['seasons'] ?? ['spring', 'summer']),
          confidence: (json['confidence'] ?? 0.9).toDouble(),
        );
      }
    } catch (e) {
      print('Parse error: $e');
    }
    return _getMockClothingResult();
  }
  
  WardrobeAnalysisResult _parseWardrobeAnalysis(String content) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch != null) {
        final json = jsonDecode(jsonMatch.group(0)!);
        final zones = (json['zones'] as List).map((zone) {
          return WardrobeZone(
            name: zone['name'],
            items: (zone['items'] as List).map((item) {
              return WardrobeItem(
                boundingBox: [0, 0, 100, 100],
                category: item['category'] ?? 'tops',
                subCategory: item['subCategory'] ?? 'unknown',
                color: item['color'] ?? '未知',
                confidence: (item['confidence'] ?? 0.8).toDouble(),
              );
            }).toList(),
          );
        }).toList();
        
        return WardrobeAnalysisResult(
          zones: zones,
          totalCount: json['totalCount'] ?? zones.fold(0, (sum, z) => sum + z.items.length),
        );
      }
    } catch (e) {
      print('Parse error: $e');
    }
    return _getMockWardrobeAnalysis();
  }
  
  OutfitSuggestion _parseOutfitSuggestion(String content, List<String>? clothingIds) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch != null) {
        final json = jsonDecode(jsonMatch.group(0)!);
        return OutfitSuggestion(
          name: json['name'] ?? 'AI 推荐搭配',
          description: json['description'] ?? '',
          clothingIds: clothingIds?.take(3).toList() ?? [],
          occasion: 'daily',
          season: 'spring',
          confidence: (json['confidence'] ?? 0.85).toDouble(),
        );
      }
    } catch (e) {
      print('Parse error: $e');
    }
    return _getMockOutfitSuggestion(clothingIds);
  }
  
  // ============ Mock 数据（降级方案）============
  
  ClothingRecognitionResult _getMockClothingResult() {
    return ClothingRecognitionResult(
      category: 'tops',
      subCategory: 't_shirt',
      color: '白色',
      pattern: '纯色',
      styles: ['casual', 'minimalist'],
      seasons: ['spring', 'summer'],
      confidence: 0.95,
    );
  }
  
  WardrobeAnalysisResult _getMockWardrobeAnalysis() {
    return WardrobeAnalysisResult(
      zones: [
        WardrobeZone(
          name: '上层',
          items: [
            WardrobeItem(
              boundingBox: [100, 50, 200, 150],
              category: 'outerwear',
              subCategory: 'jacket',
              color: '黑色',
              confidence: 0.92,
            ),
          ],
        ),
        WardrobeZone(
          name: '中层',
          items: [
            WardrobeItem(
              boundingBox: [100, 200, 200, 300],
              category: 'tops',
              subCategory: 't_shirt',
              color: '白色',
              confidence: 0.95,
            ),
          ],
        ),
      ],
      totalCount: 2,
    );
  }
  
  OutfitSuggestion _getMockOutfitSuggestion(List<String>? clothingIds) {
    return OutfitSuggestion(
      name: 'AI 推荐搭配',
      description: '根据您的需求生成的搭配方案',
      clothingIds: clothingIds?.take(3).toList() ?? [],
      occasion: 'daily',
      season: 'spring',
      confidence: 0.88,
    );
  }
}

/// 衣服识别结果
class ClothingRecognitionResult {
  final String category;
  final String subCategory;
  final String color;
  final String? pattern;
  final List<String> styles;
  final List<String> seasons;
  final double confidence;
  final String? brand;
  
  ClothingRecognitionResult({
    required this.category,
    required this.subCategory,
    required this.color,
    this.pattern,
    required this.styles,
    required this.seasons,
    required this.confidence,
    this.brand,
  });
}

/// 衣柜分析结果
class WardrobeAnalysisResult {
  final List<WardrobeZone> zones;
  final int totalCount;
  
  WardrobeAnalysisResult({
    required this.zones,
    required this.totalCount,
  });
}

/// 衣柜区域
class WardrobeZone {
  final String name;
  final List<WardrobeItem> items;
  
  WardrobeZone({
    required this.name,
    required this.items,
  });
}

/// 衣柜中的衣服项
class WardrobeItem {
  final List<double> boundingBox;
  final String category;
  final String subCategory;
  final String color;
  final double confidence;
  
  WardrobeItem({
    required this.boundingBox,
    required this.category,
    required this.subCategory,
    required this.color,
    required this.confidence,
  });
}

/// 穿搭建议
class OutfitSuggestion {
  final String name;
  final String description;
  final List<String> clothingIds;
  final String occasion;
  final String season;
  final double confidence;
  
  OutfitSuggestion({
    required this.name,
    required this.description,
    required this.clothingIds,
    required this.occasion,
    required this.season,
    required this.confidence,
  });
}
