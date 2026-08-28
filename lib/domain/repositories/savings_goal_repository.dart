import 'package:flutter/material.dart';

import '../entities/savings_goal_entity.dart';

abstract class SavingsGoalRepository {
  Stream<List<SavingsGoalEntity>> watchAll();

  Future<String> create({
    required String title,
    required double targetAmount,
    DateTime? deadline,
    required Color color,
  });

  /// Добавляет сумму к текущему прогрессу (может быть отрицательной для отмены).
  Future<void> addContribution({required String id, required double amount});

  Future<void> update(SavingsGoalEntity goal);
  Future<void> delete(String id);
}
