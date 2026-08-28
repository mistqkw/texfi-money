import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/savings_goal_entity.dart';
import '../../domain/repositories/savings_goal_repository.dart';
import '../local/database.dart';

class SavingsGoalRepositoryImpl implements SavingsGoalRepository {
  SavingsGoalRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  SavingsGoalEntity _mapRow(SavingsGoal row) => SavingsGoalEntity(
        id: row.id,
        title: row.title,
        targetAmount: row.targetAmount,
        currentAmount: row.currentAmount,
        deadline: row.deadline,
        color: Color(row.colorValue),
        createdAt: row.createdAt,
      );

  @override
  Stream<List<SavingsGoalEntity>> watchAll() {
    return (_db.select(_db.savingsGoals)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Future<String> create({
    required String title,
    required double targetAmount,
    DateTime? deadline,
    required Color color,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.savingsGoals).insert(SavingsGoalsCompanion.insert(
          id: id,
          title: title,
          targetAmount: targetAmount,
          deadline: Value(deadline),
          colorValue: color.toARGB32(),
        ));
    return id;
  }

  @override
  Future<void> addContribution({required String id, required double amount}) async {
    final goal = await (_db.select(_db.savingsGoals)..where((t) => t.id.equals(id)))
        .getSingle();
    final updated = (goal.currentAmount + amount).clamp(0, double.infinity);
    await (_db.update(_db.savingsGoals)..where((t) => t.id.equals(id))).write(
      SavingsGoalsCompanion(currentAmount: Value(updated.toDouble())),
    );
  }

  @override
  Future<void> update(SavingsGoalEntity goal) {
    return (_db.update(_db.savingsGoals)..where((t) => t.id.equals(goal.id))).write(
      SavingsGoalsCompanion(
        title: Value(goal.title),
        targetAmount: Value(goal.targetAmount),
        deadline: Value(goal.deadline),
        colorValue: Value(goal.color.toARGB32()),
      ),
    );
  }

  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.savingsGoals)..where((t) => t.id.equals(id))).go();
  }
}
