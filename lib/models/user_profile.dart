import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  String? nickname;

  @HiveField(1)
  String? avatarUrl;

  @HiveField(2)
  String? gender; // male, female, other

  @HiveField(3)
  int? height;

  @HiveField(4)
  int? weight;

  @HiveField(5)
  List<String> stylePreferences;

  @HiveField(6)
  int totalClothes;

  @HiveField(7)
  int totalOutfits;

  @HiveField(8)
  int totalWearDays;

  @HiveField(9)
  int streakDays;

  @HiveField(10)
  DateTime? lastActiveDate;

  @HiveField(11)
  int points;

  @HiveField(12)
  List<String> achievements;

  @HiveField(13)
  DateTime createdAt;

  UserProfile({
    this.nickname,
    this.avatarUrl,
    this.gender,
    this.height,
    this.weight,
    this.stylePreferences = const [],
    this.totalClothes = 0,
    this.totalOutfits = 0,
    this.totalWearDays = 0,
    this.streakDays = 0,
    this.lastActiveDate,
    this.points = 0,
    this.achievements = const [],
    required this.createdAt,
  });

  void addPoints(int amount) {
    points += amount;
    save();
  }

  void addAchievement(String achievement) {
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
      save();
    }
  }
}
