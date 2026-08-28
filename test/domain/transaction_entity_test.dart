import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/domain/entities/category_entity.dart';
import 'package:texfi_money/domain/entities/transaction_entity.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';

CategoryEntity _category(TransactionType type) => CategoryEntity(
      id: 'cat_test',
      name: 'Тест',
      iconKey: 'other',
      color: const Color(0xFF4A7DFB),
      type: type,
      isCustom: false,
    );

void main() {
  group('TransactionEntity.signedAmount', () {
    test('положителен для дохода', () {
      final tx = TransactionEntity(
        id: '1',
        amount: 500,
        type: TransactionType.income,
        category: _category(TransactionType.income),
        date: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
      );

      expect(tx.signedAmount, 500);
    });

    test('отрицателен для расхода', () {
      final tx = TransactionEntity(
        id: '2',
        amount: 500,
        type: TransactionType.expense,
        category: _category(TransactionType.expense),
        date: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
      );

      expect(tx.signedAmount, -500);
    });
  });
}
