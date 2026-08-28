import 'package:flutter/material.dart';

class SavingsGoalEntity {
  const SavingsGoalEntity({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.color,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final Color color;
  final DateTime createdAt;

  double get progress =>
      targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0, 1);

  bool get isCompleted => currentAmount >= targetAmount;

  double get remaining => (targetAmount - currentAmount).clamp(0, double.infinity);

  int? get daysLeft => deadline?.difference(DateTime.now()).inDays;
}
