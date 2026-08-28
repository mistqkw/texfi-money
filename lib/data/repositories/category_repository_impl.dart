import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../local/database.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  CategoryEntity mapRow(Category row) => CategoryEntity(
        id: row.id,
        name: row.name,
        iconKey: row.iconKey,
        color: Color(row.colorValue),
        type: TransactionType.fromStorageKey(row.type),
        isCustom: row.isCustom,
      );

  @override
  Stream<List<CategoryEntity>> watchAll() {
    return (_db.select(_db.categories)
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch()
        .map((rows) => rows.map(mapRow).toList());
  }

  @override
  Stream<List<CategoryEntity>> watchByType(TransactionType type) {
    return (_db.select(_db.categories)
          ..where((t) => t.type.equals(type.storageKey))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch()
        .map((rows) => rows.map(mapRow).toList());
  }

  @override
  Future<CategoryEntity> create({
    required String name,
    required String iconKey,
    required int colorValue,
    required TransactionType type,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.categories).insert(CategoriesCompanion.insert(
          id: id,
          name: name,
          iconKey: iconKey,
          colorValue: colorValue,
          type: type.storageKey,
          isCustom: const Value(true),
        ));
    return CategoryEntity(
      id: id,
      name: name,
      iconKey: iconKey,
      color: Color(colorValue),
      type: type,
      isCustom: true,
    );
  }

  @override
  Future<void> update(CategoryEntity category) {
    return (_db.update(_db.categories)..where((t) => t.id.equals(category.id)))
        .write(CategoriesCompanion(
      name: Value(category.name),
      iconKey: Value(category.iconKey),
      colorValue: Value(category.color.toARGB32()),
    ));
  }

  @override
  Future<void> delete(String id) async {
    final inUse = await (_db.select(_db.transactions)
          ..where((t) => t.categoryId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (inUse != null) {
      throw CategoryInUseException();
    }

    await (_db.delete(_db.budgets)..where((t) => t.categoryId.equals(id))).go();
    await (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();
  }
}
