import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/wardrobe_provider.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('穿搭记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // 日历视图
            },
          ),
        ],
      ),
      body: Consumer<WardrobeProvider>(
        builder: (context, provider, child) {
          if (provider.records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '还没有穿搭记录',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '记录每天的穿搭，追踪穿衣习惯',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.records.length,
            itemBuilder: (context, index) {
              final record = provider.records[index];
              return _buildRecordCard(context, record);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRecordSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('记录今天'),
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, dynamic record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    '${record.date.day}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(record.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (record.occasion != null)
                        Text(
                          record.occasion,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                if (record.weather != null)
                  Chip(
                    label: Text(record.weather),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: record.clothingIds.map<Widget>((id) {
                return Chip(
                  label: Text('单品'),
                  avatar: const Icon(Icons.checkroom, size: 16),
                );
              }).toList(),
            ),
            if (record.notes != null) ...[
              const SizedBox(height: 8),
              Text(
                record.notes,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return '${date.year}年${date.month}月${date.day}日 周${weekdays[date.weekday - 1]}';
  }

  void _showAddRecordSheet(BuildContext context) {
    final provider = Provider.of<WardrobeProvider>(context, listen: false);
    if (provider.clothes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先在衣橱中添加衣服')),
      );
      return;
    }

    final selected = <String>{};
    final messenger = ScaffoldMessenger.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, __) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '记录今天穿了什么',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: provider.clothes.map((c) {
                      return CheckboxListTile(
                        value: selected.contains(c.id),
                        onChanged: (v) {
                          if (v == true) {
                            selected.add(c.id);
                          } else {
                            selected.remove(c.id);
                          }
                          setState(() {});
                        },
                        title: Text(c.displayName),
                        secondary: Text(
                          ClothingCategory.icons[c.category] ?? '👕',
                          style: const TextStyle(fontSize: 24),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selected.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请至少选择一件衣服')),
                        );
                        return;
                      }
                      await provider.addOutfitRecord(OutfitRecord(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        clothingIds: selected.toList(),
                        date: DateTime.now(),
                        createdAt: DateTime.now(),
                      ));
                      if (context.mounted) {
                        Navigator.pop(ctx);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('已记录今天穿搭')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('保存记录'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
