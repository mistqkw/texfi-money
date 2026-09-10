import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/asset_entity.dart';
import '../../domain/entities/cash_flow_type.dart';
import '../../domain/repositories/asset_repository.dart';
import '../local/database.dart';

class AssetRepositoryImpl implements AssetRepository {
  AssetRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  AssetCategoryEntity _mapCategory(AssetCategory row) => AssetCategoryEntity(
        id: row.id,
        name: row.name,
        iconKey: row.iconKey,
        color: Color(row.colorValue),
        isCustom: row.isCustom,
      );

  RiskLevelEntity _mapRisk(RiskLevel row) => RiskLevelEntity(
        id: row.id,
        name: row.name,
        rank: row.rank,
        color: Color(row.colorValue),
        maxSharePercent: row.maxSharePercent,
        isCustom: row.isCustom,
      );

  AssetValuePoint _mapPoint(AssetValue row) => AssetValuePoint(
        id: row.id,
        value: row.value,
        recordedAt: row.recordedAt,
      );

  @override
  Stream<List<AssetCategoryEntity>> watchCategories() {
    return (_db.select(_db.assetCategories)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_mapCategory).toList());
  }

  @override
  Stream<List<RiskLevelEntity>> watchRiskLevels() {
    return (_db.select(_db.riskLevels)
          ..orderBy([(t) => OrderingTerm(expression: t.rank)]))
        .watch()
        .map((rows) => rows.map(_mapRisk).toList());
  }

  @override
  Stream<List<AssetEntity>> watchAll() {
    // Активы, категории и уровни риска тянутся тремя выборками и
    // соединяются здесь, а не join-ом: справочники короткие, меняются
    // редко и всё равно нужны экрану целиком — для списков выбора.
    final query = _db.select(_db.assets).join([
      innerJoin(
        _db.assetCategories,
        _db.assetCategories.id.equalsExp(_db.assets.categoryId),
      ),
      innerJoin(
        _db.riskLevels,
        _db.riskLevels.id.equalsExp(_db.assets.riskLevelId),
      ),
    ])
      ..orderBy([OrderingTerm(expression: _db.assets.currentValue, mode: OrderingMode.desc)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final asset = row.readTable(_db.assets);
        return AssetEntity(
          id: asset.id,
          name: asset.name,
          category: _mapCategory(row.readTable(_db.assetCategories)),
          riskLevel: _mapRisk(row.readTable(_db.riskLevels)),
          cashFlowType: CashFlowType.fromStorageKey(asset.cashFlowType),
          currentValue: asset.currentValue,
          createdAt: asset.createdAt,
          note: asset.note,
        );
      }).toList();
    });
  }

  @override
  Stream<List<AssetValuePoint>> watchHistory(String assetId) {
    return (_db.select(_db.assetValues)
          ..where((t) => t.assetId.equals(assetId))
          ..orderBy([(t) => OrderingTerm(expression: t.recordedAt)]))
        .watch()
        .map((rows) => rows.map(_mapPoint).toList());
  }

  @override
  Future<Map<String, List<AssetValuePoint>>> historyByAsset() async {
    final rows = await (_db.select(_db.assetValues)
          ..orderBy([(t) => OrderingTerm(expression: t.recordedAt)]))
        .get();
    final result = <String, List<AssetValuePoint>>{};
    for (final row in rows) {
      result.putIfAbsent(row.assetId, () => []).add(_mapPoint(row));
    }
    return result;
  }

  @override
  Future<String> create({
    required String name,
    required String categoryId,
    required String riskLevelId,
    required CashFlowType cashFlowType,
    required double value,
    required DateTime valuedAt,
    String? note,
  }) async {
    final id = _uuid.v4();
    await _db.transaction(() async {
      await _db.into(_db.assets).insert(
            AssetsCompanion.insert(
              id: id,
              name: name,
              categoryId: categoryId,
              riskLevelId: riskLevelId,
              cashFlowType: cashFlowType.storageKey,
              currentValue: value,
              note: Value(note),
            ),
          );
      // Первая оценка — сразу точка истории. Иначе у актива, стоимость
      // которого ни разу не меняли, истории нет вовсе, и в динамике
      // капитала он появлялся бы из ниоткуда.
      await _db.into(_db.assetValues).insert(
            AssetValuesCompanion.insert(
              id: _uuid.v4(),
              assetId: id,
              value: value,
              recordedAt: valuedAt,
            ),
          );
    });
    return id;
  }

  @override
  Future<void> update({
    required String id,
    required String name,
    required String categoryId,
    required String riskLevelId,
    required CashFlowType cashFlowType,
    String? note,
  }) async {
    await (_db.update(_db.assets)..where((t) => t.id.equals(id))).write(
      AssetsCompanion(
        name: Value(name),
        categoryId: Value(categoryId),
        riskLevelId: Value(riskLevelId),
        cashFlowType: Value(cashFlowType.storageKey),
        note: Value(note),
      ),
    );
  }

  @override
  Future<void> revalue({
    required String assetId,
    required double value,
    required DateTime recordedAt,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.assetValues).insert(
            AssetValuesCompanion.insert(
              id: _uuid.v4(),
              assetId: assetId,
              value: value,
              recordedAt: recordedAt,
            ),
          );
      await _syncCurrentValue(assetId);
    });
  }

  @override
  Future<void> deleteValuePoint(String pointId) async {
    await _db.transaction(() async {
      final point = await (_db.select(_db.assetValues)
            ..where((t) => t.id.equals(pointId)))
          .getSingleOrNull();
      if (point == null) return;

      // Последнюю точку удалить нельзя: актив без единой оценки не имеет
      // стоимости, а значит и места в капитале. Удалять надо сам актив.
      final count = await (_db.select(_db.assetValues)
            ..where((t) => t.assetId.equals(point.assetId)))
          .get();
      if (count.length <= 1) return;

      await (_db.delete(_db.assetValues)..where((t) => t.id.equals(pointId)))
          .go();
      await _syncCurrentValue(point.assetId);
    });
  }

  /// Приводит текущую стоимость к самой свежей записи истории.
  ///
  /// Отдельным шагом, а не «записать переданное значение»: оценку можно
  /// внести задним числом, и тогда текущей она не становится.
  Future<void> _syncCurrentValue(String assetId) async {
    final latest = await (_db.select(_db.assetValues)
          ..where((t) => t.assetId.equals(assetId))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.recordedAt,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();
    if (latest == null) return;
    await (_db.update(_db.assets)..where((t) => t.id.equals(assetId)))
        .write(AssetsCompanion(currentValue: Value(latest.value)));
  }

  @override
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.assetValues)..where((t) => t.assetId.equals(id)))
          .go();
      await (_db.delete(_db.assets)..where((t) => t.id.equals(id))).go();
    });
  }

  @override
  Future<String> createCategory({
    required String name,
    required String iconKey,
    required Color color,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.assetCategories).insert(
          AssetCategoriesCompanion.insert(
            id: id,
            name: name,
            iconKey: iconKey,
            colorValue: color.toARGB32(),
            isCustom: const Value(true),
          ),
        );
    return id;
  }

  @override
  Future<void> updateCategory({
    required String id,
    required String name,
    required String iconKey,
    required Color color,
  }) async {
    await (_db.update(_db.assetCategories)..where((t) => t.id.equals(id)))
        .write(
      AssetCategoriesCompanion(
        name: Value(name),
        iconKey: Value(iconKey),
        colorValue: Value(color.toARGB32()),
      ),
    );
  }

  @override
  Future<bool> deleteCategory(String id) async {
    final used = await (_db.select(_db.assets)
          ..where((t) => t.categoryId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (used != null) return false;
    await (_db.delete(_db.assetCategories)..where((t) => t.id.equals(id))).go();
    return true;
  }

  @override
  Future<String> createRiskLevel({
    required String name,
    required int rank,
    required Color color,
    double? maxSharePercent,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.riskLevels).insert(
          RiskLevelsCompanion.insert(
            id: id,
            name: name,
            rank: rank,
            colorValue: color.toARGB32(),
            maxSharePercent: Value(maxSharePercent),
            isCustom: const Value(true),
          ),
        );
    return id;
  }

  @override
  Future<void> updateRiskLevel({
    required String id,
    required String name,
    required Color color,
    required double? maxSharePercent,
  }) async {
    await (_db.update(_db.riskLevels)..where((t) => t.id.equals(id))).write(
      RiskLevelsCompanion(
        name: Value(name),
        colorValue: Value(color.toARGB32()),
        maxSharePercent: Value(maxSharePercent),
      ),
    );
  }

  @override
  Future<bool> deleteRiskLevel(String id) async {
    final used = await (_db.select(_db.assets)
          ..where((t) => t.riskLevelId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (used != null) return false;

    // Последний уровень удалить нельзя: без единого уровня риска актив
    // нельзя создать вовсе.
    final remaining = await _db.select(_db.riskLevels).get();
    if (remaining.length <= 1) return false;

    await (_db.delete(_db.riskLevels)..where((t) => t.id.equals(id))).go();
    return true;
  }
}
