import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/wardrobe_provider.dart';

/// 手动添加 / 编辑衣服的底部表单。
/// [initial] 为空时为「添加」模式，传入已有衣服则为「编辑」模式。
/// 不依赖任何 AI，全部字段由用户手动填写。
class AddClothingSheet extends StatefulWidget {
  final Clothing? initial;

  const AddClothingSheet({super.key, this.initial});

  @override
  State<AddClothingSheet> createState() => _AddClothingSheetState();
}

class _AddClothingSheetState extends State<AddClothingSheet> {
  final ImagePicker _picker = ImagePicker();
  final _colorController = TextEditingController();
  final _brandController = TextEditingController();
  final _sizeController = TextEditingController();
  final _notesController = TextEditingController();

  Uint8List? _imageBytes;
  String? _base64Image;
  bool _isSaving = false;

  late String _category;
  late String _subCategory;
  late String _locationStatus;
  late List<String> _seasons;
  late List<String> _styles;

  @override
  void initState() {
    super.initState();
    final c = widget.initial;
    _category = c?.category ?? ClothingCategory.tops;
    _subCategory = c?.subCategory ??
        (ClothingSubCategory.subCategories[_category]?.first ?? 't_shirt');
    _locationStatus = c?.locationStatus ?? LocationStatus.inWardrobe;
    _seasons = List<String>.from(c?.seasons ?? []);
    _styles = List<String>.from(c?.styles ?? []);

    _colorController.text = c?.color ?? '';
    _brandController.text = c?.brand ?? '';
    _sizeController.text = c?.size ?? '';
    _notesController.text = c?.notes ?? '';

    if (c?.imageUrl.startsWith('data:image') ?? false) {
      try {
        _base64Image = c!.imageUrl.split(',').last;
        _imageBytes = base64Decode(_base64Image!);
      } catch (_) {
        _imageBytes = null;
      }
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    _brandController.dispose();
    _sizeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource?>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择图片来源'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
            child: const Text('从相册选择'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
            child: const Text('拍照'),
          ),
          if (_imageBytes != null)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('移除图片'),
            ),
        ],
      ),
    );
    if (source == null) {
      setState(() {
        _imageBytes = null;
        _base64Image = null;
      });
      return;
    }
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _save() async {
    final color = _colorController.text.trim();
    if (color.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写颜色')),
      );
      return;
    }
    setState(() => _isSaving = true);

    final imageUrl = _imageBytes != null
        ? 'data:image/jpeg;base64,$_base64Image'
        : (widget.initial?.imageUrl ?? '');

    final clothing = Clothing(
      id: widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: imageUrl,
      category: _category,
      subCategory: _subCategory,
      color: color,
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      size: _sizeController.text.trim().isEmpty
          ? null
          : _sizeController.text.trim(),
      locationStatus: _locationStatus,
      seasons: _seasons,
      styles: _styles,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      wearCount: widget.initial?.wearCount ?? 0,
      lastWearDate: widget.initial?.lastWearDate,
      createdAt: widget.initial?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      locationRoom: widget.initial?.locationRoom,
      locationFurniture: widget.initial?.locationFurniture,
      isFavorite: widget.initial?.isFavorite ?? false,
      tags: widget.initial?.tags ?? const [],
    );

    final provider = context.read<WardrobeProvider>();
    if (widget.initial != null) {
      await provider.updateClothing(clothing);
    } else {
      await provider.addClothing(clothing);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.initial != null ? '已更新' : '衣服已添加 +10 积分'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
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
              Text(
                widget.initial != null ? '编辑衣服' : '添加衣服',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 图片（可选）
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _imageBytes == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('点击添加照片（可选）',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('分类 *', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ClothingCategory.names.entries.map((e) {
                  final sel = _category == e.key;
                  return FilterChip(
                    label:
                        Text('${ClothingCategory.icons[e.key]} ${e.value}'),
                    selected: sel,
                    onSelected: (_) {
                      setState(() {
                        _category = e.key;
                        _subCategory =
                            ClothingSubCategory.subCategories[_category]?.first ??
                                't_shirt';
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const Text('类型', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _subCategory,
                isExpanded: true,
                items: (ClothingSubCategory.subCategories[_category] ??
                        <String>[])
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(ClothingSubCategory.names[s] ?? s),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _subCategory = v);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: '颜色 *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: '品牌 / 名称（可选）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sizeController,
                decoration: const InputDecoration(
                  labelText: '尺码（可选）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              const Text('位置', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: LocationStatus.names.entries.map((e) {
                  final sel = _locationStatus == e.key;
                  return FilterChip(
                    label:
                        Text('${LocationStatus.icons[e.key]} ${e.value}'),
                    selected: sel,
                    onSelected: (_) {
                      setState(() => _locationStatus = e.key);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const Text('季节（可多选）',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: Season.names.entries.map((e) {
                  final sel = _seasons.contains(e.key);
                  return FilterChip(
                    label: Text(e.value),
                    selected: sel,
                    onSelected: (_) {
                      setState(() {
                        if (sel) {
                          _seasons.remove(e.key);
                        } else {
                          _seasons.add(e.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const Text('风格（可多选）',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: StyleTag.names.entries.map((e) {
                  final sel = _styles.contains(e.key);
                  return FilterChip(
                    label: Text(e.value),
                    selected: sel,
                    onSelected: (_) {
                      setState(() {
                        if (sel) {
                          _styles.remove(e.key);
                        } else {
                          _styles.add(e.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: '备注（可选）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.initial != null ? '保存修改' : '保存'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class QuickAddButton extends StatelessWidget {
  const QuickAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => const AddClothingSheet(),
        );
      },
      icon: const Icon(Icons.add_a_photo),
      label: const Text('添加衣服'),
    );
  }
}
