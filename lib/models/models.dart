export 'clothing.dart';
export 'outfit.dart';
export 'outfit_record.dart';
export 'user_profile.dart';

// 衣服分类常量
class ClothingCategory {
  static const String tops = 'tops';
  static const String bottoms = 'bottoms';
  static const String dress = 'dress';
  static const String outerwear = 'outerwear';
  static const String shoes = 'shoes';
  static const String accessories = 'accessories';

  static const Map<String, String> names = {
    tops: '上衣',
    bottoms: '下装',
    dress: '裙装',
    outerwear: '外套',
    shoes: '鞋子',
    accessories: '配饰',
  };

  static const Map<String, String> icons = {
    tops: '👕',
    bottoms: '👖',
    dress: '👗',
    outerwear: '🧥',
    shoes: '👟',
    accessories: '👜',
  };
}

// 衣服子分类
class ClothingSubCategory {
  static const Map<String, List<String>> subCategories = {
    'tops': ['t_shirt', 'shirt', 'sweater', 'hoodie', 'blouse', 'tank_top', 'polo'],
    'bottoms': ['jeans', 'trousers', 'shorts', 'skirt', 'leggings', 'joggers'],
    'dress': ['mini_dress', 'midi_dress', 'maxi_dress', 'casual_dress', 'formal_dress'],
    'outerwear': ['coat', 'jacket', 'blazer', 'vest', 'windbreaker', 'cardigan'],
    'shoes': ['sneakers', 'boots', 'heels', 'flats', 'sandals', 'loafers'],
    'accessories': ['bag', 'hat', 'scarf', 'belt', 'watch', 'jewelry', 'sunglasses'],
  };

  static const Map<String, String> names = {
    't_shirt': 'T恤',
    'shirt': '衬衫',
    'sweater': '毛衣',
    'hoodie': '卫衣',
    'blouse': '女衬衫',
    'tank_top': '背心',
    'polo': 'Polo衫',
    'jeans': '牛仔裤',
    'trousers': '西裤',
    'shorts': '短裤',
    'skirt': '裙子',
    'leggings': '紧身裤',
    'joggers': '运动裤',
    'mini_dress': '短裙',
    'midi_dress': '中长裙',
    'maxi_dress': '长裙',
    'casual_dress': '休闲裙',
    'formal_dress': '正装裙',
    'coat': '大衣',
    'jacket': '夹克',
    'blazer': '西装外套',
    'vest': '马甲',
    'windbreaker': '风衣',
    'cardigan': '针织开衫',
    'sneakers': '运动鞋',
    'boots': '靴子',
    'heels': '高跟鞋',
    'flats': '平底鞋',
    'sandals': '凉鞋',
    'loafers': '乐福鞋',
    'bag': '包',
    'hat': '帽子',
    'scarf': '围巾',
    'belt': '腰带',
    'watch': '手表',
    'jewelry': '首饰',
    'sunglasses': '太阳镜',
  };
}

// 风格标签
class StyleTag {
  static const String casual = 'casual';
  static const String formal = 'formal';
  static const String sporty = 'sporty';
  static const String dating = 'dating';
  static const String business = 'business';
  static const String party = 'party';
  static const String minimalist = 'minimalist';
  static const String vintage = 'vintage';
  static const String streetwear = 'streetwear';

  static const Map<String, String> names = {
    casual: '休闲',
    formal: '正式',
    sporty: '运动',
    dating: '约会',
    business: '商务',
    party: '派对',
    minimalist: '极简',
    vintage: '复古',
    streetwear: '街头',
  };
}

// 季节
class Season {
  static const String spring = 'spring';
  static const String summer = 'summer';
  static const String autumn = 'autumn';
  static const String winter = 'winter';

  static const Map<String, String> names = {
    spring: '春季',
    summer: '夏季',
    autumn: '秋季',
    winter: '冬季',
  };
}

// 位置状态
class LocationStatus {
  static const String inWardrobe = 'in_wardrobe';
  static const String washing = 'washing';
  static const String wearing = 'wearing';
  static const String storage = 'storage';
  static const String dryCleaning = 'dry_cleaning';

  static const Map<String, String> names = {
    inWardrobe: '在衣柜',
    washing: '在洗',
    wearing: '正在穿',
    storage: '收纳中',
    dryCleaning: '干洗中',
  };

  static const Map<String, String> icons = {
    inWardrobe: '🏠',
    washing: '🧺',
    wearing: '👔',
    storage: '📦',
    dryCleaning: '🏪',
  };
}

// 场合
class Occasion {
  static const String daily = 'daily';
  static const String work = 'work';
  static const String dating = 'dating';
  static const String party = 'party';
  static const String interview = 'interview';
  static const String travel = 'travel';
  static const String sport = 'sport';
  static const String home = 'home';

  static const Map<String, String> names = {
    daily: '日常',
    work: '工作',
    dating: '约会',
    party: '聚会',
    interview: '面试',
    travel: '旅行',
    sport: '运动',
    home: '居家',
  };

  static const Map<String, String> icons = {
    daily: '☀️',
    work: '💼',
    dating: '💑',
    party: '🎉',
    interview: '👔',
    travel: '✈️',
    sport: '🏃',
    home: '🏠',
  };
}
