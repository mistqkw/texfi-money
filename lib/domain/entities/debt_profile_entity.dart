import 'package:flutter/material.dart';

class DebtProfileEntity {
  const DebtProfileEntity({
    required this.id,
    required this.name,
    required this.balance,
    required this.color,
    required this.createdAt,
  });

  final String id;
  final String name;

  /// Положительный — человек должен пользователю; отрицательный —
  /// пользователь должен человеку.
  final double balance;
  final Color color;
  final DateTime createdAt;
}
