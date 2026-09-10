import 'package:flutter/material.dart';

import 'cash_flow_type.dart';

/// Категория актива — в чём лежит капитал.
class AssetCategoryEntity {
  const AssetCategoryEntity({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.color,
    required this.isCustom,
  });

  final String id;
  final String name;
  final String iconKey;
  final Color color;
  final bool isCustom;
}

/// Уровень риска. Порядок задаёт [rank], а не имя: «высокий» — это самый
/// правый уровень шкалы, как бы он ни назывался у конкретного человека.
class RiskLevelEntity {
  const RiskLevelEntity({
    required this.id,
    required this.name,
    required this.rank,
    required this.color,
    required this.maxSharePercent,
    required this.isCustom,
  });

  final String id;
  final String name;
  final int rank;
  final Color color;

  /// Порог доли капитала, 0..100. `null` — порога нет.
  final double? maxSharePercent;

  final bool isCustom;
}

/// Одна оценка стоимости актива.
class AssetValuePoint {
  const AssetValuePoint({
    required this.id,
    required this.value,
    required this.recordedAt,
  });

  final String id;
  final double value;
  final DateTime recordedAt;
}

/// Актив со своей категорией и уровнем риска.
class AssetEntity {
  const AssetEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.riskLevel,
    required this.cashFlowType,
    required this.currentValue,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String name;
  final AssetCategoryEntity category;
  final RiskLevelEntity riskLevel;
  final CashFlowType cashFlowType;
  final double currentValue;
  final DateTime createdAt;
  final String? note;

  /// Вклад в капитал.
  ///
  /// Пассив вычитается, остальное складывается. Это то место, где
  /// «стоимость» и «вклад в капитал» расходятся: у ипотеки стоимость
  /// положительна — это размер долга, — а капитал она уменьшает. Хранить
  /// долги отрицательными числами было бы короче ровно до первого экрана,
  /// где надо показать «сколько я должен».
  double get netWorthContribution =>
      cashFlowType == CashFlowType.liability ? -currentValue : currentValue;
}
