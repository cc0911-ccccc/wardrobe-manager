# 衣橱管家 (Wardrobe Manager)

智能衣物管理与穿搭助手

## 🎯 核心功能

### 📸 零负担录入
- **拍照识别**：拍照即录入，AI 自动识别类型、颜色、风格（10秒/件）
- **衣柜扫描**：拍摄整个衣柜，AI 自动分析所有衣服
- **批量导入**：从相册批量选择，快速录入

### 🤖 AI 穿搭助手
- **语音输入**：说出需求，AI 生成搭配方案
- **场景推荐**：约会、面试、日常、运动等场景
- **智能搭配**：从你的衣橱中匹配最佳组合

### 📍 位置管理
- **快速定位**：标记衣服位置，不再翻箱倒柜
- **状态跟踪**：在衣柜/在洗/正在穿/收纳中

### 📊 数据统计
- 穿搭次数统计
- 衣服利用率分析
- 积分成就系统

## 🚀 快速开始

### 安装 Flutter

```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### 运行项目

```bash
cd wardrobe-manager
flutter pub get
flutter run
```

### 构建

```bash
flutter build apk --release    # Android
flutter build ios --release    # iOS (需要 Mac)
flutter build web --release    # Web
```

## 📱 技术栈

- **Flutter** 3.16+
- **Provider** 状态管理
- **Hive** 本地数据库
- **Image Picker** 图像处理
- **Speech to Text** 语音识别

## 📂 项目结构

```
lib/
├── main.dart              # 应用入口
├── models/                # 数据模型
│   ├── clothing.dart      # 衣服模型
│   ├── outfit.dart        # 搭配模型
│   └── ...
├── providers/             # 状态管理
│   └── wardrobe_provider.dart
├── screens/               # 页面
│   ├── home_screen.dart
│   ├── wardrobe_screen.dart
│   ├── outfit_screen.dart
│   └── ...
├── widgets/               # 组件
│   ├── clothing_card.dart
│   └── add_clothing_sheet.dart
└── services/              # 服务
    ├── storage_service.dart
    └── ai_service.dart
```

## 🎨 设计亮点

- **10 秒录入**：拍照 → AI 识别 → 一键确认
- **衣柜扫描**：拍衣柜，AI 自动分析
- **语音搭配**：动动嘴就能生成穿搭
- **游戏化**：积分、成就、打卡激励

## 📄 License

MIT
