import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/domain/entities/savings_goal_entity.dart';

SavingsGoalEntity _goal({
  double target = 1000,
  double current = 0,
  DateTime? deadline,
}) {
  return SavingsGoalEntity(
    id: 'goal_test',
    title: 'Тест',
    targetAmount: target,
    currentAmount: current,
    deadline: deadline,
    color: const Color(0xFF4A7DFB),
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('SavingsGoalEntity', () {
    test('progress считается как currentAmount/targetAmount', () {
      expect(_goal(target: 1000, current: 250).progress, closeTo(0.25, 0.0001));
    });

    test('progress ограничен единицей при перевыполнении цели', () {
      expect(_goal(target: 1000, current: 1500).progress, 1.0);
    });

    test('нулевая целевая сумма не приводит к делению на ноль', () {
      expect(_goal(target: 0, current: 100).progress, 0);
    });

    test('isCompleted true, когда накоплено не меньше цели', () {
      expect(_goal(target: 1000, current: 1000).isCompleted, isTrue);
      expect(_goal(target: 1000, current: 999).isCompleted, isFalse);
    });

    test('remaining не уходит в минус при перевыполнении', () {
      expect(_goal(target: 1000, current: 1200).remaining, 0);
      expect(_goal(target: 1000, current: 400).remaining, 600);
    });

    test('daysLeft положителен для будущего дедлайна, отрицателен для прошедшего, null без дедлайна', () {
      final future = _goal(deadline: DateTime.now().add(const Duration(days: 10)));
      final past = _goal(deadline: DateTime.now().subtract(const Duration(days: 5)));
      final none = _goal();

      expect(future.daysLeft, greaterThan(0));
      expect(past.daysLeft, lessThan(0));
      expect(none.daysLeft, isNull);
    });

    test('copyWith clearDeadline сбрасывает дедлайн', () {
      final withDeadline = _goal(deadline: DateTime(2026, 12, 31));
      final cleared = withDeadline.copyWith(clearDeadline: true);

      expect(cleared.deadline, isNull);
      expect(cleared.title, withDeadline.title);
    });
  });
}
