import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/debt_profile_entity.dart';
import '../../domain/repositories/debt_profile_repository.dart';
import '../local/database.dart';

class DebtProfileRepositoryImpl implements DebtProfileRepository {
  DebtProfileRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  DebtProfileEntity _mapRow(DebtProfile row) => DebtProfileEntity(
        id: row.id,
        name: row.name,
        balance: row.balance,
        color: Color(row.colorValue),
        createdAt: row.createdAt,
      );

  @override
  Stream<List<DebtProfileEntity>> watchAll() {
    return (_db.select(_db.debtProfiles)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Future<String> create({required String name, required Color color}) async {
    final id = _uuid.v4();
    await _db.into(_db.debtProfiles).insert(DebtProfilesCompanion.insert(
          id: id,
          name: name,
          colorValue: color.toARGB32(),
        ));
    return id;
  }

  @override
  Future<void> adjustBalance({required String id, required double delta}) async {
    final profile =
        await (_db.select(_db.debtProfiles)..where((t) => t.id.equals(id))).getSingle();
    await (_db.update(_db.debtProfiles)..where((t) => t.id.equals(id))).write(
      DebtProfilesCompanion(balance: Value(profile.balance + delta)),
    );
  }

  @override
  Future<void> update(DebtProfileEntity profile) {
    return (_db.update(_db.debtProfiles)..where((t) => t.id.equals(profile.id))).write(
      DebtProfilesCompanion(
        name: Value(profile.name),
        colorValue: Value(profile.color.toARGB32()),
      ),
    );
  }

  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.debtProfiles)..where((t) => t.id.equals(id))).go();
  }
}
