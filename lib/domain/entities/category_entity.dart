import 'package:flutter/material.dart';

import '../../core/constants/category_icons.dart';
import 'transaction_type.dart';

class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.color,
    required this.type,
    required this.isCustom,
  });

  final String id;
  final String name;
  final String iconKey;
  final Color color;
  final TransactionType type;
  final bool isCustom;

  IconData get icon => CategoryIcons.resolve(iconKey);

  CategoryEntity copyWith({
    String? name,
    String? iconKey,
    Color? color,
  }) {
    return CategoryEntity(
      id: id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      color: color ?? this.color,
      type: type,
      isCustom: isCustom,
    );
  }
}
