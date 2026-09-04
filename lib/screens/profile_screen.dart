import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';
import '../models/models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: Consumer<WardrobeProvider>(
        builder: (context, provider, child) {
          final profile = provider.profile;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 用户信息卡片
                _buildUserCard(context, profile),
                const SizedBox(height: 16),
                
                // 统计数据
                _buildStatsGrid(context, provider),
                const SizedBox(height: 16),
                
                // 成就
                _buildAchievements(profile),
                const SizedBox(height: 16),
                
                // 设置选项
                _buildSettingsList(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserProfile? profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.nickname ?? '衣橱达人',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${profile?.points ?? 0} 积分',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 编辑资料
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, WardrobeProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '我的数据',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem(
                  context,
                  icon: '👕',
                  value: provider.totalClothes.toString(),
                  label: '件衣服',
                ),
                _buildStatItem(
                  context,
                  icon: '🎨',
                  value: provider.totalOutfits.toString(),
                  label: '套搭配',
                ),
                _buildStatItem(
                  context,
                  icon: '📅',
                  value: provider.records.length.toString(),
                  label: '天记录',
                ),
                _buildStatItem(
                  context,
                  icon: '🔥',
                  value: provider.profile?.streakDays.toString() ?? '0',
                  label: '连续打卡',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(UserProfile? profile) {
    final achievements = profile?.achievements ?? [];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '我的成就',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${achievements.length}/10',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAchievementBadge(
                  '🎉',
                  '首次添加',
                  achievements.contains('first_add'),
                ),
                _buildAchievementBadge(
                  '👗',
                  '衣橱达人',
                  achievements.contains('wardrobe_master'),
                ),
                _buildAchievementBadge(
                  '🎨',
                  '搭配大师',
                  achievements.contains('outfit_master'),
                ),
                _buildAchievementBadge(
                  '📅',
                  '坚持记录',
                  achievements.contains('record_streak'),
                ),
                _buildAchievementBadge(
                  '⭐',
                  '积分达人',
                  achievements.contains('points_master'),
                ),
                _buildAchievementBadge(
                  '🌱',
                  '环保先锋',
                  achievements.contains('eco_warrior'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(String icon, String label, bool unlocked) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.3,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: unlocked
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.style,
            title: '风格偏好',
            subtitle: '设置你喜欢的穿搭风格',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.straighten,
            title: '身材数据',
            subtitle: '身高体重等数据',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.backup,
            title: '数据备份',
            subtitle: '备份和恢复数据',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.info,
            title: '关于',
            subtitle: '版本 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
