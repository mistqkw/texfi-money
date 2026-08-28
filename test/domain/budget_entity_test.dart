import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/domain/entities/budget_entity.dart';
import 'package:texfi_money/domain/entities/category_entity.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';

CategoryEntity _category() => const CategoryEntity(
      id: 'cat_test',
      name: 'Тест',
      iconKey: 'other',
      color: Color(0xFF4A7DFB),
      type: TransactionType.expense,
      isCustom: false,
    );

void main() {
  group('BudgetEntity', () {
    test('progress считается как spent/monthlyLimit', () {
      final budget = BudgetEntity(id: '1', category: _category(), monthlyLimit: 1000, spent: 250);
      expect(budget.progress, closeTo(0.25, 0.0001));
    });

    test('progress ограничен единицей при превышении лимита', () {
      final budget = BudgetEntity(id: '1', category: _category(), monthlyLimit: 1000, spent: 1500);
      expect(budget.progress, 1.0);
    });

    test('нулевой лимит не приводит к делению на ноль', () {
      final budget = BudgetEntity(id: '1', category: _category(), monthlyLimit: 0, spent: 100);
      expect(budget.progress, 0);
    });

    test('isOverLimit true при превышении лимита', () {
      final budget = BudgetEntity(id: '1', category: _category(), monthlyLimit: 1000, spent: 1200);
      expect(budget.isOverLimit, isTrue);
    });

    test('isOverLimit false, если лимит не превышен', () {
      final budget = BudgetEntity(id: '1', category: _category(), monthlyLimit: 1000, spent: 1000);
      expect(budget.isOverLimit, isFalse);
    });

    test('isNearLimit true на пороге 85%, но false при превышении и в безопасной зоне', () {
      final near = BudgetEntity(id: '1', category: _category(), monthlyLimit: 1000, spent: 900);
      final over = BudgetEntity(id: '2', category: _category(), monthlyLimit: 1000, spent: 1100);
      final safe = BudgetEntity(id: '3', category: _category(), monthlyLimit: 1000, spent: 500);

      expect(near.isNearLimit, isTrue);
      expect(over.isNearLimit, isFalse);
      expect(safe.isNearLimit, isFalse);
    });

    test('remaining вычисляется корректно и не уходит в минус при перерасходе', () {
      final normal = BudgetEntity(id: '1', category: _category(), monthlyLimit: 1000, spent: 400);
      final overspent = BudgetEntity(id: '2', category: _category(), monthlyLimit: 1000, spent: 1300);

      expect(normal.remaining, 600);
      expect(overspent.remaining, 0);
    });
  });
}
