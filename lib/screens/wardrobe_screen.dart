import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/wardrobe_provider.dart';
import '../widgets/clothing_card.dart';
import '../widgets/add_clothing_sheet.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的衣橱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 分类标签
          _buildCategoryTabs(),
          
          // 位置筛选
          _buildLocationFilter(),
          
          // 衣服列表
          Expanded(
            child: Consumer<WardrobeProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.clothes.isEmpty) {
                  return _buildEmptyState(context);
                }
                
                return _buildClothesGrid(context, provider);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddClothing(context),
        icon: const Icon(Icons.add),
        label: const Text('添加衣服'),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _buildCategoryChip('全部', null),
          ...ClothingCategory.names.entries.map((e) => 
            _buildCategoryChip('${ClothingCategory.icons[e.key]} ${e.value}', e.key),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedCategory = category;
          });
          context.read<WardrobeProvider>().setCategoryFilter(category);
        },
      ),
    );
  }

  Widget _buildLocationFilter() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Consumer<WardrobeProvider>(
              builder: (context, provider, _) {
                return DropdownButton<String?>(
                  value: null,
                  hint: const Text('位置筛选'),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('全部位置')),
                    ...LocationStatus.names.entries.map((e) => 
                      DropdownMenuItem(
                        value: e.key,
                        child: Text('${LocationStatus.icons[e.key]} ${e.value}'),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    provider.setLocationFilter(value);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.checkroom, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '衣橱是空的',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方按钮添加第一件衣服',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddClothing(context),
            icon: const Icon(Icons.camera_alt),
            label: const Text('拍照添加'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('衣柜扫描为 AI 功能，需配置密钥后使用')),
              );
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('衣柜扫描'),
          ),
        ],
      ),
    );
  }

  Widget _buildClothesGrid(BuildContext context, WardrobeProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: provider.clothes.length,
      itemBuilder: (context, index) {
        return ClothingCard(
          clothing: provider.clothes[index],
          onEdit: () => _showEditClothing(context, provider.clothes[index]),
        );
      },
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: _ClothingSearchDelegate(),
    );
  }

  void _showAddClothing(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddClothingSheet(),
    );
  }

  void _showEditClothing(BuildContext context, Clothing clothing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddClothingSheet(initial: clothing),
    );
  }
}

class _ClothingSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    context.read<WardrobeProvider>().setSearchQuery(query);
    return Consumer<WardrobeProvider>(
      builder: (context, provider, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: provider.clothes.length,
          itemBuilder: (context, index) {
            return ClothingCard(clothing: provider.clothes[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('搜索衣服名称、颜色、品牌...'),
    );
  }
}
