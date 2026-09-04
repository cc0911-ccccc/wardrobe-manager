import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';
import '../models/models.dart';
import '../widgets/add_clothing_sheet.dart';
import 'wardrobe_screen.dart';
import 'outfit_screen.dart';
import 'record_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _switchTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddClothingSheet(),
    );
  }

  void _showFeatureTip(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  late final List<Widget> _screens = [
    _DashboardTab(
      onNavigate: _switchTo,
      onAddClothing: _openAddSheet,
      onFeatureTip: _showFeatureTip,
    ),
    WardrobeScreen(),
    OutfitScreen(),
    RecordScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => _openAddSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('添加衣服'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.checkroom_outlined),
            selectedIcon: Icon(Icons.checkroom),
            label: '衣橱',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: '搭配',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: '记录',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final void Function(int) onNavigate;
  final void Function(BuildContext) onAddClothing;
  final void Function(BuildContext, String) onFeatureTip;

  const _DashboardTab({
    required this.onNavigate,
    required this.onAddClothing,
    required this.onFeatureTip,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WardrobeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('衣橱管家'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => onFeatureTip(context, '暂时没有新通知'),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await provider.init();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCard(context, provider),
                  const SizedBox(height: 16),

                  // 快捷入口
                  const Text(
                    '快捷入口',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),

                  // 今日推荐
                  const Text(
                    '今日推荐穿搭',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTodayOutfit(context, provider),
                  const SizedBox(height: 24),

                  // 最近添加
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '最近添加',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => onNavigate(1),
                        child: const Text('查看全部'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRecentClothes(context, provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(BuildContext context, WardrobeProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              icon: '⭐',
              value: provider.profile?.points.toString() ?? '0',
              label: '积分',
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
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
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
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionCard(
          context,
          icon: Icons.camera_alt,
          label: '拍照添加',
          color: Colors.red,
          onTap: () => onAddClothing(context),
        ),
        _buildActionCard(
          context,
          icon: Icons.auto_awesome,
          label: 'AI搭配',
          color: Colors.purple,
          onTap: () => onFeatureTip(
              context, 'AI 搭配需要配置密钥，将在后续版本开放'),
        ),
        _buildActionCard(
          context,
          icon: Icons.search,
          label: '找衣服',
          color: Colors.blue,
          onTap: () => onNavigate(1),
        ),
        _buildActionCard(
          context,
          icon: Icons.photo_library,
          label: '衣柜扫描',
          color: Colors.green,
          onTap: () => onFeatureTip(
              context, '衣柜扫描为 AI 功能，需配置密钥后使用'),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayOutfit(BuildContext context, WardrobeProvider provider) {
    if (provider.outfits.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                '还没有搭配方案',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => onNavigate(2),
                icon: const Icon(Icons.add),
                label: const Text('去创建搭配'),
              ),
            ],
          ),
        ),
      );
    }

    final outfit = provider.outfits.first;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onNavigate(2),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.checkroom, size: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      outfit.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${outfit.clothingIds.length} 件单品',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    if (outfit.occasion != null) ...[
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(
                          Occasion.names[outfit.occasion] ?? outfit.occasion!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentClothes(BuildContext context, WardrobeProvider provider) {
    if (provider.clothes.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.checkroom,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                '还没有衣服',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => onAddClothing(context),
                icon: const Icon(Icons.add),
                label: const Text('添加第一件衣服'),
              ),
            ],
          ),
        ),
      );
    }

    final recentClothes = provider.clothes.take(4).toList();
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentClothes.length,
        itemBuilder: (context, index) {
          final clothing = recentClothes[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        ClothingCategory.icons[clothing.category] ?? '👕',
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Text(
                        clothing.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
