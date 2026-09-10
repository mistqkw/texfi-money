import 'package:flutter/material.dart';

import '../entities/asset_entity.dart';
import '../entities/cash_flow_type.dart';

abstract class AssetRepository {
  Stream<List<AssetEntity>> watchAll();

  Stream<List<AssetCategoryEntity>> watchCategories();

  Stream<List<RiskLevelEntity>> watchRiskLevels();

  /// История оценок одного актива, по возрастанию даты.
  Stream<List<AssetValuePoint>> watchHistory(String assetId);

  /// Вся история всех активов разом.
  ///
  /// Нужна динамике капитала: считать её поточечно означало бы по запросу
  /// на актив на каждую точку графика. Активов у человека десятки, а не
  /// тысячи, и одна выборка дешевле.
  Future<Map<String, List<AssetValuePoint>>> historyByAsset();

  Future<String> create({
    required String name,
    required String categoryId,
    required String riskLevelId,
    required CashFlowType cashFlowType,
    required double value,
    required DateTime valuedAt,
    String? note,
  });

  Future<void> update({
    required String id,
    required String name,
    required String categoryId,
    required String riskLevelId,
    required CashFlowType cashFlowType,
    String? note,
  });

  /// Новая оценка стоимости. Добавляет точку в историю и двигает текущее
  /// значение, если оценка свежее уже известных.
  Future<void> revalue({
    required String assetId,
    required double value,
    required DateTime recordedAt,
  });

  Future<void> deleteValuePoint(String pointId);

  Future<void> delete(String id);

  Future<String> createCategory({
    required String name,
    required String iconKey,
    required Color color,
  });

  Future<void> updateCategory({
    required String id,
    required String name,
    required String iconKey,
    required Color color,
  });

  /// Удаляет категорию. Возвращает `false`, если на ней висят активы:
  /// молча оставить их без категории значило бы сломать распределение.
  Future<bool> deleteCategory(String id);

  Future<String> createRiskLevel({
    required String name,
    required int rank,
    required Color color,
    double? maxSharePercent,
  });

  Future<void> updateRiskLevel({
    required String id,
    required String name,
    required Color color,
    required double? maxSharePercent,
  });

  Future<bool> deleteRiskLevel(String id);
}
