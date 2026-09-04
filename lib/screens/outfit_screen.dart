import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';
import '../models/models.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 穿搭助手'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI 输入区域
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎤 描述你的穿搭需求',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: '例如：明天要去面试，想穿得正式一点',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // 语音输入
                            },
                            icon: const Icon(Icons.mic),
                            label: const Text('语音输入'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _generateOutfit,
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('生成搭配'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 快捷场景
            const Text(
              '快捷场景',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Occasion.names.entries.map((e) {
                return ActionChip(
                  avatar: Text(Occasion.icons[e.key] ?? ''),
                  label: Text(e.value),
                  onPressed: () {
                    _promptController.text = '我要${e.value}穿搭';
                    _generateOutfit();
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // 我的搭配
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '我的搭配',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 查看全部
                  },
                  child: const Text('查看全部'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Consumer<WardrobeProvider>(
              builder: (context, provider, child) {
                if (provider.outfits.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
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
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = provider.outfits[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.checkroom),
                        ),
                        title: Text(outfit.name),
                        subtitle: Text('${outfit.clothingIds.length} 件单品'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // 查看详情
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _generateOutfit() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请描述你的穿搭需求')),
      );
      return;
    }
    
    final provider = context.read<WardrobeProvider>();
    final suggestion = await provider.generateOutfitSuggestion(
      prompt: _promptController.text,
    );
    
    if (suggestion != null) {
      // 显示生成的搭配
      _showOutfitSuggestion(suggestion);
    }
  }

  void _showOutfitSuggestion(dynamic suggestion) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'AI 推荐搭配',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, size: 64),
              ),
            ),
            const SizedBox(height: 16),
            Text(suggestion.description ?? ''),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('重新生成'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('搭配已保存')),
                      );
                    },
                    child: const Text('保存搭配'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
