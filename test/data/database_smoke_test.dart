import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/data/local/database.dart';
import 'package:texfi_money/data/repositories/budget_repository_impl.dart';
import 'package:texfi_money/data/repositories/category_repository_impl.dart';
import 'package:texfi_money/data/repositories/savings_goal_repository_impl.dart';
import 'package:texfi_money/data/repositories/transaction_repository_impl.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('сидирует предустановленные категории при первом открытии', () async {
    final categoryRepo = CategoryRepositoryImpl(db);
    final categories = await categoryRepo.watchAll().first;

    expect(categories, isNotEmpty);
    expect(categories.any((c) => c.id == 'cat_groceries'), isTrue);
    expect(categories.any((c) => c.type == TransactionType.income), isTrue);
  });

  test('добавление транзакции отражается в балансе и месячной сводке', () async {
    final txRepo = TransactionRepositoryImpl(db, CategoryRepositoryImpl(db));
    final now = DateTime.now();

    await txRepo.add(
      amount: 1000,
      type: TransactionType.income,
      categoryId: 'cat_salary',
      date: now,
    );
    await txRepo.add(
      amount: 300,
      type: TransactionType.expense,
      categoryId: 'cat_groceries',
      date: now,
    );

    final balance = await txRepo.watchTotalBalance().first;
    expect(balance, 700);

    final summary = await txRepo.watchMonthlySummary(now).first;
    expect(summary.income, 1000);
    expect(summary.expense, 300);
  });

  test('бюджет по категории считает потраченное за месяц', () async {
    final categoryRepo = CategoryRepositoryImpl(db);
    final txRepo = TransactionRepositoryImpl(db, categoryRepo);
    final budgetRepo = BudgetRepositoryImpl(db, categoryRepo);
    final now = DateTime.now();

    await budgetRepo.setLimit(categoryId: 'cat_groceries', monthlyLimit: 500);
    await txRepo.add(
      amount: 200,
      type: TransactionType.expense,
      categoryId: 'cat_groceries',
      date: now,
    );

    final budgets = await budgetRepo.watchAll(now).first;
    final groceries = budgets.firstWhere((b) => b.category.id == 'cat_groceries');

    expect(groceries.monthlyLimit, 500);
    expect(groceries.spent, 200);
    expect(groceries.isOverLimit, isFalse);
  });

  test('цель накопления обновляет прогресс при взносе', () async {
    final goalRepo = SavingsGoalRepositoryImpl(db);

    final id = await goalRepo.create(
      title: 'ПК',
      targetAmount: 1000,
      color: const Color(0xFF4A7DFB),
    );
    await goalRepo.addContribution(id: id, amount: 250);

    final goals = await goalRepo.watchAll().first;
    final goal = goals.firstWhere((g) => g.id == id);

    expect(goal.currentAmount, 250);
    expect(goal.progress, closeTo(0.25, 0.0001));
    expect(goal.isCompleted, isFalse);
  });
}
