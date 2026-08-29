import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/domain/entities/budget_entity.dart';
import 'package:texfi_money/domain/entities/category_entity.dart';
import 'package:texfi_money/domain/entities/savings_goal_entity.dart';
import 'package:texfi_money/domain/entities/transaction_entity.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';
import 'package:texfi_money/domain/nudges.dart';

final _groceries = CategoryEntity(
  id: 'cat_groceries',
  name: 'Продукты',
  iconKey: 'cart',
  color: const Color(0xFF4A7DFB),
  type: TransactionType.expense,
  isCustom: false,
);

final _transport = CategoryEntity(
  id: 'cat_transport',
  name: 'Транспорт',
  iconKey: 'bus',
  color: const Color(0xFF28C840),
  type: TransactionType.expense,
  isCustom: false,
);

TransactionEntity _tx({
  required String id,
  required double amount,
  required DateTime date,
  CategoryEntity? category,
  TransactionType type = TransactionType.expense,
}) {
  return TransactionEntity(
    id: id,
    amount: amount,
    type: type,
    category: category ?? _groceries,
    date: date,
    createdAt: date,
  );
}

void main() {
  final now = DateTime(2026, 3, 20);

  group('нетипичная сумма', () {
    test('крупная трата на фоне ровных обычных попадает в подсказки', () {
      final nudges = buildNudges(
        transactions: [
          _tx(id: 'big', amount: 5000, date: DateTime(2026, 3, 20)),
          _tx(id: 'a', amount: 500, date: DateTime(2026, 3, 19)),
          _tx(id: 'b', amount: 400, date: DateTime(2026, 3, 18)),
          _tx(id: 'c', amount: 600, date: DateTime(2026, 3, 17)),
        ],
        budgets: const [],
        goals: const [],
        now: now,
      );

      final unusual = nudges.where((n) => n.kind == NudgeKind.unusualAmount).toList();
      expect(unusual, hasLength(1));
      expect(unusual.single.transaction?.id, 'big');
      expect(unusual.single.ratio, closeTo(10, 0.01));
    });

    test('обычная по величине трата подсказку не вызывает', () {
      final nudges = buildNudges(
        transactions: [
          _tx(id: 'latest', amount: 520, date: DateTime(2026, 3, 20)),
          _tx(id: 'a', amount: 500, date: DateTime(2026, 3, 19)),
          _tx(id: 'b', amount: 400, date: DateTime(2026, 3, 18)),
          _tx(id: 'c', amount: 600, date: DateTime(2026, 3, 17)),
        ],
        budgets: const [],
        goals: const [],
        now: now,
      );

      expect(nudges.where((n) => n.kind == NudgeKind.unusualAmount), isEmpty);
    });

    test('без достаточной истории категории аномалия не объявляется', () {
      final nudges = buildNudges(
        transactions: [
          _tx(id: 'big', amount: 5000, date: DateTime(2026, 3, 20)),
          _tx(id: 'a', amount: 500, date: DateTime(2026, 3, 19)),
        ],
        budgets: const [],
        goals: const [],
        now: now,
      );

      expect(nudges.where((n) => n.kind == NudgeKind.unusualAmount), isEmpty);
    });

    test('средняя считается только по своей категории', () {
      // Крупная трата на транспорт не должна сравниваться с продуктами.
      final nudges = buildNudges(
        transactions: [
          _tx(id: 'taxi', amount: 900, date: DateTime(2026, 3, 20), category: _transport),
          _tx(id: 't1', amount: 800, date: DateTime(2026, 3, 19), category: _transport),
          _tx(id: 't2', amount: 700, date: DateTime(2026, 3, 18), category: _transport),
          _tx(id: 't3', amount: 900, date: DateTime(2026, 3, 17), category: _transport),
          _tx(id: 'g1', amount: 10, date: DateTime(2026, 3, 16)),
        ],
        budgets: const [],
        goals: const [],
        now: now,
      );

      expect(nudges.where((n) => n.kind == NudgeKind.unusualAmount), isEmpty);
    });

    test('доходы не считаются аномальными тратами', () {
      final nudges = buildNudges(
        transactions: [
          _tx(
            id: 'salary',
            amount: 99999,
            date: DateTime(2026, 3, 20),
            type: TransactionType.income,
          ),
          _tx(id: 'a', amount: 500, date: DateTime(2026, 3, 19)),
          _tx(id: 'b', amount: 400, date: DateTime(2026, 3, 18)),
          _tx(id: 'c', amount: 600, date: DateTime(2026, 3, 17)),
        ],
        budgets: const [],
        goals: const [],
        now: now,
      );

      expect(nudges.where((n) => n.kind == NudgeKind.unusualAmount), isEmpty);
    });
  });

  group('бюджеты', () {
    test('превышенный бюджет даёт подсказку с суммой перерасхода', () {
      final nudges = buildNudges(
        transactions: const [],
        budgets: [
          BudgetEntity(id: 'b1', category: _groceries, monthlyLimit: 1000, spent: 1300),
        ],
        goals: const [],
        now: now,
      );

      final over = nudges.singleWhere((n) => n.kind == NudgeKind.budgetOver);
      expect(over.overAmount, 300);
      expect(over.categoryId, 'cat_groceries');
    });

    test('бюджет у порога даёт предупреждение, а не перерасход', () {
      final nudges = buildNudges(
        transactions: const [],
        budgets: [
          BudgetEntity(id: 'b1', category: _groceries, monthlyLimit: 1000, spent: 900),
        ],
        goals: const [],
        now: now,
      );

      expect(nudges.single.kind, NudgeKind.budgetClose);
      expect(nudges.single.percent, closeTo(90, 0.01));
    });

    test('бюджет с запасом молчит', () {
      final nudges = buildNudges(
        transactions: const [],
        budgets: [
          BudgetEntity(id: 'b1', category: _groceries, monthlyLimit: 1000, spent: 200),
        ],
        goals: const [],
        now: now,
      );

      expect(nudges, isEmpty);
    });

    test('перерасход идёт раньше остальных подсказок', () {
      final nudges = buildNudges(
        transactions: [
          _tx(id: 'big', amount: 5000, date: DateTime(2026, 3, 20)),
          _tx(id: 'a', amount: 500, date: DateTime(2026, 3, 19)),
          _tx(id: 'b', amount: 400, date: DateTime(2026, 3, 18)),
          _tx(id: 'c', amount: 600, date: DateTime(2026, 3, 17)),
        ],
        budgets: [
          BudgetEntity(id: 'b1', category: _groceries, monthlyLimit: 1000, spent: 1300),
        ],
        goals: const [],
        now: now,
      );

      expect(nudges.first.kind, NudgeKind.budgetOver);
    });
  });

  group('цели', () {
    test('почти собранная цель подталкивает к финишу', () {
      final nudges = buildNudges(
        transactions: const [],
        budgets: const [],
        goals: [
          SavingsGoalEntity(
            id: 'g1',
            title: 'ПК',
            targetAmount: 1000,
            currentAmount: 850,
            color: const Color(0xFF4A7DFB),
            createdAt: now,
          ),
        ],
        now: now,
      );

      final goal = nudges.singleWhere((n) => n.kind == NudgeKind.goalClose);
      expect(goal.goalTitle, 'ПК');
      expect(goal.percent, closeTo(85, 0.01));
    });

    test('достигнутая цель уже не подталкивает', () {
      final nudges = buildNudges(
        transactions: const [],
        budgets: const [],
        goals: [
          SavingsGoalEntity(
            id: 'g1',
            title: 'ПК',
            targetAmount: 1000,
            currentAmount: 1000,
            color: const Color(0xFF4A7DFB),
            createdAt: now,
          ),
        ],
        now: now,
      );

      expect(nudges, isEmpty);
    });
  });

  group('давно нет записей', () {
    test('после трёх дней тишины напоминаем', () {
      final nudges = buildNudges(
        transactions: [_tx(id: 'a', amount: 100, date: DateTime(2026, 3, 17))],
        budgets: const [],
        goals: const [],
        now: now,
      );

      final quiet = nudges.singleWhere((n) => n.kind == NudgeKind.quietDays);
      expect(quiet.days, 3);
    });

    test('вчерашняя запись — не повод напоминать', () {
      final nudges = buildNudges(
        transactions: [_tx(id: 'a', amount: 100, date: DateTime(2026, 3, 19))],
        budgets: const [],
        goals: const [],
        now: now,
      );

      expect(nudges.where((n) => n.kind == NudgeKind.quietDays), isEmpty);
    });

    test('на пустой истории подсказок нет вообще', () {
      final nudges = buildNudges(
        transactions: const [],
        budgets: const [],
        goals: const [],
        now: now,
      );

      expect(nudges, isEmpty);
    });
  });

  test('id подсказки стабилен между вызовами при тех же данных', () {
    List<Nudge> run() => buildNudges(
          transactions: const [],
          budgets: [
            BudgetEntity(id: 'b1', category: _groceries, monthlyLimit: 1000, spent: 900),
          ],
          goals: const [],
          now: now,
        );

    expect(run().single.id, run().single.id);
  });
}
