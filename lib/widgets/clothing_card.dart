import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class ClothingCard extends StatelessWidget {
  final Clothing clothing;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const ClothingCard({
    super.key,
    required this.clothing,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => _showDetail(context, onEdit),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        ClothingCategory.icons[clothing.category] ?? '👕',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                    // 位置状态标签
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          LocationStatus.icons[clothing.locationStatus] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    // 穿着次数
                    if (clothing.wearCount > 0)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '已穿 ${clothing.wearCount} 次',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 信息区域
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clothing.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ClothingSubCategory.names[clothing.subCategory] ?? clothing.subCategory}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (clothing.locationRoom != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          clothing.locationRoom!,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, VoidCallback? onEdit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ClothingDetailSheet(clothing: clothing, onEdit: onEdit),
    );
  }
}

class _ClothingDetailSheet extends StatelessWidget {
  final Clothing clothing;
  final VoidCallback? onEdit;

  const _ClothingDetailSheet({required this.clothing, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    ClothingCategory.icons[clothing.category] ?? '👕',
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clothing.displayName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${ClothingSubCategory.names[clothing.subCategory] ?? clothing.subCategory}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              _buildInfoRow('颜色', clothing.color),
              if (clothing.pattern != null)
                _buildInfoRow('图案', clothing.pattern!),
              if (clothing.brand != null)
                _buildInfoRow('品牌', clothing.brand!),
              if (clothing.size != null)
                _buildInfoRow('尺码', clothing.size!),
              _buildInfoRow(
                '风格',
                clothing.styles.map((s) => StyleTag.names[s] ?? s).join(', '),
              ),
              _buildInfoRow(
                '季节',
                clothing.seasons.map((s) => Season.names[s] ?? s).join(', '),
              ),
              _buildInfoRow(
                '位置',
                '${LocationStatus.icons[clothing.locationStatus]} ${LocationStatus.names[clothing.locationStatus]}',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('穿着次数', '${clothing.wearCount}'),
                  _buildStatColumn(
                    '最近穿着',
                    clothing.lastWearDate != null
                        ? '${DateTime.now().difference(clothing.lastWearDate!).inDays} 天前'
                        : '未穿过',
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onEdit?.call();
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('编辑'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final provider = context.read<WardrobeProvider>();
                        final messenger = ScaffoldMessenger.of(context);
                        await provider.addOutfitRecord(OutfitRecord(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          clothingIds: [clothing.id],
                          date: DateTime.now(),
                          createdAt: DateTime.now(),
                        ));
                        if (context.mounted) {
                          Navigator.pop(context);
                          messenger.showSnackBar(
                            const SnackBar(content: Text('已记录今天穿了它')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('今天穿了'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
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
    );
  }
}
